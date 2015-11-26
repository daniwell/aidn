package aidn.api.youtube.display 
{
	import aidn.api.youtube.events.YouTubeEvent;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	public class YouTubePlayer extends Sprite
	{
		private const PLAYER_PATH :String = "http://www.youtube.com/apiplayer?version=3";
		
		private var _isReady :Boolean = false;
		
		private var _player :*;
		
		
		private var _videoId   :String;
		private var _autoPlay  :Boolean;
		private var _startTime :Number;
		private var _quality   :String;
		
		
		public function YouTubePlayer ( ) 
		{
			
		}
		
		/**
		 * 
		 * @param	videoId			動画ID
		 * @param	autoPlay		準備完了後、自動で再生開始するかどうか
		 * @param	startTime		開始時間(秒)
		 * @param	quality			"small", "medium", "large", "hd720", "default"
		 */
		public function init ( videoId :String, autoPlay :Boolean = false, startTime :Number = 0.0, quality:String = "default" ) :void
		{
			_videoId   = videoId;
			_autoPlay  = autoPlay;
			_startTime = startTime;
			_quality   = quality;
			
			if (_isReady)
			{
				_initVideo();
			}
			else
			{
				var l :Loader = new Loader();
				l.contentLoaderInfo.addEventListener(Event.INIT, _loaderInit);
				l.load(new URLRequest(PLAYER_PATH));
			}
		}
		
		public function play ( ) :void
		{
			if (_player) _player.playVideo();
		}
		public function pause ( ) :void
		{
			if (_player) _player.pauseVideo();
		}
		public function seek ( time :Number ) :void
		{
			if (_player) _player.seekTo(time);
		}
		
		public function setSize ( w :int, h :int ) :void
		{
			if (_player) _player.setSize(w, h);
		}
		
		
		
		private function _initVideo ( ) :void
		{
			if (_autoPlay)	_player.loadVideoById(_videoId, _startTime, _quality);
			else			_player .cueVideoById(_videoId, _startTime, _quality);
		}
		
		/// LOADER - INIT
		private function _loaderInit ( evt :Event ) :void 
		{
			var info :LoaderInfo = evt.target as LoaderInfo;
			info.removeEventListener(Event.INIT, _loaderInit);
			
			_player = info.loader.content;
			addChild(_player);
			
			_player.addEventListener("onReady",                 _playerReady);
			_player.addEventListener("onError",                 _playerError);
			_player.addEventListener("onStateChange",           _playerStateChange);
			_player.addEventListener("onPlaybackQualityChange", _playbackQualityChange);
		}
		
		/// PLAYER - READY
		private function _playerReady ( evt :Event ) :void 
		{
			_isReady = true;
			_initVideo();
		}
		
		/// PLAYER - ERROR
		private function _playerError ( evt :Event ) :void 
		{
			// trace("player error:", Object(event).data);
		}
		
		/// PLAYER - STATE CHANGE
		private function _playerStateChange ( evt :Event ) :void 
		{
			// trace("player state:", Object(event).data);
			var state :int = int(Object(evt).data);
			
			switch ( state )
			{
			case -1:		// 未開始
				break;
			case 0:			// 終了
				dispatchEvent(new YouTubeEvent(YouTubeEvent.PLAY_COMPLETE));
				break;
			case 1:			// 再生中
				dispatchEvent(new YouTubeEvent(YouTubeEvent.PLAY));
				break;
			case 2:			// 一時停止中
				dispatchEvent(new YouTubeEvent(YouTubeEvent.PAUSE));
				break;
			case 3:			// バッファリング中
				break;	
			case 5:			// 頭出し完了
				dispatchEvent(new YouTubeEvent(YouTubeEvent.INIT_COMPLETE));
				break;
			}
		}
		
		/// PLAYER - QUALITY CHANGE
		private function _playbackQualityChange ( evt :Event ) :void 
		{
			// trace("video quality:", Object(event).data);
		}
		
		
		/// 動画長さ
		public function get totalTime   ( ) :Number { return _player.getCurrentTime(); };
		/// 現在の再生位置
		public function get currentTime ( ) :Number { return _player.getDuration(); };
		/// YouTube上の動画URL
		public function get videoUrl    ( ) :Number { return _player.getVideoUrl(); };
		
		/// ミュート
		public function get mute ( ) :Boolean { return _player.isMuted(); };
		public function set mute ( value :Boolean ) :void
		{
			if (value)		_player.mute();
			else			_player.unMute();
		};
		
		/// 音量
		public function get volume ( ) :Number { return _player.getVolume(); };
		public function set volume ( value :Number ) :void
		{
			_player.setVolume(value);
		}
	}
}