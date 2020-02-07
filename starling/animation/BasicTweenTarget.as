package starling.animation
{
	/**
	 * Defines a ratio property to be tweened.
	 * The class is dynamic so that other properties may be tweened simultaneously.
	 */
	public dynamic class BasicTweenTarget
	{
		public var ratio:Number;

		public function BasicTweenTarget(ratio:Number = 0)
		{
			this.ratio = ratio;
		}
	}
}