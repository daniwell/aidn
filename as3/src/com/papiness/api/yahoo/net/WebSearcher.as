package com.papiness.api.yahoo.net 
{
	import flash.events.*;
	import flash.net.*;
	
	/**
	* @eventType Event.COMPLETE
	*/
	[Event(name="complete", type="flash.events.Event")]
	/**
	* @eventType IOErrorEvent.IO_ERROR
	*/
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	/**
	* @eventType SecurityErrorEvent.SECURITY_ERROR
	*/
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
	
	
	/**
	 * ウェブ検索 - Yahoo! API
	 * @author daniwell
	 */
	public class WebSearcher extends EventDispatcher
	{
		private const API_PATH :String = "http://search.yahooapis.jp/WebSearchService/V1/webSearch";
		
		private var _id :String;
		
		private var _urlloader :URLLoader;
		private var _xml :XML;
		
		private var _total :Number = 0;
		
		/* ページタイトル */
		public var title   :/*String*/Array;
		/* ページ要約 */
		public var summary :/*String*/Array;
		
		/**
		 * WebSearcher オブジェクトを生成します。
		 * @param	id	アプリケーションID。
		 */
		public function WebSearcher ( id :String = null ) 
		{
			if ( id ) _id = id;
			_urlloader = new URLLoader();
		}
		
		// ------------------------------------------------------------------- public methods
		/**
		 * Webページを検索します。
		 * @param	query	検索文字列。
		 * @param	num		検索結果の個数。
		 * @param	start	開始ページ。
		 */
		public function execute ( query :String, num :int = 10, start :int = 1 ) :void
		{
			close();
			
			var variables :URLVariables = new URLVariables();
			variables.appid   = _id;
			variables.query   = query;
			variables.results = num;
			variables.start   = start;
			
			var request :URLRequest = new URLRequest( API_PATH );
			request.data   = variables;
			request.method = URLRequestMethod.POST;
			
			_addEvent();
			_urlloader.load( request );
		}
		
		/**
		 * 接続を閉じます。
		 */
		public function close ( ) :void
		{
			_removeEvent();
			try { _urlloader.close(); } catch ( e :Error ) { };
		}
		/**
		 * アプリケーションIDをセットします。
		 * @param	id		アプリケーションID。
		 */
		public function setId ( id :String ) :void
		{
			_id = id;
		}
		
		// ------------------------------------------------------------------- private methods
		/* XML を配列へ */
		private function _parseXML ( str :String ) :void
		{
			_xml = new XML( str );
			
			_total = parseFloat( _xml.@totalResultsAvailable );
			
			namespace ns = 'urn:yahoo:jp:srch';
			use namespace ns;
			
			title   = new Array();
			summary = new Array();
			
			var i :int = 0;
			
			for each ( var xml1 :XML in _xml.Result )
			{
				title[i]   = xml1.Title;
				summary[i] = xml1.Summary;
				i ++;
			}
		}
		
		private function _addEvent ( ) :void
		{
			if ( ! _urlloader.hasEventListener( Event.COMPLETE ) )
			{
				_urlloader.addEventListener( Event.COMPLETE,                    _loaderComplete );
				_urlloader.addEventListener( IOErrorEvent.IO_ERROR,             _loaderIoError );
				_urlloader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, _loaderSecurityError );
			}
		}
		private function _removeEvent ( ) :void
		{
			_urlloader.removeEventListener( Event.COMPLETE,                    _loaderComplete );
			_urlloader.removeEventListener( IOErrorEvent.IO_ERROR,             _loaderIoError );
			_urlloader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, _loaderSecurityError );
		}
		
		// ------------------------------------------------------------------- Event
		/* COMPLETE */
		private function _loaderComplete ( evt :Event ) :void
		{
			_removeEvent();
			_parseXML( _urlloader.data );
			
			dispatchEvent( evt );
		}
		
		/* IO ERROR */
		private function _loaderIoError ( evt :IOErrorEvent ) :void
		{
			_removeEvent();
			dispatchEvent( evt );
		}
		/* SECURITY ERROR */
		private function _loaderSecurityError ( evt :SecurityErrorEvent ) :void
		{
			_removeEvent();
			dispatchEvent( evt );
		}
		
		// ------------------------------------------------------------------- getter
		/** 検索結果の総数 */
		public function get total():Number { return _total; }
		
	}
}