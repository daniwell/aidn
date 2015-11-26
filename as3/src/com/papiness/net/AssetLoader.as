package com.papiness.net 
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.utils.Timer;
	
	/**
	* @eventType Event.COMPLETE
	*/
	[Event(name="complete", type="flash.events.Event")]
	/**
	* @eventType IOErrorEvent.IO_ERROR
	*/
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	
	/**
	 * アセット読み込み用
	 * @author daniwell
	 */
	public class AssetLoader extends EventDispatcher
	{
		private var _loader :Loader;
		private var _domain :ApplicationDomain;
		
		private var _count      :uint;
		private var _path       :String;
		
		private var _timer      :Timer;
		private var _retryCount :uint;
		
		
		public function AssetLoader() 
		{
			_loader = new Loader();
			_timer  = new Timer(0);
		}
		
		// ------------------------------------------------------------------- public methods
		/**
		 * 読み込みを開始します。
		 * @param	path		ファイルパス。
		 * @param	retryCount	リトライ回数。
		 */
		public function load ( path :String, retryCount :uint = 5 ) :void
		{
			close();
			
			_count = 1;
			_path  = path;
			
			_retryCount = retryCount;
			
			_addEvents();
			_loader.load(new URLRequest(path));
		}
		/**
		 * 接続を閉じます。
		 */
		public function close ( ) :void
		{
			_timer.reset();
			_timer.removeEventListener(TimerEvent.TIMER, _timerHandler);
			
			_removeEvents();
			try { _loader.close(); } catch ( e :* ) { }
		}
		/**
		 * リンケージ名からインスタンスを取得します。
		 * @param	name	リンケージ名。
		 * @return			インスタンス。
		 */
		public function getInstance ( name :String ) :*
		{
			var Cl :Class = getClass(name);
			return new Cl();
		}
		/**
		 * リンケージ名から Class を取得します。
		 * @param	name	リンケージ名。
		 * @return			Class。
		 */
		public function getClass ( name :String ) :Class
		{
			return _domain.getDefinition(name) as Class;
		}
		
		
		// ------------------------------------------------------------------- private methods
		private function _removeEvents ( ) :void
		{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,        _completeHandler);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, _ioErrorHandler);
		}
		private function _addEvents (  ) :void
		{
			if ( _loader.contentLoaderInfo.hasEventListener(Event.COMPLETE) ) return;
			
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,        _completeHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _ioErrorHandler);
		}
		
		// ------------------------------------------------------------------- Event
		/* COMPLETE */
		private function _completeHandler ( evt :Event ) :void
		{
			_removeEvents();
			_domain = _loader.contentLoaderInfo.applicationDomain;
			
			dispatchEvent( evt );
		}
		/* IO ERROR */
		private function _ioErrorHandler ( evt :IOErrorEvent ) :void
		{
			_timer.delay       = _count * 1000;
			_timer.repeatCount = 1;
			
			_count ++;
			if ( _retryCount < _count )
			{
				dispatchEvent( evt );
				return;
			}
			
			_timer.addEventListener(TimerEvent.TIMER, _timerHandler);
			_timer.start();
		}
		/* TIMER */
		private function _timerHandler ( evt :TimerEvent ) :void
		{
			_timer.reset();
			_timer.removeEventListener(TimerEvent.TIMER, _timerHandler);
			
			_loader.load(new URLRequest(_path));
		}
	}
}