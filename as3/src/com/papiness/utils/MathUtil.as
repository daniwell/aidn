package com.papiness.utils 
{
	/**
	 * 数値関連のクラス。
	 * @author daniwell
	 */
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
		
		
	}
}