 	package starling.filters
{
	import feathers.controls.SpinnerList;
	
	import starling.utils.Color;

	public class ColorMatrixFilterExtended extends ColorMatrixFilter
	{
		private static const LUMA_R:Number = 0.2126;
		private static const LUMA_G:Number = 0.7152;
		private static const LUMA_B:Number = 0.0722;
		
		public function desaturate():void
		{
			concat(Vector.<Number>([
				LUMA_R,  LUMA_G,  LUMA_B,  0,  0, 
				LUMA_R,  LUMA_G,  LUMA_B,  0,  0, 
				LUMA_R,  LUMA_G,  LUMA_B,  0,  0, 
				0,       0,       0,       1,  0
			]));
		}
		
		public function multiply(color:uint, amount:Number = 1):void
		{
			var r:Number = Color.getRed(color) / 255;
			var g:Number = Color.getGreen(color) / 255;
			var b:Number = Color.getBlue(color) / 255;
			
			var q:Number = 1 - amount;
			
			r += (1 - r) * q;
			g += (1 - g) * q;
			b += (1 - b) * q;
				
			concat(Vector.<Number>([
				r * LUMA_R,  r * LUMA_G,  r * LUMA_B,  0,  0, 
				g * LUMA_R,  g * LUMA_G,  g * LUMA_B,  0,  0, 
				b * LUMA_R,  b * LUMA_G,  b * LUMA_B,  0,  0, 
				0,           0,           0,           1,  0
			]));
		}
		
		public function screen(color:uint, amount:Number = 1):void
		{
			var r:Number = Color.getRed(color);
			var g:Number = Color.getGreen(color);
			var b:Number = Color.getBlue(color);
			
			var rAdd:Number = 1 - amount * r / 255;
			var gAdd:Number = 1 - amount * g / 255;
			var bAdd:Number = 1 - amount * b / 255;
			
			concat(Vector.<Number>([
				rAdd * LUMA_R,  rAdd * LUMA_G,  rAdd * LUMA_B,  0,  r * amount, 
				gAdd * LUMA_R,  gAdd * LUMA_G,  gAdd * LUMA_B,  0,  g * amount, 
				bAdd * LUMA_R,  bAdd * LUMA_G,  bAdd * LUMA_B,  0,  b * amount, 
				            0,              0,              0,  1,           0
			]));
		}
		
		/** Not tested and probably not possible */
		public function overlay(color:uint):void
		{
			var r:Number = Color.getRed(color) / 255;
			var g:Number = Color.getGreen(color) / 255;
			var b:Number = Color.getBlue(color) / 255;
			
			concat(Vector.<Number>([
				LUMA_R * r,      LUMA_G,      LUMA_B,  0,  0, 
				    LUMA_R,  LUMA_G * g,      LUMA_B,  0,  0, 
				    LUMA_R,      LUMA_G,  LUMA_B * b,  0,  0, 
				         0,           0,           0,  1,  0
			]));
		}
		
		public function fill(color:uint):void
		{
			concat(Vector.<Number>([
				0, 0, 0, 0, Color.getRed(color),
				0, 0, 0, 0, Color.getGreen(color),
				0, 0, 0, 0, Color.getBlue(color),
				0, 0, 0, 1, 0
			]));
		}
		
		public function colorize(color:uint, amount:Number):void
		{
			var mult:Number = 1 - amount;
			var rOffset:Number = Color.getRed(color) * amount;
			var gOffset:Number = Color.getGreen(color) * amount;
			var bOffset:Number = Color.getBlue(color) * amount;
			
			concat(Vector.<Number>([
				mult,     0,     0,  0,  rOffset,
				0,     mult,     0,  0,  gOffset,
				0,        0,  mult,  0,  bOffset,
				0,        0,     0,  1,        0
			]));
		}
		
		// Adapted from this answer: https://stackoverflow.com/a/21492544/545066
		public function colorizeWithAlpha(color:uint, colorAlpha:Number, sourceAlpha:Number):void
		{
			var aMult:Number = (colorAlpha + sourceAlpha) - (colorAlpha * sourceAlpha);
			var cAmount:Number = (colorAlpha - sourceAlpha * colorAlpha) / aMult;
			var cMult:Number = 1 - cAmount;
			
			var rOffset:Number = Color.getRed(color) * cAmount;
			var gOffset:Number = Color.getGreen(color) * cAmount;
			var bOffset:Number = Color.getBlue(color) * cAmount;
			
			concat(Vector.<Number>([
				cMult,     0,      0,      0,  rOffset,
				0,     cMult,      0,      0,  gOffset,
				0,         0,  cMult,      0,  bOffset,
				0,         0,      0,  aMult,        0
			]));
		}
	}
}