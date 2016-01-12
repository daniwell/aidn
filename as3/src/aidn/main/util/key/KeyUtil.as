package aidn.main.util.key 
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	
	public class KeyUtil 
	{
		private static var _keyFlags :/*uint*/Array;
		
		private static var _keyDownFuncs :Dictionary;
		private static var   _keyUpFuncs :Dictionary;
		
		private static var _stage :Stage;
		
		/**
		 * 初期化
		 * @param	stage
		 */
		public static function init ( stage :Stage, keyDownFunc :Function = null, keyUpFunc :Function = null ) :void
		{
			_stage = stage;
			
			if (! _keyFlags) _keyFlags = [];
			
			if (! _keyDownFuncs)
			{
				_keyDownFuncs = new Dictionary();
				  _keyUpFuncs = new Dictionary();
			}
			
			if (keyDownFunc != null) addKeyDownFunction(keyDownFunc);
			if (  keyUpFunc != null)   addKeyUpFunction(  keyUpFunc);
		}
		
		public static function start ( ) :void
		{
			stop();
			
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, _keyDown);
			_stage.addEventListener(KeyboardEvent.KEY_UP,   _keyUp);
		}
		public static function stop ( ) :void
		{
			_stage.removeEventListener(KeyboardEvent.KEY_DOWN, _keyDown);
			_stage.removeEventListener(KeyboardEvent.KEY_UP,   _keyUp);
		}
		
		
		/// KEY DOWN (ADD)
		public static function addKeyDownFunction ( func :Function ) :void
		{
			if (! (_keyDownFuncs[func] is Function)) _keyDownFuncs[func] = func;
		}
		/// KEY DOWN (REMOVE)
		public static function removeKeyDownFunction ( func :Function ) :void
		{
			if ( _keyDownFuncs[func] is Function )
			{
				_keyDownFuncs[func] = null;
				delete _keyDownFuncs[func];
			}
		}
		/// KEY UP (ADD)
		public static function addKeyUpFunction ( func :Function ) :void
		{
			if (! (_keyUpFuncs[func] is Function)) _keyUpFuncs[func] = func;
		}
		/// KEY UP (REMOVE)
		public static function removeKeyUpFunction ( func :Function ) :void
		{
			if ( _keyUpFuncs[func] is Function )
			{
				_keyUpFuncs[func] = null;
				delete _keyUpFuncs[func];
			}
		}
		
		
		/**
		 * Key が押されているかどうか調べる
		 * @param	code	対象となる KeyCode
		 * @return
		 */
		public static function isDown ( code :int ) :Boolean
		{
			return Boolean(_keyFlags[code]);
		}
		
		public static function checkCount ( code :int ) :uint
		{
			return (_keyFlags[code]);
		}
		
		private static function _keyDown ( evt :KeyboardEvent ) :void 
		{
			if (! _keyFlags[evt.keyCode]) _keyFlags[evt.keyCode] = 0;
			
			_keyFlags[evt.keyCode] ++;
			for each ( var f :Function in _keyDownFuncs ) if (f is Function) f(evt);
		}
		private static function _keyUp ( evt :KeyboardEvent ) :void 
		{
			_keyFlags[evt.keyCode] = 0;
			for each ( var f :Function in _keyUpFuncs ) if (f is Function) f(evt);
		}
		
	}
}