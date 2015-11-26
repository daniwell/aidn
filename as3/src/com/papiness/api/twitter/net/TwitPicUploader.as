package com.papiness.api.twitter.net 
{
	import com.adobe.images.PNGEncoder;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	
	/**
	* @eventType Event.COMPLETE
	*/
	[Event(name="complete", type="flash.events.Event")]
	/**
	* @eventType IOErrorEvent.IO_ERROR
	*/
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	
	
	/**
	 * TwitPic にアップロードします (パスワードなどはtwitpic.cgi側)。
	 * @author daniwell
	 */
	public class TwitPicUploader extends EventDispatcher
	{
		private var _cgipath   :String;
		
		private var _urlloader :URLLoader;
		private var _result    :Boolean;
		
		
		/**
		 * TwitPicUploader オブジェクトを生成します。
		 */
		public function TwitPicUploader() 
		{
			_init();
		}
		
		// ------------------------------------------------------------------- public methods
		/**
		 * TwitPic にアップロードします。
		 * @param	image
		 * @param	message
		 */
		public function upload ( image :BitmapData, message :String ) :void
		{
			if ( ! _cgipath ) return;
			
			var bytes :ByteArray = PNGEncoder.encode( image );
			_upload( bytes, message );
		}
		/**
		 * TwitPic にアップロードします(ByteArray)。
		 * @param	bytes
		 * @param	message
		 */
		public function uploadBytes ( bytes :ByteArray, message :String ) :void
		{
			if ( ! _cgipath ) return;
			
			_upload( bytes, message );
		}
		/**
		 * 接続を閉じ、オブジェクトを破棄します。
		 */
		public function close () :void
		{
			_removeEvent();
			try { _urlloader.close();	} catch ( e :* ) { };
		}
		
		/**
		 * 投稿用のCGIのパスを設定します。
		 * @param	path	CGIのパス。
		 */
		public function setCGIPath ( path :String ) :void
		{
			_cgipath = path;
		}
		
		// ------------------------------------------------------------------- private methods
		private function _init () :void
		{
			_urlloader = new URLLoader();
		}
		
		private function _upload ( bytes :ByteArray, message :String ) :void
		{
			close();
			
			_addEvent();
			
			var req :URLRequest = new URLRequest();
			
			req.url = _cgipath + "?message=" + encodeURI( message );
			req.contentType = 'application/octet-stream';
			req.method = URLRequestMethod.POST;
			req.data = bytes;
			
			_urlloader.load(req);
		}
		
		private function _addEvent () :void
		{
			if ( ! _urlloader.hasEventListener( Event.COMPLETE ) )
			{
				_urlloader.addEventListener( Event.COMPLETE,        _uploadComplete );
				_urlloader.addEventListener( IOErrorEvent.IO_ERROR, _uploadIoError );
			}
		}
		private function _removeEvent () :void
		{
			_urlloader.removeEventListener( Event.COMPLETE,        _uploadComplete );
			_urlloader.removeEventListener( IOErrorEvent.IO_ERROR, _uploadIoError );
		}
		
		
		// ------------------------------------------------------------------- Event
		private function _uploadComplete ( evt :Event ) :void
		{
			_removeEvent();
			
			var xml :XML = new XML(_urlloader.data);
			
			if ( xml.@status == "ok" )	_result = true;
			else						_result = false;
			
			dispatchEvent( evt );
		}
		
		private function _uploadIoError ( evt :IOErrorEvent ) :void
		{
			_removeEvent();
			_result = false;
			
			dispatchEvent( evt );
		}
		
		
		// ------------------------------------------------------------------- getter
		/**	投稿の成否。 */
		public function get result () :Boolean { return _result; }
		
	}
}