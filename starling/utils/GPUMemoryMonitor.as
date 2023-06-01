package starling.utils
{
	import starling.core.Starling;
	import starling.events.EventDispatcher;
	import starling.extensions.Timer;

	public class GPUMemoryMonitor extends EventDispatcher
	{
		/** <code>Event.data</code> is the error message (<code>String</code>). */
		public static const EVENT_TYPE_ERROR:String = "gpuMemoryMonitor_error";

		/** <code>Event.data</code> is the threshold in MB (<code>int</code>). */
		public static const EVENT_TYPE_OVER_THRESHOLD:String = "gpuMemoryMonitor_overThreshold";

		/** <code>Event.data</code> is the threshold in MB (<code>int</code>). */
		public static const EVENT_TYPE_UNDER_THRESHOLD:String = "gpuMemoryMonitor_underThreshold";

		private static const INTERVAL:int = 500;
		private static const B_TO_MB:Number = 1.0 / (1024 * 1024); // convert from bytes to MB

		public var thresholds:Vector.<int> = new <int>[
				256,
				384,
				512,
				640
			];

		protected var timer:Timer;
		protected var previousMemory:int;

		public function GPUMemoryMonitor()
		{
			timer = new Timer(INTERVAL);
			timer.addEventListener(Timer.EVENT_TIMER, update);
			update();
			timer.start();
		}

		protected function update():void
		{
			if ("totalGPUMemory" in Starling.context)
			{
				var currentMemory:int = Starling.context['totalGPUMemory'] * B_TO_MB;
				for each (var threshold:int in thresholds)
				{
					if (previousMemory < threshold && currentMemory >= threshold)
					{
						dispatchEventWith(EVENT_TYPE_OVER_THRESHOLD, false, threshold);
					}
					else if (previousMemory >= threshold && currentMemory < threshold)
					{
						dispatchEventWith(EVENT_TYPE_UNDER_THRESHOLD, false, threshold);
					}
				}
				previousMemory = currentMemory;
			}
			else if (previousMemory > -1)
			{
				dispatchEventWith(EVENT_TYPE_ERROR, false, "GPU memory monitoring is not supported");
				previousMemory = -1;
			}
		}

		public function dispose():void
		{
			timer && timer.dispose();
			timer = null;
		}
	}
}