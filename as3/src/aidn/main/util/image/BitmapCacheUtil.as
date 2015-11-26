package aidn.main.util.image 
{
	import flash.display.BitmapData;
	
	public class BitmapCacheUtil
	{
		private static var _cache :Object;
		
		public static function init ( ) :void
		{
			_cache = new Object();
		}
		
		public static function hasImage ( path :String ) :Boolean
		{
			if (_cache[path] is BitmapData) return true;
			return false;
		}
		public static function getImage ( path :String ) :BitmapData
		{
			return _cache[path];
		}
		public static function addImage ( path :String, bitmapdata :BitmapData ) :void
		{
			_cache[path] = bitmapdata;
		}
		public static function removeImage ( path :String ) :void
		{
			if (_cache[path] is BitmapData)
			{
				_cache[path].dispose();
				_cache[path] = null;
				delete _cache[path];
			}
		}
		
		
		/**
		 * path と size から一意な Hash の生成
		 * @param	path
		 * @param	size
		 */
		public static function getHash ( path :String, size :int ) :String
		{
			if (size < 0) return path;
			return path + "_" + size;
		}
		
	}
}