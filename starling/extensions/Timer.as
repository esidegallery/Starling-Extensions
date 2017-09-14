package starling.extensions
{
	import starling.animation.DelayedCall;
	import starling.animation.Juggler;
	import starling.core.Starling;
	import starling.events.EventDispatcher;
	
	[Event(name="timer", type="starling.events.Event")]
	[Event(name="timerComplete", type="starling.events.Event")]
	public class Timer extends EventDispatcher
	{
		// EVENT STRINGS:
		public static const TIMER:String = "timer";
		public static const TIMER_COMPLETE:String = "timerComplete";
		
		private var juggler:Juggler;
		private var delayedCall:DelayedCall;
		
		private var _delay:uint;
		private var _repeatCount:uint;
		private var _currentCount:uint;
		private var _running:Boolean;
		
		public function Timer(delay:uint = 0, repeatCount:uint = 0)
		{
			super();
			
			_delay = delay;
			_repeatCount = repeatCount;
			_running = false;

			juggler = Starling.juggler;
		}
		
		/**
		 * [Read Only] The total number of times the timer has fired since it started at zero.
		 * If the timer has been reset, only the fires since the reset are counted.
		 */
		public function get currentCount():uint
		{
			return _currentCount;
		}
		
		public function get delay():uint
		{
			return _delay;
		}
		public function set delay(value:uint):void
		{
			if (_delay != value)
			{
				_delay = value;
				commitDelayedCall();
			}
		}
		
		/**
		 * The total number of times the timer is set to run. 
		 * If the repeat count is set to 0, the timer continues forever or until the stop() method is invoked or the program stops. 
		 * If the repeat count is nonzero, the timer runs the specified number of times. 
		 * If repeatCount is set to a total that is the same or less then currentCount the timer stops and will not fire again.
		 */
		public function get repeatCount():uint
		{
			return _repeatCount;
		}
		public function set repeatCount(value:uint):void
		{
			if (_repeatCount != value)
			{
				_repeatCount = value;
				if (_repeatCount && _currentCount >= _repeatCount)
					stop();
				commitDelayedCall();
			}
		}
		
		/** [Read Only] The timer's current state; true if the timer is running, otherwise false. */
		public function get running():Boolean
		{
			return _running;
		}
		
		/** Starts the timer, if it is not already running. */
		public function start():void
		{
			if (_running)
				return;
			
			_running = true;
			commitDelayedCall();
		}
		
		/**
		 * Stops the timer. When start() is called after stop(), the timer instance runs for the remaining number of repetitions, as set by the repeatCount property.
		 */
		public function stop():void
		{
			_running = false;
			juggler.remove(delayedCall);
		}
		
		/** 
		 * Stops the timer, if it is running, and sets the currentCount property back to 0, like the reset button of a stopwatch.
		 * Then, when start() is called, the timer instance runs for the specified number of repetitions, as set by the repeatCount value.
		 */
		public function reset():void
		{
			stop();
			_currentCount = 0;
		}
		
		private function commitDelayedCall():void
		{
			juggler.remove(delayedCall);
			
			if (!delayedCall)
				delayedCall = new DelayedCall(timerHandler, _delay / 1000);
			else
				delayedCall.reset(timerHandler, _delay / 1000);
			delayedCall.repeatCount = _repeatCount;
			
			if (_running)
				juggler.add(delayedCall);
		}
		
		private function timerHandler():void
		{
			_currentCount ++;
			dispatchEventWith(TIMER);
			// Testing this way as Event.REMOVE_FROM_JUGGLER is dispatched before the delayed function is called:
			if (repeatCount > 0 && currentCount >= repeatCount)
			{
				stop();
				dispatchEventWith(TIMER_COMPLETE);
			}
		}
		
		public function dispose():void
		{
			removeEventListeners();
			reset();
			juggler = null;
		}
	}
}