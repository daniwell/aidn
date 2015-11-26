package com.papiness.api.twitter.net 
{
	import com.adobe.serialization.json.JSON;
	import com.papiness.api.twitter.model.TweetData;
	import com.papiness.api.twitter.model.UserStatus;
	import com.papiness.api.twitter.utils.DateUtil;
	import com.rails2u.net.JSONPLoader;
	import flash.display.LoaderInfo;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
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
	 * Twitter USER_TIMELINE を取得します。
	 * @author daniwell
	 */
	public class UserTimelineLoader extends EventDispatcher
	{
		private const PATH :String = "http://twitter.com/statuses/user_timeline/";
		
		private var _user  :UserStatus;
		private var _datas :/*TweetData*/Array;
		
		private var _requestPath :String;
		private var _jsonpLoader :JSONPLoader;
		
		private var _timer   :Timer;
		private var _isLocal :Boolean;
		
		private var _urlloader :URLLoader;
		
		private var _count :int;
		
		/**
		 * UserTimelineLoader オブジェクトを生成します。
		 */
		public function UserTimelineLoader( info :LoaderInfo = null ) 
		{
			_isLocal = false;
			if ( info && info.url.indexOf("http://") == -1 ) _isLocal = true;
			
			_init();
		}
		
		// ------------------------------------------------------------------- public methods
		/**
		 * 読み込み開始します。
		 * @param	id		ユーザーID
		 * @param	param	{ count: 取得数, page: ページ番号, since_id: 指定したID以上のもの, max_id: 指定したID以下のもの }
		 */
		public function load ( id :String, param :Object = null ) :void
		{
			if ( ! _jsonpLoader.hasEventListener( Event.COMPLETE ) )
			{
				_jsonpLoader.addEventListener( Event.COMPLETE, _completeHandler );
				_jsonpLoader.addEventListener( IOErrorEvent.IO_ERROR, _ioErrorHandler );
			}
			
			var path :String = PATH + id + ".json";
			if ( param ) path += "?" + connectObject(param);
			
			_count       = 0;
			_requestPath = path;
			
			if ( _isLocal )
			{
				if ( ! _urlloader )
				{
					_urlloader = new URLLoader();
					_urlloader.addEventListener( Event.COMPLETE,        _completeHandler );
					_urlloader.addEventListener( IOErrorEvent.IO_ERROR, _ioErrorHandler );
				}
				_urlloader.load( new URLRequest( _requestPath ) );
			}
			else
				_jsonpLoader.load(_requestPath);
		}
		
		/**
		 * 接続を閉じます。
		 */
		public function close ( ) :void
		{
			if ( ! _timer )
			{
				_timer.reset();
				_timer.removeEventListener( TimerEvent.TIMER, _timerHandler );
				_timer = null;
			}
			_jsonpLoader.removeEventListener( Event.COMPLETE, _completeHandler );
			_jsonpLoader.removeEventListener( IOErrorEvent.IO_ERROR, _ioErrorHandler );
		}
		
		// ------------------------------------------------------------------- private methods
		/* 初期化 */
		private function _init () :void
		{
			_jsonpLoader = new JSONPLoader();
		}
		
		/* パラメータの連結 */
		private function connectObject ( obj :Object ) :String
		{
			var str  :String  = "";
			var flag :Boolean = false;
			
			for ( var s :String in obj )
			{
				if ( ! flag )
				{
					str += s + "=" + obj[s];
					flag = true;
				}
				else
				{
					str += "&" + s + "=" + obj[s];
				}
			}
			return str;
		}
		
		/* 取得データのパース */
		private function parseObject ( obj :Object ) :void
		{
			var flag :Boolean = false;
			
			/* 初期化 */
			for each ( var d :TweetData in _datas ) d = null;
			_datas = null;
			_user  = null;
			
			_datas = new Array();
			_user  = new UserStatus();
			
			for ( var s :String in obj )
			{
				var data :Object = obj[s];
				
				var td :TweetData = new TweetData();
				td.id             = Number(data.id);
				td.text           = data.text;
				td.created_at     = DateUtil.getDate(data.created_at);
				
				_datas.push( td );
				
				if ( ! flag )
				{
					var user :Object = data.user;
					
					_user.screen_name       = user.screen_name;
					_user.name              = user.name;
					_user.location          = user.location;
					_user.url               = user.url;
					_user.description       = user.description;
					_user.profile_image_url = user.profile_image_url;
					_user.friends_count     = parseInt(user.friends_count);
					_user.followers_count   = parseInt(user.followers_count);
					_user.favourites_count  = parseInt(user.favourites_count);
					_user.statuses_count    = parseInt(user.statuses_count);
					_user.following         = Boolean(user.following);
					
					flag = true;
				}
			}
		}
		
		// ------------------------------------------------------------------- Event
		/* COMPLETE */
		private function _completeHandler ( evt :Event ) :void
		{
			_jsonpLoader.removeEventListener( Event.COMPLETE, _completeHandler );
			_jsonpLoader.removeEventListener( IOErrorEvent.IO_ERROR, _ioErrorHandler );
			
			var obj :Object;
			
			if ( _isLocal )	obj = JSON.decode(evt.target.data);
			else			obj = evt.target.data;
				
			parseObject( obj );
			dispatchEvent( evt );
		}
		/* IO ERROR (timeout) */
		private function _ioErrorHandler ( evt :IOErrorEvent ) :void
		{
			_count ++;
			
			if ( _count < 2 )
			{
				// retry
				if ( ! _timer )
				{
					_timer = new Timer( 1000 );
					_timer.addEventListener( TimerEvent.TIMER, _timerHandler );
				}
				_timer.reset();
				_timer.delay = 1000;
				_timer.repeatCount = 1;
				_timer.start();
			}
			else
			{
				_jsonpLoader.removeEventListener( Event.COMPLETE, _completeHandler );
				_jsonpLoader.removeEventListener( IOErrorEvent.IO_ERROR, _ioErrorHandler );
				
				dispatchEvent( evt );
			}
		}
		
		private function _timerHandler ( evt :TimerEvent ) :void
		{
			if ( _isLocal )	_urlloader.load( new URLRequest(_requestPath) );
			else			_jsonpLoader.load( _requestPath );
		}
		
		// ------------------------------------------------------------------- getter
		/* Twitter のユーザーステータス */
		public function get userStatus   ( ) :UserStatus       { return _user; }
		/* ツイートのデータ */
		public function get tweetDatas ( ) :/*TweetData*/Array { return _datas; }
	}
}