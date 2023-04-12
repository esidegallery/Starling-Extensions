package starling.display
{
	import feathers.utils.math.clamp;

	import starling.events.Event;

	public class Donut extends Sprite
	{
		protected var canvas:Canvas;
		protected var canvasMask:Canvas;

		protected var invalid:Boolean = true;

		private var _diameter:Number;
		public function get diameter():Number
		{
			return _diameter;
		}
		public function set diameter(value:Number):void
		{
			if (_diameter == value)
			{
				return;
			}
			_diameter = value;
			invalid = true;
		}

		private var _innerRadius:Number;
		/** In radians, so 0 = no radius, 1 = entire redius. */
		public function get innerRadius():Number
		{
			return _innerRadius;
		}
		public function set innerRadius(value:Number):void
		{
			if (_innerRadius == value)
			{
				return;
			}
			_innerRadius = value;
			invalid = true;
		}

		private var _color:uint;
		public function get color():uint
		{
			return _color;
		}
		public function set color(value:uint):void
		{
			if (_color == value)
			{
				return;
			}
			_color = value;
			invalid = true;
		}

		public function Donut(diameter:Number, innerRadius:Number, color:uint = 16777215)
		{
			_diameter = diameter;
			_innerRadius = innerRadius;
			_color = color;

			addEventListener(Event.ENTER_FRAME, validate);
			addEventListener(Event.ADDED_TO_STAGE, function():void
			{
				addEventListener(Event.ENTER_FRAME, validate);
			});
			addEventListener(Event.REMOVED_FROM_STAGE, function():void
			{
				removeEventListener(Event.ENTER_FRAME, validate);
			});
		}

		public function validate():void
		{
			if (!invalid)
			{
				return;
			}

			if (canvas == null)
			{
				canvas = new Canvas;
				addChild(canvas);
			}

			var outerRadius:Number = _diameter / 2;
			var innerRad:Number = clamp(outerRadius * _innerRadius, 0, outerRadius);
			canvas.clear();
			canvas.beginFill(_color);
			canvas.drawCircle(outerRadius, outerRadius, outerRadius);
			canvas.endFill();

			if (canvasMask == null)
			{
				canvasMask = new Canvas;
				addChild(canvasMask);
				canvas.mask = canvasMask;
				canvas.maskInverted = true;
			}
			canvasMask.clear();
			canvasMask.beginFill();
			canvasMask.drawCircle(outerRadius, outerRadius, innerRad);
			canvasMask.endFill();
		}
	}
}