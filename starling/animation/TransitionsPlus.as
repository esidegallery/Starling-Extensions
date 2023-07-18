package starling.animation
{
	public class TransitionsPlus
	{
		private static const TYPE_EASE_OUT:int = 1;
		private static const TYPE_EASE_IN:int = 2;
		private static const TYPE_EASE_IN_OUT:int = 3;

		public static function get SMOOTH_EASE_OUT():String
		{
			var name:String = "smoothEaseOut";
			if (Transitions.getTransition(name) == null)
			{
				Transitions.register(name, BezierEasing.create(0.08, 0, 0.16, 1));
			}
			return name;
		}

		public static function get POWER_2_EASE_OUT():String
		{
			var name:String = "power2EaseOut";
			if (Transitions.getTransition(name) == null)
			{
				Transitions.register(name, PowerEasing.create(TYPE_EASE_OUT, 2));
			}
			return name;
		}

		public static function get POWER_2_EASE_IN():String
		{
			var name:String = "power2EaseIn";
			if (Transitions.getTransition(name) == null)
			{
				Transitions.register(name, PowerEasing.create(TYPE_EASE_IN, 2));
			}
			return name;
		}

		public static function get POWER_2_EASE_IN_OUT():String
		{
			var name:String = "power2EaseInOut";
			if (Transitions.getTransition(name) == null)
			{
				Transitions.register(name, PowerEasing.create(TYPE_EASE_IN_OUT, 2));
			}
			return name;
		}

		public static function get POWER_3_EASE_OUT():String
		{
			var name:String = "power3EaseOut";
			if (Transitions.getTransition(name) == null)
			{
				Transitions.register(name, PowerEasing.create(TYPE_EASE_OUT, 3));
			}
			return name;
		}

		public static function get POWER_3_EASE_IN():String
		{
			var name:String = "power3EaseIn";
			if (Transitions.getTransition(name) == null)
			{
				Transitions.register(name, PowerEasing.create(TYPE_EASE_IN, 3));
			}
			return name;
		}

		public static function get POWER_3_EASE_IN_OUT():String
		{
			var name:String = "power3EaseInOut";
			if (Transitions.getTransition(name) == null)
			{
				Transitions.register(name, PowerEasing.create(TYPE_EASE_IN_OUT, 3));
			}
			return name;
		}

		public static function get POWER_4_EASE_OUT():String
		{
			var name:String = "power4EaseOut";
			if (Transitions.getTransition(name) == null)
			{
				Transitions.register(name, PowerEasing.create(TYPE_EASE_OUT, 4));
			}
			return name;
		}

		public static function get POWER_4_EASE_IN():String
		{
			var name:String = "power4EaseIn";
			if (Transitions.getTransition(name) == null)
			{
				Transitions.register(name, PowerEasing.create(TYPE_EASE_IN, 4));
			}
			return name;
		}

		public static function get POWER_4_EASE_IN_OUT():String
		{
			var name:String = "power4EaseInOut";
			if (Transitions.getTransition(name) == null)
			{
				Transitions.register(name, PowerEasing.create(TYPE_EASE_IN_OUT, 4));
			}
			return name;
		}

		public static function get SHAKE_3X():String
		{
			var name:String = "shake3x";
			if (Transitions.getTransition(name) == null)
			{
				Transitions.register(name, function(ratio:Number):Number
				{
					return Math.sin(ratio * Math.PI * 3) * (1 - ratio);
				});
			}
			return name;
		}

		public static function get SHAKE_4X():String
		{
			var name:String = "shake4x";
			if (Transitions.getTransition(name) == null)
			{
				Transitions.register(name, function(ratio:Number):Number
				{
					return Math.sin(ratio * Math.PI * 4) * (1 - ratio);
				});
			}
			return name;
		}

		public static function get SHAKE_5X():String
		{
			var name:String = "shake5x";
			if (Transitions.getTransition(name) == null)
			{
				Transitions.register(name, function(ratio:Number):Number
				{
					return Math.sin(ratio * Math.PI * 5) * (1 - ratio);
				});
			}
			return name;
		}
	}
}