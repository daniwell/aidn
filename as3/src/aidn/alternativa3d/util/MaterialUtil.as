package aidn.alternativa3d.util 
{
	import aidn.main.util.Linkage;
	import alternativa.engine3d.materials.StandardMaterial;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.resources.BitmapTextureResource;
	
	public class MaterialUtil 
	{
		private static var _list :Object = {};
		
		/// SET
		public static function setMaterial ( key :String, material :TextureMaterial ) :TextureMaterial
		{
			_list[key] = material;
			return material;
		}
		/// GET
		public static function getMaterial ( key :String ) :TextureMaterial
		{
			return _list[key];
		}
		/// HAS
		public static function hasMaterial ( key :String ) :Boolean
		{
			return (_list[key] != null);
		}
		
		
		// ------------------------------------------------------------------- 
		
		
		/// Texture Name List を取得 (Collada 用)
		public static function getTextureNameList ( data :XML ) :/*String*/Array
		{
			var list :Array = [];
			var ns :Namespace = new Namespace("http://www.collada.org/2005/11/COLLADASchema");
			default xml namespace = ns;
			
			for each (var image :XML in data.library_images.image)
			{
				var path :String = image.init_from;
				var a :Array = path.split("/");
				path = a[a.length - 1];
				list.push(path);
			}
			return list;
		}
		
		/// ParseManager の init 時に使用する用の Material Object を取得
		public static function getMaterialObject ( namelist :/*String*/Array ) :Object
		{
			var obj :Object = { };
			
			for (var j :int = 0; j < namelist.length; j ++)
			{
				var linkage :String = convertNameToLinkage(namelist[j]);
				if (! ResourceUtil.hasResource(linkage)) ResourceUtil.setResource(linkage, new BitmapTextureResource(Linkage.getBitmapData(linkage)));
				
				var tm  :TextureMaterial = new  TextureMaterial(ResourceUtil.getResource(linkage));
				tm.alphaThreshold = 1.0;
				obj[namelist[j]] = tm;
			}
			return obj;
		}
		
		/// テクスチャ名をリンケージ名に変換
		public static function convertNameToLinkage ( name :String ) :String
		{
			return name.replace(/^[0-9]+/, "").split("-").join("_");
		}
		
	}
}