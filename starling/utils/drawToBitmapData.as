package starling.utils
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Stage;
	import starling.rendering.Painter;
	import starling.utils.Color;
	import starling.utils.Pool;

	/** Fixes issues with the default Starling implementation of DisplayObject.drawToBitmapData(). */
	public function drawToBitmapData(target:DisplayObject, out:BitmapData = null, color:uint = 0, alpha:Number = 0):BitmapData
	{
		var painter:Painter = Starling.painter;
		var stage:Stage = Starling.current.stage;
		var viewPort:Rectangle = Starling.current.viewPort;
		var stageWidth:Number = stage.stageWidth;
		var stageHeight:Number = stage.stageHeight;
		var scaleX:Number = viewPort.width / stageWidth;
		var scaleY:Number = viewPort.height / stageHeight;
		var backBufferScale:Number = painter.backBufferScaleFactor;
		var totalScaleX:Number = scaleX * backBufferScale;
		var totalScaleY:Number = scaleY * backBufferScale;
		var projectionX:Number, projectionY:Number;
		var bounds:Rectangle;

		bounds = target.getBounds(target.parent, Pool.getRectangle());
		projectionX = bounds.x;
		projectionY = bounds.y;

		out ||= new BitmapData(
				Math.ceil(bounds.width * totalScaleX),
				Math.ceil(bounds.height * totalScaleY));

		color = Color.multiply(color, alpha); // Premultiply alpha

		painter.pushState();
		painter.setupContextDefaults();
		painter.state.renderTarget = null;
		painter.state.setModelviewMatricesToIdentity();
		painter.setStateTo(target.transformationMatrix);

		// Images that are bigger than the current back buffer are drawn in multiple steps.
		var stepX:Number;
		var stepY:Number = projectionY;
		var stepWidth:int = painter.backBufferWidth / scaleX;
		var stepHeight:int = painter.backBufferHeight / scaleY;
		var positionInBitmap:Point = Pool.getPoint(0, 0);
		var boundsInBuffer:Rectangle = Pool.getRectangle(
				0, 0,
				Math.floor(painter.backBufferWidth * backBufferScale),
				Math.floor(painter.backBufferHeight * backBufferScale));

		while (positionInBitmap.y < out.height)
		{
			stepX = projectionX;
			positionInBitmap.x = 0;

			while (positionInBitmap.x < out.width)
			{
				painter.clear(color, alpha);
				painter.state.setProjectionMatrix(
						stepX, stepY, stepWidth, stepHeight,
						stageWidth, stageHeight, stage.cameraPosition);

				if (target.mask)
				{
					painter.drawMask(target.mask, target);
				}

				if (target.filter)
				{
					target.filter.render(painter);
				}
				else
				{
					target.render(painter);
				}

				if (target.mask)
				{
					painter.eraseMask(target.mask, target);
				}

				painter.finishMeshBatch();
				// For some reason the bitmapdata is distorted depending the size of the stageHeight and stageWidth on windows.
				// Throwing in an additional bitmapdata and using copyPixels method fixes it.
				var bmd:BitmapData = new BitmapData(Math.ceil(stepWidth * backBufferScale), Math.ceil(stepHeight * backBufferScale), true, 0x00ffffff);
				painter.context.drawToBitmapData(bmd, boundsInBuffer);
				out.copyPixels(bmd, boundsInBuffer, positionInBitmap);

				stepX += stepWidth;
				positionInBitmap.x += Math.floor(stepWidth * totalScaleX);
			}
			stepY += stepHeight;
			positionInBitmap.y += Math.floor(stepHeight * totalScaleY);
		}

		painter.popState();

		Pool.putRectangle(bounds);
		Pool.putRectangle(boundsInBuffer);
		Pool.putPoint(positionInBitmap);

		return out;
	}
}