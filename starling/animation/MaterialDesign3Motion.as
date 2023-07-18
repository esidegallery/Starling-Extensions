package starling.animation
{
	/**
	 * Defines the motion standards for the Material Design 3 specification.<br/>
	 * https://m3.material.io/styles/motion/overview
	 */
	public class MaterialDesign3Motion
	{
		// Short durations
		// These are used for small utility-focused transitions.
		public static const DURATION_SHORT_1:Number = 50 / 1000;
		public static const DURATION_SHORT_2:Number = 100 / 1000;
		public static const DURATION_SHORT_3:Number = 150 / 1000;
		public static const DURATION_SHORT_4:Number = 200 / 1000;

		// Medium durations
		// These are used for transitions that traverse a medium area of the screen.
		public static const DURATION_MEDIUM_1:Number = 250 / 1000;
		public static const DURATION_MEDIUM_2:Number = 300 / 1000;
		public static const DURATION_MEDIUM_3:Number = 350 / 1000;
		public static const DURATION_MEDIUM_4:Number = 400 / 1000;

		// Long durations
		// These durations are often paired with Emphasized easing. They're used for large expressive transitions.
		public static const DURATION_LONG_1:Number = 450 / 1000;
		public static const DURATION_LONG_2:Number = 500 / 1000;
		public static const DURATION_LONG_3:Number = 550 / 1000;
		public static const DURATION_LONG_4:Number = 600 / 1000;

		// Extra long durations
		// Though rare, some transitions use durations above 600ms.
		// These are usually used for ambient transitions that don't involve user input.
		public static const DURATION_EXTRA_LONG_1:Number = 700 / 1000;
		public static const DURATION_EXTRA_LONG_2:Number = 800 / 1000;
		public static const DURATION_EXTRA_LONG_3:Number = 900 / 1000;
		public static const DURATION_EXTRA_LONG_4:Number = 1;

		public static const EASING_LINEAR:String = "easing.linear";

		// Standard easing set
		// This set is used for simple, small, or utility-focused transitions.
		public static const EASING_STANDARD:String = "easing.standard";
		public static const EASING_STANDARD_ACCELERATE:String = "easing.standard.accelerate";
		public static const EASING_STANDARD_DECELERATE:String = "easing.standard.decelerate";

		// Emphasized easing set
		// This set is the most common because it captures the expressive style of M3.
		public static const EASING_EMPHASIZED:String = "easing.emphasized";
		public static const EASING_EMPHASIZED_ACCELERATE:String = "easing.emphasized.accelerate";
		public static const EASING_EMPHASIZED_DECELERATE:String = "easing.emphasized.decelerate";

		public static const EASING_LEGACY:String = "easing.legacy";
		public static const EASING_LEGACY_ACCELERATE:String = "easing.legacy.accelerate";
		public static const EASING_LEGACY_DECELERATE:String = "easing.legacy.decelerate";

		private static function registerTransitions():void
		{
			Transitions.register(EASING_LINEAR, BezierEasing.create(0, 0, 1, 1));
			Transitions.register(EASING_STANDARD, BezierEasing.create(0.2, 0, 0, 1));
			Transitions.register(EASING_STANDARD_ACCELERATE, BezierEasing.create(0.3, 0, 1, 1));
			Transitions.register(EASING_STANDARD_DECELERATE, BezierEasing.create(0, 0, 0, 1));
			Transitions.register(EASING_EMPHASIZED, BezierEasing.create(0.2, 0, 0, 1));
			Transitions.register(EASING_EMPHASIZED_ACCELERATE, BezierEasing.create(0.3, 0, 0.8, 0.15));
			Transitions.register(EASING_EMPHASIZED_DECELERATE, BezierEasing.create(0.05, 0.7, 0.1, 1));
			Transitions.register(EASING_LEGACY, BezierEasing.create(0.4, 0, 0.2, 1));
			Transitions.register(EASING_LEGACY_ACCELERATE, BezierEasing.create(0.4, 0, 1.0, 1));
			Transitions.register(EASING_LEGACY_DECELERATE, BezierEasing.create(0.0, 0, 0.2, 1));
		}

		{
			registerTransitions();
		}
	}
}