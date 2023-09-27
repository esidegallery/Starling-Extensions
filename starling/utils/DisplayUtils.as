package starling.utils
{
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
	}
}