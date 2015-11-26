package aidn.android.controller.ad 
{
	import flash.display.Stage;
	import flash.events.LocationChangeEvent;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.net.navigateToURL;
	
	public class AdSenseManager 
	{
		private var _webView :StageWebView;
		
		private var _isShowing :Boolean = false;
		
		private var _url :String;
		
		private var _x      :int = 0;
		private var _y      :int = 0;
		private var _width  :int = 0;
		private var _height :int = 0;
		
		private var _rect   :Rectangle = new Rectangle();
		
		
		public function AdSenseManager ( ) 
		{
			_webView = new StageWebView();
			_webView.addEventListener(LocationChangeEvent.LOCATION_CHANGE, _locationChange);
		}
		
		// ------------------------------------------------------------------- public
		
		public function init ( stage :Stage ) :void
		{
			_webView.stage = stage;
			_webView.viewPort;
		}
		
		public function show ( ) :void
		{
			_isShowing = true;
			_update();
		}
		public function hide ( ) :void
		{
			_isShowing = false;
			_update();
		}
		
		public function loadURL ( url :String ) :void
		{
			_url = url;
			_webView.loadURL(url);
		}
		
		// ------------------------------------------------------------------- private
		
		private function _update ( ) :void
		{
			if (_isShowing)
			{
				_rect.x = _x;
				_rect.y = _y;
				_rect.width  = _width;
				_rect.height = _height;
				
				_webView.viewPort = _rect;
			}
			else
			{
				/*
				_rect.width  = 0;
				_rect.height = 0;
				_webView.viewPort = _rect;
				*/
				_webView.viewPort = null;
			}
		}
		
		
		// ------------------------------------------------------------------- Event
		
		private function _locationChange ( evt :LocationChangeEvent ) :void 
		{
			if (_url != evt.location)
			{
				evt.preventDefault();
				navigateToURL(evt.location);
				
				// _webView.reload();
			}
		}
		
		// ------------------------------------------------------------------- getter & setter
		
		
		/// WebView をサポートしているかどうか
		public static function get isSupported ( ) :Boolean { return StageWebView.isSupported; }
		
		
		public function get x      ( ) :int { return _x; }
		public function get y      ( ) :int { return _y; }
		public function get width  ( ) :int { return _width; }
		public function get height ( ) :int { return _height; }
		
		
		public function set x ( value :int ) :void 
		{
			_x = value;
			_update();
		}
		public function set y ( value :int ) :void 
		{
			_y = value;
			_update();
		}
		public function set width ( value :int ) :void 
		{
			_width = value;
			_update();
		}
		public function set height ( value :int ) :void 
		{
			_height = value;
			_update();
		}
	}
}