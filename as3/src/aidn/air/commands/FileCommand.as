package aidn.air.commands 
{
	import aidn.main.commands.base.CommandBase;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.OutputProgressEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	public class FileCommand extends CommandBase
	{
		private var _fs       :FileStream;
		
		private var _file     :File;
		private var _fileMode :String;
		private var _async    :Boolean;
		
		
		public function FileCommand(file :File, fileMode :String = "read", async :Boolean = true) 
		{
			_file     = file;
			_fileMode = fileMode;
			_async    = async;
		}
		
		// ------------------------------------------------------------------- override
		
		override public function execute():void 
		{
			if (! _fs) _fs = new FileStream();
			_cancel();
			
			
			if (_async)
			{
				_addEvents();
				_fs.openAsync(_file, _fileMode);
			}
			else
			{
				_fs.open(_file, _fileMode);
				_dispatchComplete();
			}
		}
		
		// ------------------------------------------------------------------- public
		
		/* read ByteArray */
		public function readByteArray ( ) :ByteArray
		{
			var ba :ByteArray = new ByteArray();
			_fs.readBytes(ba, 0, _fs.bytesAvailable);
			return ba;
		}
		/* read String */
		public function readString ( charSet :String = "utf-8" ) :String
		{
			return _fs.readMultiByte(_fs.bytesAvailable, charSet);
		}
		
		/* write ByteArray */
		public function writeByteArray ( bytes :ByteArray ) :void
		{
			_fs.writeBytes(bytes, 0, _fs.bytesAvailable);
		}
		/* write String */
		public function writeString ( value :String, charSet :String = "utf-8" ) :void
		{
			_fs.writeMultiByte(value, charSet);
		}
		
		
		// ------------------------------------------------------------------- private
		
		private function _addEvents ( ) :void
		{
			_fs.addEventListener(Event.COMPLETE,         _complete);
			_fs.addEventListener(ProgressEvent.PROGRESS, _progress);
			_fs.addEventListener(IOErrorEvent.IO_ERROR,  _ioError);
			_fs.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, _progressOutput);
		}
		private function _removeEvents ( ) :void
		{
			_fs.removeEventListener(Event.COMPLETE,         _complete);
			_fs.removeEventListener(ProgressEvent.PROGRESS, _progress);
			_fs.removeEventListener(IOErrorEvent.IO_ERROR,  _ioError);
			_fs.removeEventListener(OutputProgressEvent.OUTPUT_PROGRESS, _progressOutput);
		}
		
		private function _cancel ( ) :void
		{
			_removeEvents();
			try { _fs.close(); } catch ( e :* ) { };
		}
		
		// ------------------------------------------------------------------- Event
		
		private function _complete ( evt :Event ) :void 
		{
			_removeEvents();
			_dispatchComplete();
		}
		private function _progress ( evt :ProgressEvent ) :void 
		{
			_dispatchProgress(evt.bytesLoaded / evt.bytesTotal);
		}
		private function _ioError ( evt :IOErrorEvent ) :void 
		{
			_removeEvents();
			_dispatchFailed();
		}
		
		private function _progressOutput ( evt :OutputProgressEvent ) :void 
		{
			_dispatchProgress(1 - evt.bytesPending / evt.bytesTotal);
		}
		
		
		// ------------------------------------------------------------------- getter
		/* FileStream */
		public function get filestream ( ) :FileStream { return _fs; }
		
	}
}