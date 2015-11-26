package com.papiness.utils
{
	import flash.utils.getTimer;
	
	/**
	 * 時間を計ります。
	 * @author daniwell
	 */
	public class StopWatch 
	{
		private static var t :Number;
		
		public static function start ( ) :void
		{
			t = getTimer();
		}
		public static function stop ( ) :Number
		{
			var n :Number;
			
			if ( t )
			{
				n = getTimer() - t;
				trace( "time :", n, "(ms)" );
			}
			return n;
		}
	}
}