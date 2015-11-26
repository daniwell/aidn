package aidn.api.twitter.commands 
{
	import aidn.main.commands.LoaderCommand;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	public class TwitterIconLoadCommand extends LoaderCommand
	{
		private const PATH :String = "http://aidn.jp/cgi/api/util/getcontents.php";
		
		private var _bitmap     :Bitmap;
		private var _bitmapData :BitmapData;
		
		public function TwitterIconLoadCommand ( url :String ) 
		{
			var v :URLVariables = new URLVariables();
			v.path = url;
			
			var u :URLRequest = new URLRequest(PATH);
			u.method = URLRequestMethod.POST;
			u.data   = v;
			
			super(u);
		}
		
		override protected function _complete(evt:Event):void 
		{
			_bitmap = loader.content as Bitmap;
			_bitmapData = _bitmap.bitmapData;
			
			super._complete(evt);
		}
		
		public function get bitmap     ( ) :Bitmap     { return _bitmap; }
		public function get bitmapData ( ) :BitmapData { return _bitmapData; }
	}
}