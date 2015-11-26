package aidn.main.commands 
{
	import aidn.main.commands.base.CommandBase;
	import aidn.main.constant.ErrorCode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	public class UncompressCommand extends CommandBase
	{
		private var _urlloader :URLLoader;
		private var _urlReq    :URLRequest;
		
		private var _ba   :ByteArray;
		private var _data :String;
		
		public function UncompressCommand ( url :* ) 
		{
			if (url is URLRequest)	_urlReq = url;
			else					_urlReq = new URLRequest(url);
		}
		
		// ------------------------------------------------------------------- override
		
		override public function execute ( ) :void 
		{
			if (! _urlloader) _urlloader = new URLLoader();
			_cancel();
			
			_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			
			_addEvents();
			_urlloader.load(_urlReq);
		}
		override public function cancel ( ) :void 
		{
			_cancel();
		}
		
		// ------------------------------------------------------------------- private
		
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
		
		public function get data ( ) :String
		{
			if (! _data && _urlloader.data)
			{
				_ba = _urlloader.data as ByteArray;
				_ba.uncompress();
				
				// _data = _ba.readUTF();
				_data = _ba.readUTFBytes(_ba.length);
			}
			
			return _data;
		}
	}
}