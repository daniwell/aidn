package aidn.main.commands 
{
	import aidn.main.commands.base.CommandBase;
	import aidn.main.constant.ErrorCode;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	
	public class LoaderCommand extends CommandBase
	{
		private var _loader :Loader;
		
		private var _urlReq  :URLRequest;
		private var _context :LoaderContext;
		
		private var _data :ByteArray;
		
		public function LoaderCommand ( url :*, context :LoaderContext = null ) 
		{
			if (url is ByteArray)		_data   = url;
			else if (url is URLRequest)	_urlReq = url;
			else						_urlReq = new URLRequest(url);
			_context = context;
		}
		
		// ------------------------------------------------------------------- override
		
		override public function execute ( ) :void 
		{
			if (! _loader) _loader = new Loader();
			_cancel();
			
			_addEvents();
			
			if (_data)
				_loader.loadBytes(_data);
			else
				_loader.load(_urlReq, _context);
		}
		override public function cancel ( ) :void 
		{
			_cancel();
		}
		
		// ------------------------------------------------------------------- private
		
		private function _addEvents ( ) :void
		{
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,         _complete);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, _progress);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,  _ioError);
		}
		private function _removeEvents ( ) :void
		{
			if (! _loader) return;
			
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,         _complete);
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, _progress);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,  _ioError);
		}
		private function _cancel ( ) :void
		{
			_removeEvents();
			try { _loader.close(); } catch ( e :* ) { };
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
		
		public function get loader ( ) :Loader { return _loader; }
		
	}
}