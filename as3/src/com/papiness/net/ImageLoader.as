package com.papiness.net
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
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
	 * 画像（PNG,JPG,GIF,BMP）を読み込みます。
	 * @author daniwell
	 */
	public class ImageLoader extends EventDispatcher
	{
		private var _image      :*;
		private var _loader     :Loader;
		private var _bmploader  :BMPLoader;
		
		private var _url        :String;
		
		private var _retryTimer :Timer;
		private var _retryNum   :int;
		
		private var _isBitmap   :Boolean;
		
		
		public function ImageLoader() 
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
			
			_isBitmap = false;
			
			_loader    = new Loader();	
			_bmploader = new BMPLoader();
			
			_addEvent();
			
			_retryNum = 1;
			_url      = encodeURI(url);
			
			var context :LoaderContext = new LoaderContext( true );
			_loader.load( new URLRequest( _url ), context );
		}
		/**
		 * 接続を閉じ、オブジェクトを破棄します。
		 */
		public function close ( ) :void
		{
			if ( _retryTimer )
			{
				_retryTimer.reset();
				_retryTimer.removeEventListener( TimerEvent.TIMER, _retryLoad );
				_retryTimer = null;
			}
			if ( _image )
			{
				if ( _image is Bitmap )		if ( _image.bitmapData ) _image.bitmapData.dispose();
				_image = null;
			}
			
			_removeEvent();
			_removeEventBmp();
			
			try { _loader.close();    } catch ( e :Error ) { }
			try { _bmploader.close(); } catch ( e :Error ) { }
			
			_loader    = null;
			_bmploader = null;
		}
		
		
		// ------------------------------------------------------------------- private methods
		/* RETRY */
		private function _retry ( ) :void
		{
			if ( ! _retryTimer )
			{
				_retryTimer = new Timer( 1000 );
				_retryTimer.addEventListener( TimerEvent.TIMER, _retryLoad );
				_retryNum = 1;
			}
			
			if ( _retryNum < 3 )
			{
				_retryTimer.reset();
				_retryTimer.delay       = _retryNum * 1000;
				_retryTimer.repeatCount = 1;
				_retryTimer.start();
				
				_retryNum += 1;
			}
			else
			{
				close();
				dispatchEvent( new IOErrorEvent(IOErrorEvent.IO_ERROR) );
			}
		}
		private function _retryLoad ( evt :TimerEvent ) :void
		{
			_loader.load( new URLRequest( _url ) );
		}
		
		
		
		// ------------------------------------------------------------------- Event
		/* COMPLETE */
		private function _loadComplete ( evt :Event ) :void 
		{
			_removeEvent();
			
			try	{
				_image = Bitmap( _loader.content );
				_isBitmap = true;
				_image.smoothing = true;
			} catch ( e :Error ) {
				_isBitmap = false;
				_image = _loader;
			}
			
			dispatchEvent( evt );
		}
		/* IO ERROR */
		private function _ioError ( evt :IOErrorEvent ) :void 
		{
			trace( evt.text );
			_isBitmap = false;
			
			if ( evt.text.indexOf("Error #2124") == -1 )
			{
				_retry();
			}
			else
			{
				_removeEvent();
				
				_addEventBmp();
				_bmploader.load(_url);
			}
		}
		
		/* COMPLETE (BMP) */
		private function _bmpComplete ( evt :Event ) :void
		{
			_removeEventBmp();
			_image = _bmploader.image;
			
			dispatchEvent( evt );
		}
		/* IO ERROR (BMP) */
		private function _bmpError ( evt :IOErrorEvent ) :void
		{
			_removeEventBmp();
			
			dispatchEvent( evt );
		}
		
		
		// ------------------------------------------------------------------- getter
		/** Bitmap or Loader */
		public function get image ( ) :* { return _image; }
		/** true: Bitmap, false: Loader */
		public function get isBitmap( ) :Boolean { return _isBitmap; }
		
		
		
		// ------------------------------------------------------------------- 
		private function _addEvent ( ) :void
		{
			if ( _loader && ! _loader.contentLoaderInfo.hasEventListener( Event.COMPLETE ) )
			{
				_loader.contentLoaderInfo.addEventListener( Event.COMPLETE,        _loadComplete );
				_loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, _ioError );
			}
		}
		private function _removeEvent ( ) :void
		{
			if ( _loader )
			{
				_loader.contentLoaderInfo.removeEventListener( Event.COMPLETE,        _loadComplete );
				_loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, _ioError );
			}
		}
		private function _addEventBmp ( ) :void
		{
			if ( _bmploader && ! _bmploader.hasEventListener( Event.COMPLETE ) )
			{
				_bmploader.addEventListener( Event.COMPLETE,        _bmpComplete );
				_bmploader.addEventListener( IOErrorEvent.IO_ERROR, _bmpError );
			}
		}
		private function _removeEventBmp ( ) :void
		{
			if ( _bmploader )
			{
				_bmploader.removeEventListener( Event.COMPLETE,        _bmpComplete );
				_bmploader.removeEventListener( IOErrorEvent.IO_ERROR, _bmpError );
			}
		}
		
	}
}