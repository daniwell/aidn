package com.papiness.api.tumblr.command 
{
	import com.papiness.api.tumblr.model.TumblrData;
	import com.papiness.api.tumblr.model.TumblrPhotoData;
	import com.papiness.events.CommandEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	
	/** @eventType CommandEvent.COMPLETE */
	[Event(name="commandComplete", type="com.papiness.events.CommandEvent")]
	/** @eventType CommandEvent.PROGRESS */
	[Event(name="commandProgress", type="com.papiness.events.CommandEvent")]
	/** @eventType CommandEvent.FAILED */
	[Event(name="commandFailed", type="com.papiness.events.CommandEvent")]
	
	/**
	 * 
	 * @author daniwell
	 */
	public class TumblrReadPhotoCommand extends EventDispatcher
	{
		private var PATH :String = ".tumblr.com/api/read";
		
		private var _urlloader :URLLoader;
		
		private var _user  :String;
		private var _num   :int;
		private var _start :int;
		
		
		private var _data       :TumblrData;
		private var _photoDatas :/*TumblrPhotoData*/Array;
		
		
		public function TumblrReadPhotoCommand( user :String = "" ) 
		{
			_user = user;
			_init();
		}
		
		
		// ------------------------------------------------------------------- public methods
		public function setUser ( user :String ) :void
		{
			_user = user;
		}
		
		public function execute ( num :int = 20, start :int = 0 ) :void
		{
			cancel();
			
			_addEvents();
			
			var path :String = "http://" + _user + PATH + "?start=" + start + "&num=" + num + "&type=photo";
			_urlloader.load(new URLRequest(path));
		}
		
		public function cancel ( ) :void
		{
			try { _urlloader.close(); } catch ( e :* ) { };
			
			_removeEvents();
		}
		
		
		// ------------------------------------------------------------------- private methods
		
		private function _init ( ) :void
		{
			_urlloader = new URLLoader();
			
		}
		
		private function _addEvents ( ) :void
		{
			_urlloader.addEventListener(Event.COMPLETE,                    _completeHandler);
			_urlloader.addEventListener(ProgressEvent.PROGRESS,            _progressHandler);
			_urlloader.addEventListener(IOErrorEvent.IO_ERROR,             _ioErrorHandler);
			_urlloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _securityErrorHandler);
		}
		private function _removeEvents ( ) :void
		{
			_urlloader.removeEventListener(Event.COMPLETE,                    _completeHandler);
			_urlloader.removeEventListener(ProgressEvent.PROGRESS,            _progressHandler);
			_urlloader.removeEventListener(IOErrorEvent.IO_ERROR,             _ioErrorHandler);
			_urlloader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _securityErrorHandler);
		}
		
		// ------------------------------------------------------------------- Event
		/* COMPLETE */
		private function _completeHandler ( evt :Event ) :void 
		{
			var xml :XML = new XML(_urlloader.data);
			
			
			_data       = new TumblrData(xml);
			_photoDatas = [];
			
			for each (var tmp :XML in xml.posts.post)
			{
				var tpd :TumblrPhotoData = new TumblrPhotoData(tmp);
				_photoDatas.push(tpd);
			}
			
			
			dispatchEvent(new CommandEvent(CommandEvent.COMPLETE));
		}
		/* PROGRESS */
		private function _progressHandler ( evt :ProgressEvent ) :void 
		{
			var e :CommandEvent = new CommandEvent(CommandEvent.PROGRESS);
			e.percent = _urlloader.bytesLoaded / _urlloader.bytesTotal;
			dispatchEvent(new CommandEvent(CommandEvent.PROGRESS));
		}
		/* IO ERROR */
		private function _ioErrorHandler ( evt :IOErrorEvent ) :void 
		{
			trace("io error");
			
			_removeEvents();
			dispatchEvent(new CommandEvent(CommandEvent.FAILED));
		}
		/* SECURITY ERROR */
		private function _securityErrorHandler ( evt :SecurityErrorEvent ) :void 
		{
			trace("security error");
			
			_removeEvents();
			dispatchEvent(new CommandEvent(CommandEvent.FAILED));
		}
		
		
		// ------------------------------------------------------------------- getter
		public function get data       ( ) :TumblrData               { return _data; }
		public function get photoDatas ( ) :/*TumblrPhotoData*/Array { return _photoDatas; }
		
	}
}