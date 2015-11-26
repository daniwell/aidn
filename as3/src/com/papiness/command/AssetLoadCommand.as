package com.papiness.command 
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Timer;
	import com.papiness.events.CommandEvent;
	
	
	/** @eventType CommandEvent.COMPLETE */
	[Event(name="commandComplete", type="com.papiness.events.CommandEvent")]
	/** @eventType CommandEvent.PROGRESS */
	[Event(name="commandProgress", type="com.papiness.events.CommandEvent")]
	/** @eventType CommandEvent.FAILED */
	[Event(name="commandFailed", type="com.papiness.events.CommandEvent")]
	
	
	public class AssetLoadCommand extends EventDispatcher
	{
		private var _path   :String;
		private var _loader :Loader;
		
		private var _retryTimer :Timer;
		private var _retryCount :int;
		
		private var _domain :ApplicationDomain;
		
		private var _isCurrentDomain :Boolean;
		
		public function AssetLoadCommand() 
		{
			_loader     = new Loader();
			_retryTimer = new Timer(0);
		}
		
		// ------------------------------------------------------------------- public methods
		public function execute ( path :String, isCurrentDomain :Boolean = false ) :void
		{
			cancel();
			_path = path;
			
			_isCurrentDomain = isCurrentDomain;
			
			_retryCount = 1;
			
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,         _completeHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,  _ioErrorHandler);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, _progressHandler);
			
			if (! _isCurrentDomain)
			{
				_loader.load(new URLRequest(_path));
			}
			else
			{
				var context:LoaderContext = new LoaderContext();
				context.applicationDomain = ApplicationDomain.currentDomain;
				_loader.load(new URLRequest(_path), context);
			}
		}
		
		public function cancel ( ) :void
		{
			_retryTimer.removeEventListener(TimerEvent.TIMER, _timerHandler);
			
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,         _completeHandler);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,  _ioErrorHandler);
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, _progressHandler);
			
			try { _loader.close() } catch ( e: * ) { };
		}
		
		// ------------------------------------------------------------------- Event
		/* COMPLETE */
		private function _completeHandler ( evt :Event ) :void 
		{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,         _completeHandler);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,  _ioErrorHandler);
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, _progressHandler);
			
			_domain = _loader.contentLoaderInfo.applicationDomain;
			
			dispatchEvent(new CommandEvent(CommandEvent.COMPLETE));
		}
		/* IO ERROR */
		private function _ioErrorHandler ( evt :IOErrorEvent ) :void 
		{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,         _completeHandler);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,  _ioErrorHandler);
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, _progressHandler);
			
			if (_retryCount < 4)
			{
				_retryTimer.reset();
				_retryTimer.addEventListener(TimerEvent.TIMER, _timerHandler);
				_retryTimer.delay       = _retryCount * 1000;
				_retryTimer.repeatCount = 1;
				
				_retryTimer.start();
			}
			else
			{
				dispatchEvent(new CommandEvent(CommandEvent.FAILED));
			}
			
			_retryCount ++;
		}
		
		/* RETRY TIMER */
		private function _timerHandler( evt :TimerEvent) :void 
		{
			_retryTimer.removeEventListener(TimerEvent.TIMER, _timerHandler);
			
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,         _completeHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,  _ioErrorHandler);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, _progressHandler);
			
			if (! _isCurrentDomain)
			{
				_loader.load(new URLRequest(_path));
			}
			else
			{
				var context:LoaderContext = new LoaderContext();
				context.applicationDomain = ApplicationDomain.currentDomain;
				_loader.load(new URLRequest(_path), context);
			}
		}
		
		/* PROGRESS */
		private function _progressHandler ( evt :ProgressEvent ) :void 
		{
			var e :CommandEvent = new CommandEvent(CommandEvent.PROGRESS);
			e.percent = evt.bytesLoaded / evt.bytesTotal;
			dispatchEvent(e);
		}
		
		// ------------------------------------------------------------------- getter
		/* APPLICATION DOMAIN */
		public function get domain ( ) :ApplicationDomain { return _domain; }
		/* LOADER */
		public function get loader ( ) :Loader { return _loader; }
	}
}