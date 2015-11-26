package aidn.alternativa3d.util 
{
	import alternativa.engine3d.resources.TextureResource;
	
	public class ResourceUtil 
	{
		private static var _list :Object = {};
		
		/// SET
		public static function setResource ( key :String, resource :TextureResource ) :TextureResource
		{
			_list[key] = resource;
			return resource;
		}
		/// GET
		public static function getResource ( key :String ) :TextureResource
		{
			return _list[key];
		}
		/// HAS
		public static function hasResource ( key :String ) :Boolean
		{
			return (_list[key] != null);
		}
		/// DISPOSE
		public static function dispose ( key :String ) :void
		{
			TextureResource(_list[key]).dispose();
		}
	}
}