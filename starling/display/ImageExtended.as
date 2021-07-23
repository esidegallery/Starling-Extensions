package starling.display
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.core.Starling;
	import starling.rendering.Painter;
	import starling.textures.Texture;
	import starling.utils.Color;
	import starling.utils.Pool;

	/**
	 * Fixes bug in drawToBitmapData.
	 */
	public class ImageExtended extends Image
	{
		private static const HELPER_RECTANGLE:Rectangle = new Rectangle;

		public function ImageExtended(texture:Texture)
		{
			super(texture);
		}

		override public function drawToBitmapData(out:BitmapData = null, color:uint = 0, alpha:Number = 0.0):BitmapData
		{
			var painter:Painter = Starling.painter;
            var stage:Stage = Starling.current.stage;
            var viewPort:Rectangle = Starling.current.viewPort;
            var stageWidth:Number  = stage.stageWidth;
            var stageHeight:Number = stage.stageHeight;
            var scaleX:Number = viewPort.width  / stageWidth;
            var scaleY:Number = viewPort.height / stageHeight;
            var backBufferScale:Number = painter.backBufferScaleFactor;
            var totalScaleX:Number = scaleX * backBufferScale;
            var totalScaleY:Number = scaleY * backBufferScale;
            var projectionX:Number, projectionY:Number;
            var bounds:Rectangle;

            if (this is Stage)
            {
                projectionX = viewPort.x < 0 ? -viewPort.x / scaleX : 0.0;
                projectionY = viewPort.y < 0 ? -viewPort.y / scaleY : 0.0;

                out ||= new BitmapData(painter.backBufferWidth  * backBufferScale,
                                       painter.backBufferHeight * backBufferScale);
            }
            else
            {
                bounds = getBounds(parent, HELPER_RECTANGLE);
                projectionX = bounds.x;
                projectionY = bounds.y;

                out ||= new BitmapData(Math.ceil(bounds.width  * totalScaleX),
                                       Math.ceil(bounds.height * totalScaleY));
            }

            color = Color.multiply(color, alpha); // premultiply alpha

            painter.pushState();
            painter.setupContextDefaults();
            painter.state.renderTarget = null;
            painter.state.setModelviewMatricesToIdentity();
            painter.setStateTo(transformationMatrix);

			// Images that are bigger than the current back buffer are drawn in multiple steps.

            var stepX:Number;
            var stepY:Number = projectionY;
            var stepWidth:Number  = painter.backBufferWidth  / scaleX;
            var stepHeight:Number = painter.backBufferHeight / scaleY;
            var positionInBitmap:Point = Pool.getPoint(0, 0);
            var boundsInBuffer:Rectangle = Pool.getRectangle(0, 0,
                    painter.backBufferWidth  * backBufferScale,
                    painter.backBufferHeight * backBufferScale);

            while (positionInBitmap.y < out.height)
            {
                stepX = projectionX;
                positionInBitmap.x = 0;
				
                while (positionInBitmap.x < out.width)
                {					
                    painter.clear(color, alpha);
                    painter.state.setProjectionMatrix(stepX, stepY, stepWidth, stepHeight,
                        stageWidth, stageHeight, stage.cameraPosition);

                    if (mask)   painter.drawMask(mask, this);

                    if (filter) filter.render(painter);
                    else         render(painter);

                    if (mask)   painter.eraseMask(mask, this);

                    painter.finishMeshBatch();
                    //line 478 - for some reason the bitmapdata is distorted depending the size of the stageHeight and stageWidth on windows. Throwing in an additional bitmapdata and using copyPixels method fixes it.
					var bmd:BitmapData = new BitmapData(stepWidth, stepHeight, true, 0x00ffffff);
					painter.context.drawToBitmapData(bmd, boundsInBuffer);
					out.copyPixels(bmd, boundsInBuffer,positionInBitmap);

                    stepX += stepWidth;
                    positionInBitmap.x += stepWidth * totalScaleX;
                }
                stepY += stepHeight;
                positionInBitmap.y += stepHeight * totalScaleY;
            }

            painter.popState();

            Pool.putRectangle(boundsInBuffer);
            Pool.putPoint(positionInBitmap);

            return out;
		}
	}
}