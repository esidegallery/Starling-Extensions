package starling.extensions.flashEventWrapper
{
	import flash.events.Event;
	
	import starling.extensions.flashEventWrapper.FlashEventWrapper;
	
	import starling.events.Event;
	
	/** Convenience method for <code>FlashEventWrapper.wrapFlashEvent()</code>. */
	public function wrapFlashEvent(event:flash.events.Event):starling.events.Event
	{
		return FlashEventWrapper.wrapFlashEvent(event);
	}
}