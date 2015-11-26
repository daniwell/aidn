package com.papiness.api.twitter.utils 
{
	/**
	 * Twitter の日付をDateクラスに変換します。
	 * @author daniwell
	 */
	public class DateUtil
	{
		private static const MONTHS :Object =
			{  Jan: 1, Feb: 2, Mar: 3, Apr:  4, May:  5, June: 6,
			  July: 7, Aug: 8, Sep: 9, Oct: 10, Nov: 11,  Dec: 12 };
		
		// private static const DAYS :Object = { Mon: 0, Tue: 1, Wed: 2, Thr :3, Fri: 4, Sat: 5, Sun: 6 };
		
		/**
		 * Dateクラスに変換します(twitter.com)。
		 * @param	value	Twitter の日付。
		 * @return
		 */
		public static function getDate ( value :String ) :Date
		{
			// 形式(曜日 月 日 時:分:秒 +0000 年  )
			// Fri Jan 01 12:34:56 +0000 2010
			
			var a :/*String*/Array = value.split(" ");
			var b :/*String*/Array = a[3].split(":");
			
			var date :Date = new Date();
			date.fullYear = parseInt(a[5]);
			date.month    = MONTHS[a[1]] - 1;
			date.date     = parseInt(a[2]);
			date.hours    = parseInt(b[0]) + 9;
			date.minutes  = parseInt(b[1]);
			date.seconds  = parseInt(b[2]);
			date.milliseconds = 0;
			
			return date;
		}
		
		/**
		 * Dateクラスに変換します(search.twitter.com)。
		 * @param	value	Twitter の日付。
		 * @return
		 */
		public static function getDateSearch ( value :String ) :Date
		{
			// 形式(曜日 月 日 時:分:秒 +0000 年  )
			// Fri Jan 01 12:34:56 +0000 2010
			// Tue, 06 Apr 2010 15:41:27 +0000
			
			value = value.split(",").join("");
			
			var a :/*String*/Array = value.split(" ");
			var b :/*String*/Array = a[4].split(":");
			
			var date :Date = new Date();
			date.fullYear = parseInt(a[3]);
			date.month    = MONTHS[a[2]] - 1;
			date.date     = parseInt(a[1]);
			date.hours    = parseInt(b[0]) + 9;
			date.minutes  = parseInt(b[1]);
			date.seconds  = parseInt(b[2]);
			date.milliseconds = 0;
			
			return date;
		}
		
		public static function getDateSearchAtom ( value :String ) :Date
		{
			var arr :Array = value.split("T");
			
			var a :/*String*/Array = arr[0].split("-");
			var b :/*String*/Array = arr[1].split(":");
			
			var date :Date = new Date();
			date.fullYear = parseInt(a[0]);
			date.month    = parseInt(a[1]) - 1;
			date.date     = parseInt(a[2]);
			date.hours    = parseInt(b[0]) + 9;
			date.minutes  = parseInt(b[1]);
			date.seconds  = parseInt(b[2]);
			date.milliseconds = 0;
			
			return date;
		}
		
		
	}
}