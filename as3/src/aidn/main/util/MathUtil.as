package aidn.main.util 
{
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	public class MathUtil 
	{
		/**
		 * 乱数を生成します。
		 * @param	min		最小値。
		 * @param	max		最大値。
		 * @return
		 */
		public static function rand ( min :Number, max :Number ) :Number
		{
			return Math.random() * ( max - min ) + min;
		}
		
		/**
		 * 乱数を生成(整数)します。
		 * @param	min		最小値。
		 * @param	max		最大値。
		 * @return
		 */
		public static function randInt ( min :int, max :int ) :int
		{
			return Math.floor( Math.random() * ( max + 1 - min ) ) + min;
		}
		
		
		/**
		 * 角度からラジアンに変換します。
		 * @param	deg		角度。
		 * @return
		 */
		public static function toRad ( deg :Number ) :Number
		{
			return deg * Math.PI / 180;
		}
		/**
		 * ラジアンから角度に変換します。
		 * @param	rad		ラジアン。
		 * @return
		 */
		public static function toDeg ( rad :Number ) :Number
		{
			return rad * 180 / Math.PI;
		}
		
		
		/**
		 * 絶対値を求めます。
		 * @param	n
		 * @return
		 */
		public static function abs ( n :Number ) :Number
		{
			if (n < 0) n *= - 1;
			return n;
		}
		
		/**
		 * 最大値を求めます(2値限定)。
		 * @param	n1
		 * @param	n2
		 * @return
		 */
		public static function max ( n1 :Number, n2 :Number ) :Number
		{
			if (n1 < n2) return n2;
			return n1;
		}
		
		/**
		 * 最小値を求めます(2値限定)。
		 * @param	n1
		 * @param	n2
		 * @return
		 */
		public static function min ( n1 :Number, n2 :Number ) :Number
		{
			if (n1 < n2) return n1;
			return n2;
		}
		
		/**
		 * 小数点四捨五入。
		 * @param	n		
		 * @param	place	
		 * @return
		 */
		public static function round ( n :Number, place :int = 0 ) :Number
		{
			return Math.round(n * place) / place;
		}
		
		/**
		 * 2点間の距離
		 * @param	x0
		 * @param	y0
		 * @param	x1
		 * @param	y1
		 * @return
		 */
		public static function distance ( x0 :Number, y0 :Number, x1 :Number, y1 :Number ) :Number
		{
			var dx :Number = x1 - x0;
			var dy :Number = y1 - y0;
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		/**
		 * 3桁区切り
		 * @param	n
		 * @return
		 */
		public static function separate ( n :int ) :String
		{
			var s :String = new String(n).replace(/,/g, ""); 
			
			var t :String = s;
			t = s.replace(/^(-?\d+)(\d{3})/, "$1,$2");
			
			while ( s != t )
			{
				s = t;
				t = s.replace(/^(-?\d+)(\d{3})/, "$1,$2");
			}
			return t; 
		}
		
	}
}