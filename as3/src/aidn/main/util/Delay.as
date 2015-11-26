package aidn.main.util 
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	public class Delay 
	{
		private static var _timerHash :Object = new Object();
		private static var  _funcHash :Object = new Object();
		
		/**
		 * 
		 * @param	delay	秒
		 * @param	func	関数
		 * @param	isHash	ハッシュに格納しておくかどうか
		 * @return			ハッシュキー
		 */
		public static function start ( delay :Number, func :Function, isHash :Boolean = false ) :String
		{
			var t :Timer = new Timer(delay * 1000, 1);
			
			var f :Function = function ( evt :TimerEvent ) :void { func(); };
			
			t.addEventListener(TimerEvent.TIMER_COMPLETE, f, false, 0, true);
			t.start();
			
			if (isHash)
			{
				var hash :String = _getHash();
				
				_timerHash[hash] = t;
				 _funcHash[hash] = f;
				
				return hash;
			}
			return "";
		}
		public static function stop ( hash :String ) :void
		{
			if (_timerHash[hash] is Timer)
			{
				var t :Timer = _timerHash[hash];
				t.removeEventListener(TimerEvent.TIMER_COMPLETE, _funcHash[hash]);
				t.stop();
				
				_timerHash[hash] = _funcHash[hash] = null;
			}
		}
		
		private static function _getHash ( ) :String
		{
			var i :int;
			var hash :String, tmp :String = "";
			for (i = 0; i < 3; i ++) tmp += String.fromCharCode(int(65 + Math.random() * 26));
			hash = tmp;
			
			for (i = 0; _timerHash[hash] is Timer; i ++) hash = tmp + i;
			return hash;
		}
		
	}
}