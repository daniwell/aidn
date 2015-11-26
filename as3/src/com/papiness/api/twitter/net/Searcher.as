package com.papiness.api.twitter.net 
{
	import com.adobe.serialization.json.JSON;
	import com.papiness.api.twitter.model.SearchData;
	import com.papiness.api.twitter.utils.DateUtil;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Security;
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
	 * Twitter 検索を行います。
	 * @author daniwell
	 */
	public class Searcher extends EventDispatcher
	{
		private const PATH :String = "http://search.twitter.com/search.atom";
		
		private var _urlloader   :URLLoader;
		private var _requestPath :String;
		
		private var _timer :Timer;
		private var _count :int;
		
		private var _searchDatas :/*SearchData*/Array;
		
		public function Searcher() 
		{
			Security.loadPolicyFile("http://search.twitter.com/crossdomain.xml");
			
			_urlloader = new URLLoader();
		}
		
		// ------------------------------------------------------------------- public methods
		/**
		 * 検索を開始します。
		 * @param	value	検索文字列。
		 * @param	res		返却数。
		 */
		public function execute ( value :String, res :uint = 20 ) :void
		{
			close();
			
			_count = 0;
			
			if ( ! _urlloader.hasEventListener(Event.COMPLETE) )
			{
				_urlloader.addEventListener(Event.COMPLETE,        _completeHandler);
				_urlloader.addEventListener(IOErrorEvent.IO_ERROR, _ioErrorHandler);
				
				_urlloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _securityError);
			}
			
			_requestPath = PATH + "?rpp=" + res + "&q=" + encodeURIComponent( value );
			_urlloader.load( new URLRequest( _requestPath ) );
			
			
		}
		/**
		 * 接続を閉じます。
		 */
		public function close ( ) :void
		{
			try { _urlloader.close() } catch ( e :* ) { };
			
			_removeEvents();
		}
		
		private function _removeEvents ( ) :void
		{
			_urlloader.removeEventListener( Event.COMPLETE,        _completeHandler );
			_urlloader.removeEventListener( IOErrorEvent.IO_ERROR, _ioErrorHandler );
			
			_urlloader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _securityError);
		}
		
		// ------------------------------------------------------------------- Event
		private function _completeHandler ( evt :Event ) :void
		{
			_removeEvents();
			
			var str :String = String(_urlloader.data);
			
			var xml :XML = XML( str );
			var ns :Namespace = xml.namespace();
			
			_searchDatas = new Array();
			
			for each ( var entry :XML in xml.ns::entry )
			{
				var sd :SearchData = new SearchData();
				
				var idAr :Array = String(entry.ns::id[0]).split(":");
				sd.id                = idAr[idAr.length - 1];
				sd.text              = entry.ns::title[0];
				sd.created_at        = DateUtil.getDateSearchAtom(entry.ns::published[0]);
				sd.profile_image_url = entry.ns::link.@href[1];
				
				sd.status_url = entry.ns::link.@href[0];
				
				var nameAr :/*String*/Array = String(entry.ns::author.ns::name[0]).split(" (");
				
				sd.username = nameAr[0];
				sd.fullname = nameAr[1].substring(0, nameAr[1].length - 1);
				
				_searchDatas.push( sd );
			}
			
			dispatchEvent( evt );
		}
		private function _ioErrorHandler ( evt :IOErrorEvent ) :void
		{
			_removeEvents();
			
			_count ++;
			
			if ( _count < 3 )
			{
				// retry
				if ( ! _timer )
				{
					_timer = new Timer(1000);
					_timer.addEventListener(TimerEvent.TIMER, _timerHandler);
				}
				_timer.reset();
				_timer.delay = 1000 * _count;
				_timer.repeatCount = 1;
				_timer.start();
			}
			else
			{
				dispatchEvent( evt );
			}
		}
		
		private function _securityError ( evt :SecurityErrorEvent ) :void 
		{
			_ioErrorHandler(new IOErrorEvent(IOErrorEvent.IO_ERROR));
		}
		
		
		private function _timerHandler ( evt :TimerEvent ) :void
		{
			_urlloader.load( new URLRequest(_requestPath) );
		}
		
		
		// ------------------------------------------------------------------- getter
		/** SearchData 配列 */
		public function get searchDatas( ) :/*SearchData*/Array { return _searchDatas; }
		
		
		
	}
	
}