package aidn.main.core 
{
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	public class StageReference 
	{
		private static var _inited      :Boolean = false;
		
		private static var _stageWidth  :int;
		private static var _stageHeight :int;
		
		private static var _stage    :Stage;
		
		private static var     _resizeFuncs :Dictionary;
		private static var _enterFrameFuncs :Dictionary;
		private static var _enterFrameTotal :int;
		
		private static var _firstResizeFunc :Function;
		
		
		// ------------------------------------------------------------------- public
		
		public static function init ( stage :Stage, scaleMode :String = "noScale", align :String = "TL" ) :void
		{
			_stage = stage;
			
			_stage.scaleMode = scaleMode;
			_stage.align     = align;
			
			if (_inited) return;
			_inited = true;
			
			_stage.addEventListener(Event.RESIZE, _resize);
			
			    _resizeFuncs = new Dictionary();
			_enterFrameFuncs = new Dictionary();
			_enterFrameTotal = 0;
			
			_resize(null);
		}
		
		
		/// resize 時、一番最初に実行される関数
		public static function addFirstResizeFunction ( func :Function ) :void
		{
			_firstResizeFunc = func;
		}
		
		
		/**
		 * Resize 時に実行する関数を追加。
		 * @param	func
		 */
		public static function addResizeFunction ( func :Function ) :void
		{
			if (! (_resizeFuncs[func] is Function)) _resizeFuncs[func] = func;
		}
		/**
		 * Resize 時に実行する関数を削除。
		 * @param	func
		 */
		public static function removeResizeFunction ( func :Function ) :void
		{
			if ( _resizeFuncs[func] is Function )
			{
				_resizeFuncs[func] = null;
				delete _resizeFuncs[func];
			}
		}
		
		/**
		 * EnterFrame で実行する関数を追加。
		 * @param	func
		 */
		public static function addEnterFrameFunction ( func :Function ) :void
		{
			if (! (_enterFrameFuncs[func] is Function))
			{
				_enterFrameFuncs[func] = func;
				if (++ _enterFrameTotal == 1) _stage.addEventListener(Event.ENTER_FRAME, _enterFrame);
			}
		}
		/**
		 * EnterFrame で実行する関数を削除。
		 * @param	func
		 */
		public static function removeEnterFrameFunction ( func :Function ) :void
		{
			if (_enterFrameFuncs[func] is Function)
			{
				_enterFrameFuncs[func] = null;
				delete _enterFrameFuncs[func];
				if (-- _enterFrameTotal == 0) _stage.removeEventListener(Event.ENTER_FRAME, _enterFrame);
			}
		}
		
		
		/**
		 * Stage に子を追加
		 * @param	child
		 */
		public static function addChild ( child :DisplayObject ) :DisplayObject
		{
			return _stage.addChild(child);
		}
		
		public static function addEventListener ( type :String, listener :Function, useCapture :Boolean = false, priority :int = 0, useWeakReference :Boolean = false ) :void 
		{
			_stage.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		public static function removeEventListener ( type :String, listener :Function, useCapture :Boolean = false ) :void 
		{
			_stage.removeEventListener(type, listener, useCapture);
		}
		
		/* 手動で RESIZE 時と同等の処理を行う */
		public static function updateStageSize ( ) :void
		{
			_resize(null);
		}
		
		// ------------------------------------------------------------------- private
		
		private static function _resize ( evt :Event ) :void 
		{
			_stageWidth  = _stage.stageWidth;
			_stageHeight = _stage.stageHeight;
			
			if (_firstResizeFunc is Function) _firstResizeFunc();
			
			for each ( var f :Function in _resizeFuncs ) if (f is Function) f();
		}
		private static function _enterFrame ( evt :Event ) :void 
		{
			for each ( var f :Function in _enterFrameFuncs ) if (f is Function) f();
		}
		
		// ------------------------------------------------------------------- getter & setter
		
		public static function get stage       ( ) :Stage { return _stage; }
		public static function get stageWidth  ( ) :int   { return _stageWidth; }
		public static function get stageHeight ( ) :int   { return _stageHeight; }
		public static function get loaderInfo  ( ) :LoaderInfo { return _stage.loaderInfo; }
	}
}