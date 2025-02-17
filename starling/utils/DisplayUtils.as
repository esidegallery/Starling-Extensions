package starling.utils
{
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;

	public class DisplayUtils
	{
		/**
		 * Sorts the <code>DisplayObjects</code> by their depth on stage, recursively from the lowest to the highest.
		 * Objects not on the stage will be considered lower than those on-stage.
		 * This function assumes that there is only 1 stage instance.
		 */
		public static function depthSortCompareFunction(c1:DisplayObject, c2:DisplayObject):Number
		{
			if (c1 == c2)
			{
				return 0;
			}
			if (c1 == null)
			{
				return c2 == null ? 0 : -1;
			}
			if (c2 == null)
			{
				return 1;
			}
			if (c1.stage == null && c2.stage != null)
			{
				return -1;
			}
			if (c2.stage == null && c1.stage != null)
			{
				return 1;
			}
			// Get the ancestry of both components:
			var c1Ancestry:Vector.<DisplayObject> = new <DisplayObject>[c1];
			var c2Ancestry:Vector.<DisplayObject> = new <DisplayObject>[c2];
			var parent:DisplayObjectContainer = c1.parent;
			while (parent != null)
			{
				c1Ancestry.unshift(parent);
				parent = parent.parent;
			}
			parent = c2.parent;
			while (parent != null)
			{
				c2Ancestry.unshift(parent);
				parent = parent.parent;
			}
			// Then walk down from root to find highest in hierarchy:
			if (c1Ancestry[0] == c2Ancestry[0])
			{
				for (var i:int = 0, l:int = Math.min(c1Ancestry.length, c2Ancestry.length); i < l; i++)
				{
					var container1:DisplayObject = c1Ancestry[i];
					var container2:DisplayObject = c2Ancestry[i];
					if (container1 != container2)
					{
						parent = container1.parent;
						return parent.getChildIndex(container1) - parent.getChildIndex(container2);
					}
				}
				// One contains the other:
				return c1Ancestry.length > c2Ancestry.length ? 1 : -1;
			}
			// Different stages or item the same:
			return 0;
		}

		public static function getGlobalScale(displayObject:DisplayObject, out:Point = null):Point
		{
			if (out == null)
			{
				out = new Point;
			}
			if (displayObject == null)
			{
				out.setTo(NaN, NaN);
				return out;
			}
			out.setTo(1, 1);
			while (displayObject != null)
			{
				out.setTo(out.x * displayObject.scaleX, out.y * displayObject.scaleY);
				displayObject = displayObject.parent;
			}
			return out;
		}

		/**
		 * Draws a rectangle to Starling's nativeOverlay graphics layer in an optional target space.
		 * @param rect The rectangle to draw.
		 * @param targetSpace The space to draw the rectangle in. If null, the rectangle will be drawn in the global space.
		 * @param color The color of the rectangle.
		 * @param alpha The alpha of the rectangle.
		 */
		public static function drawToNativeOverlayGraphics(rect:Rectangle, targetSpace:DisplayObject = null, color:uint = 0xFF0000, alpha:Number = 1):void
		{
			if (targetSpace != null)
			{
				var topLeft:Point = Pool.getPoint(rect.left, rect.top);
				targetSpace.localToGlobal(topLeft, topLeft);
				var bottomRight:Point = Pool.getPoint(rect.right, rect.bottom);
				targetSpace.localToGlobal(bottomRight, bottomRight);
				var x:Number = topLeft.x;
				var y:Number = topLeft.y;
				var width:Number = bottomRight.x - x;
				var height:Number = bottomRight.y - y;
				Pool.putPoint(topLeft);
				Pool.putPoint(bottomRight);
			}
			else
			{
				x = rect.x;
				y = rect.y;
				width = rect.width;
				height = rect.height;
			}

			var graphics:Graphics = Starling.current.nativeOverlay.graphics;
			graphics.lineStyle(NaN);
			graphics.beginFill(color, alpha);
			graphics.drawRect(x, y, width, height);
			graphics.endFill();
		}

		public static function clearNativeOverlayGraphics():void
		{
			Starling.current.nativeOverlay.graphics.clear();
		}
	}
}