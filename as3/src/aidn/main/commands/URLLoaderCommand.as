package aidn.main.commands 
{
	import aidn.main.commands.base.CommandBase;
	import aidn.main.constant.ErrorCode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class URLLoaderCommand extends CommandBase
	{
		protected var _urlloader :URLLoader;
		
		private var _urlReq :URLRequest;
		
		private var _dataFormat :String;
		
		public function URLLoaderCommand ( url :*, dataFormat :String = "text" ) 
		{
			_dataFormat = dataFormat;
			if (url is URLRequest)	_urlReq = url;
			else					_urlReq = new URLRequest(url);
		}
		
		override public function execute ( ) :void 
		{
			if (! _urlloader) _urlloader = new URLLoader();
			_cancel();
			
			_addEvents();
			_urlloader.dataFormat = _dataFormat;
			_urlloader.load(_urlReq);
		}
		override public function cancel ( ) :void 
		{
			_cancel();
		}
		
		private function _addEvents ( ) :void
		{
			_urlloader.addEventListener(Event.COMPLETE,         _complete);
			_urlloader.addEventListener(ProgressEvent.PROGRESS, _progress);
			_urlloader.addEventListener(IOErrorEvent.IO_ERROR,  _ioError);
		}
		private function _removeEvents ( ) :void
		{
			if (! _urlloader) return;
			
			_urlloader.removeEventListener(Event.COMPLETE,         _complete);
			_urlloader.removeEventListener(ProgressEvent.PROGRESS, _progress);
			_urlloader.removeEventListener(IOErrorEvent.IO_ERROR,  _ioError);
		}
		private function _cancel ( ) :void
		{
			_removeEvents();
			try { _urlloader.close(); } catch ( e :* ) { };
		}
		
		// ------------------------------------------------------------------- Event
		/* COMPLETE */
		protected function _complete ( evt :Event ) :void 
		{
			_removeEvents();
			_dispatchComplete();
		}
		/* PROGRESS */
		protected function _progress ( evt :ProgressEvent ) :void 
		{
			_dispatchProgress(evt.bytesLoaded / evt.bytesTotal);
		}
		/* IO ERROR */
		protected function _ioError ( evt :IOErrorEvent ) :void 
		{
			_removeEvents();
			_dispatchFailed(ErrorCode.IO_ERROR);
		}
		
		// ------------------------------------------------------------------- getter & setter
		
		public function get data       ( ) :*      { return _urlloader.data; }
		public function get dataFormat ( ) :String { return _urlloader.dataFormat; }
	}
}