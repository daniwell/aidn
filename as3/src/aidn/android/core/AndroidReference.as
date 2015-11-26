package aidn.android.core 
{
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Stage;
	import flash.events.AccelerometerEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.sensors.Accelerometer;
	import flash.ui.Keyboard;
	import flash.ui.Multitouch;
	import flash.utils.Dictionary;
	
	
	public class AndroidReference 
	{
		private static var _stage :Stage;
		
		private static var   _keyBackFuncs :Dictionary;
		private static var   _keyMenuFuncs :Dictionary;
		private static var _keySearchFuncs :Dictionary;
		
		
		private static var   _activateFuncs :Dictionary;
		private static var   _activateTotal :int;
		private static var _deactivateFuncs :Dictionary;
		private static var _deactivateTotal :int;
		
		
		private static var _acceleroFuncs :Dictionary;
		private static var _acceleroTotal :int;
		private static var _accelerometer :Accelerometer;
		
		private static var _acceleroSupported :Boolean;
		
		
		/**
		 * 初期化 (StageReference と併用)
		 * @param	stage					ステージ。
		 * @param	multitouchInputMode		マルチタッチモード。
		 * @param	deactivateEnd			背面に回った時にアプリ終了するかどうか。
		 * @param	useKeyEvent				
		 * @param	systemIdleMode
		 */
		public static function init ( stage :Stage, multitouchInputMode :String = "touchPoint", deactivateEnd :Boolean = true, useKeyEvent :Boolean = false, systemIdleMode :String = "normal" ) :void
		{
			_stage = stage;
			
			Multitouch.inputMode  = multitouchInputMode;
			
			  _keyBackFuncs = new Dictionary();
			  _keyMenuFuncs = new Dictionary();
			_keySearchFuncs = new Dictionary();
			
			_activateFuncs = new Dictionary();
			_activateTotal = 0;
			
			_deactivateFuncs = new Dictionary();
			_deactivateTotal = 0;
			
			if (deactivateEnd) addDeactivateFunction(exit);
			
			if (useKeyEvent) _stage.addEventListener(KeyboardEvent.KEY_DOWN, _keyDown);
			
			_acceleroFuncs = new Dictionary();
			_acceleroTotal = 0;
			
			_acceleroSupported = Accelerometer.isSupported;
			if (_acceleroSupported)	_accelerometer = new Accelerometer();
			else					trace("[AndroidReference] Accelerometer is not Supported.");
			
			NativeApplication.nativeApplication.systemIdleMode = systemIdleMode;
		}
		
		// ------------------------------------------------------------------- public
		
		/** アプリの終了 */
		public static function exit ( ) :void
		{
			NativeApplication.nativeApplication.exit();
		}
		
		
		/** add BACK Function (KeyboardEvent) */
		public static function addKeyBackFunction ( func :Function ) :void
		{
			if (! (_keyBackFuncs[func] is Function)) _keyBackFuncs[func] = func;
		}
		/** remove BACK Function */
		public static function removeKeyBackFunction ( func :Function ) :void
		{
			if ( _keyBackFuncs[func] is Function ) { _keyBackFuncs[func] = null; delete _keyBackFuncs[func]; }
		}
		
		
		/** add MENU Function (KeyboardEvent) */
		public static function addKeyMenuFunction ( func :Function ) :void
		{
			if (! (_keyMenuFuncs[func] is Function)) _keyMenuFuncs[func] = func;
		}
		/** remove MENU Function */
		public static function removeKeyMenuFunction ( func :Function ) :void
		{
			if ( _keyMenuFuncs[func] is Function ) { _keyMenuFuncs[func] = null; delete _keyMenuFuncs[func]; }
		}
		
		
		/** add SEARCH Function (KeyboardEvent) */
		public static function addKeySearchFunction ( func :Function ) :void
		{
			if (! (_keySearchFuncs[func] is Function)) _keySearchFuncs[func] = func;
		}
		/** remove SEARCH Function */
		public static function removeKeySearchFunction ( func :Function ) :void
		{
			if ( _keySearchFuncs[func] is Function ) { _keySearchFuncs[func] = null; delete _keySearchFuncs[func]; }
		}
		
		
		/** add ACTIVATE Function */
		public static function addActivateFunction ( func :Function ) :void
		{
			if (! (_activateFuncs[func] is Function))
			{
				_activateFuncs[func] = func;
				if (++ _activateTotal == 1) _stage.addEventListener(Event.ACTIVATE, _activate);
			}
		}
		/** remove ACTIVATE Function */
		public static function removeActivateFunction ( func :Function ) :void
		{
			if (_activateFuncs[func] is Function)
			{
				_activateFuncs[func] = null;
				delete _activateFuncs[func];
				if (-- _activateTotal == 0) _stage.removeEventListener(Event.ACTIVATE, _activate);
			}
		}
		
		/** add DEACTIVATE Function */
		public static function addDeactivateFunction ( func :Function ) :void
		{
			if (! (_deactivateFuncs[func] is Function))
			{
				_deactivateFuncs[func] = func;
				if (++ _deactivateTotal == 1) _stage.addEventListener(Event.DEACTIVATE, _deactivate);
			}
		}
		/** remove DEACTIVATE Function */
		public static function removeDeactivateFunction ( func :Function ) :void
		{
			if (_deactivateFuncs[func] is Function)
			{
				_deactivateFuncs[func] = null;
				delete _deactivateFuncs[func];
				if (-- _deactivateTotal == 0) _stage.removeEventListener(Event.DEACTIVATE, _deactivate);
			}
		}
		
		
		
		/** add ACCELERO Function (AccelerometerEvent) */
		public static function addAcceleroFunction ( func :Function ) :void
		{
			if (! (_acceleroFuncs[func] is Function))
			{
				_acceleroFuncs[func] = func;
				if (++ _acceleroTotal == 1 && _acceleroSupported)
					_accelerometer.addEventListener(AccelerometerEvent.UPDATE, _acceleroUpdate);
			}
		}
		/** remove ACCELERO Function */
		public static function removeAcceleroFunction ( func :Function ) :void
		{
			if (_acceleroFuncs[func] is Function)
			{
				_acceleroFuncs[func] = null;
				delete _acceleroFuncs[func];
				if (-- _acceleroTotal == 0 && _acceleroSupported)
					_accelerometer.removeEventListener(AccelerometerEvent.UPDATE, _acceleroUpdate);
			}
		}
		
		// ------------------------------------------------------------------- private
		
		/* ACTIVATE */
		private static function _activate ( evt :Event ) :void 
		{
			for each ( var f :Function in _activateFuncs ) if (f is Function) f();
		}
		/* DEACTIVATE */
		private static function _deactivate ( evt :Event ) :void 
		{
			for each ( var f :Function in _deactivateFuncs ) if (f is Function) f();
		}
		
		/* ACCELERO */
		private static function _acceleroUpdate ( evt :AccelerometerEvent ) :void 
		{
			for each ( var f :Function in _acceleroFuncs ) if (f is Function) f(evt);
		}
		
		/* KEY BOARD */
		private static function _keyDown ( evt :KeyboardEvent ) :void
		{
			var code :int = evt.keyCode;
			var f :Function;
			
			if (code == Keyboard.BACK)
			{
				for each ( f in _keyBackFuncs )   if (f is Function) f(evt);
			}
			else if (code == Keyboard.MENU)
			{
				for each ( f in _keyMenuFuncs )   if (f is Function) f(evt);
			}
			else if (code == Keyboard.SEARCH)
			{
				for each ( f in _keySearchFuncs ) if (f is Function) f(evt);
			}
		}
		
		// ------------------------------------------------------------------- getter
		
		/** 加速度センサ対応かどうか */
		public static function get acceleroSupported ( ) :Boolean { return _acceleroSupported; }
		
	}
}