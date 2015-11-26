package aidn.api.youtube.display 
{
	import aidn.main.util.Debug;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	public class YouTubeEmbedPlayer extends Sprite
	{
		private const PLAYER_PATH :String = "http://www.youtube.com/v/[ID]?version=3&autohide=1&loop=0&rel=0&showinfo=1&iv_load_policy=3";
		
		
		private var _loader :Loader;
		
		private var _player  :*;
		
		private var _videoId     :String;
		private var _videoWidth  :int;
		private var _videoHeight :int;
		
		public function YouTubeEmbedPlayer ( ) 
		{
			
		}
		
		public function init ( videoId :String, width :int = 640, height :int = 480 ) :void
		{
			var path :String = PLAYER_PATH.replace("[ID]", videoId);
			
			_videoId     = videoId;
			_videoWidth  = width;
			_videoHeight = height;
			
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.INIT,            _loaderInit);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _loaderError);
			_loader.load(new URLRequest(path));
		}
		
		
		public function play ( ) :void
		{
			if (_player) _player.playVideo();
		}
		public function pause ( ) :void
		{
			if (_player) _player.pauseVideo();
		}
		public function stop ( ) :void
		{
			if (_player) 
			{
				_player.seekTo(0);
				_player.stopVideo();
			}
		}
		
		
		/// LOADER - INIT
		private function _loaderInit ( evt :Event ) :void 
		{
			_loader.contentLoaderInfo.removeEventListener(Event.INIT,            _loaderInit);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, _loaderError);
			
			_player = _loader.contentLoaderInfo.loader.content;
			_player.addEventListener("onReady", _onReady);
			
			Debug.log(this, "_loaderInit", _player, _player.width, _player.height);
		}
		/// LOADER - ERROR
		private function _loaderError ( evt :IOErrorEvent ) :void 
		{
			_loader.contentLoaderInfo.removeEventListener(Event.INIT,            _loaderInit);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, _loaderError);
		}
		
		private function _onReady ( evt :Event ) :void 
		{
			_player.removeEventListener("onReady", _onReady);
			_player.setSize(_videoWidth, _videoHeight);
			
			addChild(_player);
		}
		
	}

}