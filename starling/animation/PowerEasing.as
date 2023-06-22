package starling.animation
{
	import starling.errors.AbstractClassError;

	public class PowerEasing
	{
		/** @private */
		public function PowerEasing()
		{
			throw new AbstractClassError;
		}

		public static function create(type:int, power:int):Function
		{
			function getRatio(p:Number):Number
			{
				var r:Number = (type == 1) ? 1 - p : (type == 2) ? p : (p < 0.5) ? p * 2 : (1 - p) * 2;
				if (power == 1)
				{
					r *= r;
				}
				else if (power == 2)
				{
					r *= r * r;
				}
				else if (power == 3)
				{
					r *= r * r * r;
				}
				else if (power == 4)
				{
					r *= r * r * r * r;
				}
				return (type == 1) ? 1 - r : (type == 2) ? r : (p < 0.5) ? r / 2 : 1 - (r / 2);
			};
			return getRatio;
		}
	}
}