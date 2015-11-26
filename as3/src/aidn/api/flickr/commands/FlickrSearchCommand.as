package aidn.api.flickr.commands 
{
	import aidn.api.flickr.model.FlickrSearchList;
	import aidn.api.flickr.param.FlickrSearchParam;
	import aidn.main.commands.URLLoaderCommand;
	import com.adobe.serialization.json.JSON;
	import flash.events.Event;
	import flash.net.URLLoaderDataFormat;
	
	public class FlickrSearchCommand extends URLLoaderCommand
	{
		private const BASE_PATH :String = "http://api.flickr.com/services/rest/?method=flickr.photos.search";
		
		private var _inited :Boolean;
		
		private var _isOk     :Boolean;
		private var _dataList :FlickrSearchList;
		
		
		public function FlickrSearchCommand ( param :FlickrSearchParam ) 
		{
			var path :String = BASE_PATH;
			
			for (var key :String in param)
			{
				path += "&" + key + "=" + param[key];
			}
			
			_inited = false;
			
			_dataList = null;
			super(path, URLLoaderDataFormat.TEXT);
		}
		
		override protected function _complete ( evt :Event ) :void 
		{
			if (! _inited) _init();
			
			if (! _isOk)
			{
				evt.stopImmediatePropagation();
				super._dispatchFailed();
				return;
			}
			
			super._complete(evt);
		}
		
		/// 取得したデータ
		public function get dataList ( ) :FlickrSearchList 
		{
			if (! _inited) _init();
			return _dataList;
		}
		/// 正常に取得できたかどうか
		public function get isOk ( ) :Boolean 
		{
			if (! _inited) _init();
			return _isOk;
		}
		
		
		private function _init ( ) :void
		{
			_inited = true;
			
			var d :* = JSON.decode(data);
			
			_isOk     = (d.stat == "ok");
			_dataList = new FlickrSearchList(d.photos);
		}
		
		
	}
}