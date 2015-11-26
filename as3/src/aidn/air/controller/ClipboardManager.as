package aidn.air.controller 
{
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.display.BitmapData;
	import flash.filesystem.File;
	
	public class ClipboardManager 
	{
		private var _clipboard :Clipboard;
		
		public function ClipboardManager (clipboard :Clipboard) 
		{
			_clipboard = clipboard;
		}
		
		
		public function getText ( ) :String
		{
			return _clipboard.getData(ClipboardFormats.TEXT_FORMAT) as String;
		}
		public function getURL ( ) :String
		{
			return _clipboard.getData(ClipboardFormats.URL_FORMAT) as String;
		}
		public function getFileList ( ) :/*File*/Array
		{
			return _clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
		}
		public function getBitmapData ( ) :BitmapData
		{
			return _clipboard.getData(ClipboardFormats.BITMAP_FORMAT) as BitmapData;
		}
		
		public function getData ( format :String, transferMode :String = "originalPreferred" ) :Object
		{
			return _clipboard.getData(format, transferMode);
		}
		public function get formats ( ) :Array
		{
			return _clipboard.formats;
		}
		public function hasFormat ( format :String ) :Boolean
		{
			return _clipboard.hasFormat(format);
		}
		
		public function get clipboard ( ) :Clipboard  { return _clipboard; }
		public function set clipboard (value :Clipboard ) :void { _clipboard = value; }
	}
}