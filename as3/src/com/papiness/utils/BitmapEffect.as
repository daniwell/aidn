package com.papiness.utils 
{
	import flash.display.BitmapData;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.ConvolutionFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * BitmapData に様々なエフェクトを掛けます。
	 * @author daniwell
	 */
	public class BitmapEffect 
	{
		
		
		/**
		 * コンボリューション。
		 * @param	source
		 * @param	matrixX
		 * @param	matrixY
		 * @param	matrix
		 */
		public static function convolution ( source :BitmapData, matrixX :Number, matrixY :Number, matrix :Array ) :void
		{
			var conv :ConvolutionFilter = new ConvolutionFilter(matrixX, matrixY, matrix);
			source.applyFilter( source, source.rect, new Point(), conv );
		}
		
		/**
		 * グレースケール。
		 * @param	source
		 */
		public static function grayscale ( source :BitmapData ) :void
		{
			var matrix :Array = [
				1/3, 1/3, 1/3, 0, 0,
				1/3, 1/3, 1/3, 0, 0,
				1/3, 1/3, 1/3, 0, 0,
				0, 0, 0, 1, 0
			]; 
			
			var cmf :ColorMatrixFilter = new ColorMatrixFilter( matrix );
			source.applyFilter( source, source.rect, new Point(), cmf );
		}
		
		/**
		 * 色。
		 * @param	source
		 * @param	col
		 */
		public static function color ( source :BitmapData, col :uint ) :void
		{
			var ct :ColorTransform = new ColorTransform();
			
			ct.redOffset   = col >> 16 & 0xff;
			ct.greenOffset = col >>  8 & 0xff;
			ct.blueOffset  = col       & 0xff;
			
			source.colorTransform( source.rect, ct );
		}
		
		/**
		 * コントラスト。
		 * @param	source
		 * @param	cont
		 */
		public static function contrast ( source :BitmapData, cont :Number = 1.0 ) :void
		{
			var matrix :Array = [
				cont + 1, 0, 0, 0, -(128*cont),
				0, cont + 1, 0, 0, -(128*cont),
				0, 0, cont + 1, 0, -(128*cont),
				0, 0, 0, 1, 0
			];
			
			var cmf :ColorMatrixFilter = new ColorMatrixFilter( matrix );
			source.applyFilter( source, source.rect, new Point(), cmf );
		}
		
		/**
		 * 2値化。
		 * @param	source
		 * @param	threshold	閾値
		 * @param	bassColor
		 * @param	color		置き換え色
		 */
		public static function binarization ( source :BitmapData, threshold :int = 128,
											  bassColor :uint = 0xFFFFFF, color :uint = 0xFF0099FF ) :void
		{
			var d    :BitmapData = source.clone();
			var rect :Rectangle  = source.rect;
			
			source.fillRect(rect, bassColor);
			source.threshold(d, rect, new Point(0, 0), "<=", threshold, color, 255, false);
		}
		
		/**
		 * メディアンフィルタ。
		 * @param	source
		 */ 
		public static function median ( source :BitmapData ) :void
		{
			var d :BitmapData = source.clone();
			var w :uint = d.width;
			var h :uint = d.height;
			
			var x :int, y :int;
			var c :int;
			
			var a:Array = new Array(9);
			
			for ( x = 0; x < w; x ++ )
			{
				for ( y = 0; y < h; y ++ )
				{
					a[0] = d.getPixel(x - 1, y - 1) & 255;
					a[1] = d.getPixel(x - 1, y)     & 255;
					a[2] = d.getPixel(x - 1, y + 1) & 255;
					a[3] = d.getPixel(x, y - 1)     & 255;
					a[4] = d.getPixel(x, y)         & 255;
					a[5] = d.getPixel(x, y + 1)     & 255;
					a[6] = d.getPixel(x + 1, y - 1) & 255;
					a[7] = d.getPixel(x + 1, y)     & 255;
					a[8] = d.getPixel(x + 1, y + 1) & 255;
					
					a.sort(Array.NUMERIC);
					c = a[4];
					
					source.setPixel(x, y, (c << 16) | (c << 8) | c);
				}
			}
		}
		
	}
}