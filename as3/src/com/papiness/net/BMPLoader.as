package com.papiness.net 
{
	import com.voidelement.images.BMPDecoder;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	/**
	* @eventType Event.COMPLETE
	*/
	[Event(name="complete", type="flash.events.Event")]
	/**
	* @eventType IOErrorEvent.IO_ERROR
	*/
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	
	
	/**
	 * BMPを読み込みます。
	 * @author daniwell
	 */
	public class BMPLoader extends EventDispatcher
	{
		private var _urlloader :URLLoader
		private var _image  :Bitmap;
		
		public function BMPLoader() 
		{
			
		}
		
		// ------------------------------------------------------------------- public methods
		/**
		 * 読み込みを開始します。
		 * @param	url		画像パス。
		 */
		public function load ( url :String ) :void
		{
			close();
			
			_urlloader = new URLLoader();
			_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			
			_urlloader.addEventListener( Event.COMPLETE, _loadComplete );
			_urlloader.addEventListener( IOErrorEvent.IO_ERROR, _ioError );
			_urlloader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, _securityError );
			
			_urlloader.load( new URLRequest( url ) );
		}
		/**
		 * 接続を閉じ、オブジェクトを破棄します。
		 */
		public function close ( ) :void
		{
			_removeEvent();
			
			try { _urlloader.close(); } catch ( e :Error ) { };
			_urlloader = null;
		}
		
		// ------------------------------------------------------------------- private methods
		/* Event 外す */
		private function _removeEvent ( ) :void
		{
			if ( _urlloader )
			{
				_urlloader.removeEventListener( Event.COMPLETE, _loadComplete );
				_urlloader.removeEventListener( IOErrorEvent.IO_ERROR, _ioError );
				_urlloader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, _securityError );
			}
		}
		
		// ------------------------------------------------------------------- Event
		/* COMPLETE */
		private function _loadComplete ( evt :Event ) :void
		{
			_removeEvent();
			
			try
			{
				var decoder :BMPDecoder = new BMPDecoder();
				_image = new Bitmap( decoder.decode( _urlloader.data ) );
				
				dispatchEvent( evt );
			}
			catch ( e :Error )
			{
				dispatchEvent( new IOErrorEvent(IOErrorEvent.IO_ERROR) );
			}
		}
		/* IO ERROR */
		private function _ioError ( evt :IOErrorEvent ) :void
		{
			close();
			dispatchEvent( evt );
		}
		/* SECURITY ERROR */
		private function _securityError ( evt :SecurityErrorEvent ) :void
		{
			close();
			dispatchEvent( new IOErrorEvent(IOErrorEvent.IO_ERROR) );
		}
		
		// ------------------------------------------------------------------- getter
		/** Bitmap */
		public function get image ( ) :Bitmap { return _image; }
	}
}