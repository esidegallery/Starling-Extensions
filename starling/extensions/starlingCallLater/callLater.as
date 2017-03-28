package starling.extensions.starlingCallLater
{
	/** Convenience method for <code>StarlingCallLater.callLater()</code>. */
	public function callLater(method:Function, args:Array = null, nextFrameBut:uint = 0, allowDuplicate:Boolean = false):void
	{
		StarlingCallLater.callLater(method, args, nextFrameBut, allowDuplicate);
	}
}