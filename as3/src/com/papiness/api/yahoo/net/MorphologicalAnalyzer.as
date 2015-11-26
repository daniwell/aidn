package com.papiness.api.yahoo.net 
{
	import com.papiness.api.yahoo.model.MorphData;
	import com.papiness.utils.TextFiltering;
	
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
	 * 形態素解析 - Yahoo! API
	 * @author daniwell
	 */
	public class MorphologicalAnalyzer extends EventDispatcher
	{
		private const API_PATH :String = "http://jlp.yahooapis.jp/MAService/V1/parse";
		
		private var _id :String;
		
		private var _urlloader :URLLoader;
		private var _xml :XML;
		
		private var _datas :/*MorphData*/Array;
		private var _total :int;
		
		private var _except :Boolean;
		
		/**
		 * MorphologicalAnalyzer オブジェクトを生成します。
		 * @param	id	アプリケーションID。
		 */
		public function MorphologicalAnalyzer( id :String = null ) 
		{
			if ( id ) _id = id;
			_urlloader = new URLLoader();
		}
		
		// ------------------------------------------------------------------- public methods
		/**
		 * 形態素解析を開始します。
		 * @param	sentence	解析するテキスト。
		 * @param	results		解析結果の種類。
		 * @param	filter		フィルター(デフォルトは 形容詞, 形容動詞, 連体詞, 名詞, 動詞 )。
		 * @param	except		"サ変", "名サ自", "数詞" の除外。
		 */
		public function execute ( sentence :String, results :String = "ma", filter :String = "1|2|5|9|10", except :Boolean = true ) :void
		{
			close();
			
			var variables :URLVariables = new URLVariables();
			variables.appid    = _id;
			variables.sentence = sentence;
			variables.results  = results;
			variables.response = "surface,pos,baseform,feature";
			variables.filter   = filter;
			
			var request :URLRequest = new URLRequest( API_PATH );
			request.data   = variables;
			request.method = URLRequestMethod.POST;
			
			_except = except;
			
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
		/* 取得データを配列へパース */
		private function _parseXML ( str :String ) :void
		{
			_xml = new XML( str );
			
			namespace ns = 'urn:yahoo:jp:jlp';
			use namespace ns;
			
			_datas = new Array();
			
			var a :Array = ["サ変", "名サ自", "数詞"];	// 除外
			
			for each ( var xml1 :XML in _xml.ma_result.word_list.word )
			{
				var p :String = xml1.feature.split(",")[1];
				
				if ( _except )
				{
					if ( TextFiltering.check( p, a, true ) )	continue;
					if ( ! isNaN( parseInt(xml1.baseform) ) )	continue;
				}
				
				var md :MorphData = new MorphData();
				md.baseform = xml1.baseform;
				md.pos      = xml1.pos;
				md.surface  = xml1.surface;
				
				_datas.push( md );
			}
			
			_total = _datas.length;
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
			
			_urlloader.removeEventListener(Event.COMPLETE, _loaderComplete);
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
		/** 形態素のデータ */
		public function get morphDatas ( ) :/*MorphData*/Array { return _datas; }
		/** 形態素の総数 */
		public function get total ( ) :int { return _total; }
		
	}
}