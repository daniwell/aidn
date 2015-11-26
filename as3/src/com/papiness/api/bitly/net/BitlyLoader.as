package com.papiness.api.bitly.net
{
	import com.adobe.serialization.json.JSON;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	/**
	* @eventType Event.COMPLETE
	*/
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * 
	 * @author daniwell
	 */
	public class BitlyLoader extends EventDispatcher
	{
		private var _userName :String;
		private var _apiKey   :String;
		
		private var _urlloader :URLLoader;
		
		private var _url       :String;
		private var _shortURL  :String;
		private var _longURL   :String;
		
		private var _retryCount :int;
		private var _retryTimer :Timer;
		
		
		public function BitlyLoader( userName :String, apiKey   :String ) 
		{
			_userName = userName;
			_apiKey   = apiKey;
			
			_urlloader  = new URLLoader();
			_retryTimer = new Timer(0);
		}
		
		// ---------------------------------------------------------------------------------- public methods
		/**
		 * URLを短縮します。
		 * @param	longURL		短縮するURL。
		 */
		public function load ( longURL :String ) :void
		{
			close();
			
			_longURL    = longURL;
			_retryCount = 1;
			
			
			var url :String = "http://api.bit.ly/shorten?version=2.0.1";
			url += "&login="  + _userName;
			url += "&apiKey=" + _apiKey;
			url += "&longUrl=" + encodeURI( longURL );
			
			if ( ! _urlloader.hasEventListener(Event.COMPLETE) )
			{
				_urlloader.addEventListener(Event.COMPLETE,        _complete);
				_urlloader.addEventListener(IOErrorEvent.IO_ERROR, _ioError);
				_urlloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _securityError);
			}
			
			_url = url;
			
			_urlloader.load( new URLRequest( url ) );
		}
		
		/**
		 * 接続を閉じます。
		 */
		public function close ( ) :void
		{
			_retryTimer.removeEventListener(TimerEvent.TIMER, _timerHandler);
			
			try { _urlloader.close(); } catch ( e :* ) { };
		}
		
		// ---------------------------------------------------------------------------------- Event
		/* COMPLETE */
		private function _complete ( evt :Event ) :void
		{
			_urlloader.removeEventListener(Event.COMPLETE,        _complete);
			_urlloader.removeEventListener(IOErrorEvent.IO_ERROR, _ioError);
			_urlloader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _securityError);
			
			/* @test
			var s :String = "";
			s += '{\n';
			s += '    "errorCode": 0, \n';
			s += '    "errorMessage": "", \n';
			s += '    "results": {\n';
			s += '        "http://www.google.co.jp/": {\n';
			s += '            "hash": "1vXXu4", \n';
			s += '            "shortCNAMEUrl": "http://bit.ly/95p67A", \n';
			s += '            "shortKeywordUrl": "", \n';
			s += '            "shortUrl": "http://bit.ly/95p67A", \n';
			s += '            "userHash": "95p67A"\n';
			s += '        }\n';
			s += '    }, \n';
			s += '    "statusCode": "OK"\n';
			s += '}';
			*/
			
			var obj :Object = JSON.decode( String(_urlloader.data) );
			
			if ( obj.statusCode == "OK" )
			{
				for each ( var o :Object in obj.results )
				{
					if ( o.shortUrl )
						_shortURL = o.shortUrl;
				}
				trace(_shortURL);
				
				dispatchEvent( new Event(Event.COMPLETE) );
			}
			else
			{
				dispatchEvent( new IOErrorEvent(IOErrorEvent.IO_ERROR) );
			}
			
		}
		/* IO ERROR */
		private function _ioError ( evt :IOErrorEvent ) :void
		{
			trace("io error");
			
			if (_retryCount < 16)
			{
				_retryTimer.reset();
				_retryTimer.addEventListener(TimerEvent.TIMER, _timerHandler);
				_retryTimer.repeatCount = 1;
				_retryTimer.delay = _retryCount * 1000;
				_retryTimer.start();
			}
			else
			{
				dispatchEvent( evt );
			}
			
			_retryCount *= 2;
			
			var t :Timer = new Timer( 1000 + Math.random() * 1000, 1 );
			t.addEventListener(TimerEvent.TIMER, _timerHandler);
			t.start();
		}
		/* SECURITY ERROR */
		private function _securityError ( evt :SecurityErrorEvent ) :void
		{
			trace("security error");
			
			dispatchEvent( evt );
		}
		/* TIMER */
		private function _timerHandler ( evt :TimerEvent ) :void
		{
			_retryTimer.removeEventListener(TimerEvent.TIMER, _timerHandler);
			
			_urlloader.load( new URLRequest( _url ) );
		}
		
		// ---------------------------------------------------------------------------------- getter
		/* 短縮URL */
		public function get shortURL ( ) :String { return _shortURL; }
		/* 短縮前のURL */
		public function get longURL  ( ) :String { return _longURL; }
		
	}
}