package starling.extensions.flashEventWrapper
{
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;

	import starling.events.Event;

	public class FlashEventWrapper
	{
		/**
		 * Qualifies a Flash event's type by prepending the qualified event class name.
		 * Eliminates duplicate Flash event types when wrapping inside a Starling event.
		 */
		public static function getStarlingEventType(wrappedEventInstanceOrClass:*, type:String):String
		{
			return getQualifiedClassName(wrappedEventInstanceOrClass) + "_" + type;
		}
		
		/** 
		 * Wraps a Flash event inside a Starling event so that it may be dispatched via a Starling eventDispatcher.
		 * The Starling event's data property then becomes the Flash event.
		 * The Starling event can be listened to using <code>getQualifiedEventType()</code>.
		 */
		public static function wrapFlashEvent(event:flash.events.Event):starling.events.Event
		{
			return new starling.events.Event(getStarlingEventType(event, event.type), event.bubbles, event);
		}
	}
}