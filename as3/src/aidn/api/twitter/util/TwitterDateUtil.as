package aidn.api.twitter.util 
{
	public class TwitterDateUtil
	{
		private static const MONTHS :Object =
			{  Jan: 1, Feb: 2, Mar: 3, Apr:  4, May:  5, Jun: 6, June: 6,
			  Jul: 7, July: 7, Aug: 8, Sep: 9, Oct: 10, Nov: 11,  Dec: 12 };
		
		// private static const DAYS :Object = { Mon: 0, Tue: 1, Wed: 2, Thr :3, Fri: 4, Sat: 5, Sun: 6 };
		
		/**
		 * Dateクラスに変換します。
		 * @param	value	Twitter の日付。
		 * @return
		 */
		public static function getDate ( value :String ) :Date
		{
			// 形式 (曜日 月 日 時:分:秒 +0000 年  )
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
		
	}
}