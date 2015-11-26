package aidn.main.media 
{
	import aidn.main.events.VideoEvent;
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	/** @eventType VideoEvent.INIT */
	[Event(name="videoInit",     type="aidn.main.events.VideoEvent")]
	/** @eventType VideoEvent.START */
	[Event(name="videoStart",    type="aidn.main.events.VideoEvent")]
	/** @eventType VideoEvent.END */
	[Event(name="videoEnd",      type="aidn.main.events.VideoEvent")]
	/** @eventType VideoEvent.META_DATA */
	[Event(name="videoMetaData", type="aidn.main.events.VideoEvent")]
	
	
	public class VideoPlayer extends Video
	{
		private var _path :String;
		
		private var _connection :NetConnection;
		private var _stream     :NetStream;
		
		private var _duration  :Number;
		private var _rawWidth  :int;
		private var _rawHeight :int;
		
		private var _volume    :Number = 1;
		
		private var _isInited  :Boolean;
		private var _isPlaying :Boolean;
		private var _isPlayed  :Boolean;
		
		
		public function VideoPlayer( width :int = 320, height :int = 240 ) 
		{
			super(width, height);
		}
		
		// ------------------------------------------------------------------- public methods
		
		public function init ( path :String = null, volume :Number = 1.0 ) :void
		{
			this.volume = volume;
			_isInited = _isPlayed = _isPlaying = false;
			_path = path;
			
			_connection = new NetConnection();
			_connection.addEventListener(NetStatusEvent.NET_STATUS,         _netStatusHandler);
			_connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _securityErrorHandler);
			_connection.connect(null);
		}
		
		public function seek ( offset :Number ) :void
		{
			_stream.seek(offset);
		}
		public function resume ( ) :void
		{
			_isPlaying = true;
			_stream.resume();
		}
		public function play ( src :String = null ) :void
		{
			if (src) _path = src;
			_stream.play(_path);
			
			_isPlayed  = true;
			_isPlaying = true;
		}
		public function pause ( ) :void
		{
			_stream.pause();
			
			_isPlaying = false;
		}
		
		public function kill ( ) :void
		{
			_isInited = _isPlayed = _isPlaying = false;
			
			if (_connection)
			{
				_connection.removeEventListener(NetStatusEvent.NET_STATUS,         _netStatusHandler);
				_connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _securityErrorHandler);
				try { _connection.close(); } catch ( e :* ) { };
				
				_connection = null;
			}
			if (_stream)
			{
				_stream.removeEventListener(NetStatusEvent.NET_STATUS,   _netStatusHandler);
				_stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, _asyncErrorHandler);
				try { _stream.close(); } catch ( e :* ) { };
				clear();
				
				_stream = null;
			}
		}
		
		
		// ------------------------------------------------------------------- private methods
		
		private function _initConnect ( ) :void
		{
			_isInited = true;
			
			_stream = new NetStream(_connection);
			_stream.addEventListener(NetStatusEvent.NET_STATUS,   _netStatusHandler);
			_stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, _asyncErrorHandler);
			_stream.client = this;
			_stream.bufferTime = 0.1;
			
			volume = volume;
			
			this.smoothing = true;
			this.attachNetStream(_stream);
		}
		
		
		private function _netStatusHandler ( evt :NetStatusEvent ) :void 
		{
			switch (evt.info.code)
			{
			// NetConnection
			case "NetConnection.Connect.Success":
				_initConnect();
				dispatchEvent(new VideoEvent(VideoEvent.INIT));
				break;
				
			// NetStream
			case "NetStream.Play.StreamNotFound":
				trace("Unable to locate video: " + _path);
				break;
			case "NetStream.Play.Start":
				dispatchEvent(new VideoEvent(VideoEvent.START));
				break;
			case "NetStream.Play.Stop":
				dispatchEvent(new VideoEvent(VideoEvent.END));	    
				break;
			case "NetStream.Buffer.Full":
				break;
			}
		}
		private function _securityErrorHandler ( evt :SecurityErrorEvent ) :void { }
		private function _asyncErrorHandler    ( evt :AsyncErrorEvent    ) :void { }
		
		public function onMetaData ( info :Object ) :void
		{
			_duration  = info.duration;
			_rawWidth  = info.width;
			_rawHeight = info.height;
			
			dispatchEvent(new VideoEvent(VideoEvent.META_DATA));
		}
		public function onXMPData    ( info :Object ) :void { }
		public function onPlayStatus ( info :Object ) :void { }
		
		
		// ------------------------------------------------------------------- getter & setter
		
		public function get time     ( ) :Number { return _stream.time; }
		public function get duration ( ) :Number { return _duration; }
		public function get progress ( ) :Number { return _stream.time / _duration; }
		
		public function get volume () :Number { return _volume; };
		public function set volume ( value :Number ) :void
		{
			if (value < 0) value = 0;
			if (3 < value) value = 3;
			_volume = value;
			
			if (_stream)
			{
				var st :SoundTransform = _stream.soundTransform;
				st.volume = value;
				_stream.soundTransform = st;
			}
		};
		
		public function get stream     ( ) :NetStream     { return _stream; }
		public function get connection ( ) :NetConnection { return _connection; }
		
		public function get rawWidth  ( ) :int { return _rawWidth; }
		public function get rawHeight ( ) :int { return _rawHeight; }
		
		public function get loadingProgress ( ) :Number { return (_stream) ? _stream.bytesLoaded / stream.bytesTotal : -1; };
		
		/** 初期化済みかどうか */
		public function get isInited  ( ) :Boolean { return _isInited; }
		/** 一度でも再生開始されたか */
		public function get isPlayed  ( ) :Boolean { return _isPlayed; }
		/** 再生中かどうか */
		public function get isPlaying ( ) :Boolean { return _isPlaying; }
	}
}
