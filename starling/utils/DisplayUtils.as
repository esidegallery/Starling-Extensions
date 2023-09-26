package starling.utils
{
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;

	public class DisplayUtils
	{
		public static function depthSortCompareFunction(c1:DisplayObject, c2:DisplayObject):Number
		{
			// Get the ancestry of both components:
			var c1Ancestry:Vector.<DisplayObjectContainer> = new Vector.<DisplayObjectContainer>;
			var c2Ancestry:Vector.<DisplayObjectContainer> = new Vector.<DisplayObjectContainer>;
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
				for (var i:int = 1, l:int = Math.min(c1Ancestry.length, c2Ancestry.length); i < l; i++)
				{
					var container1:DisplayObjectContainer = c1Ancestry[i];
					var container2:DisplayObjectContainer = c2Ancestry[i];
					if (container1 != container2)
					{
						parent = container1.parent;
						return parent.getChildIndex(container1) - parent.getChildIndex(container2);
					}
				}
			}
			return 0;
		}		
	}
}