package aidn.alternativa3d.util 
{
	import aidn.main.util.Debug;
	import aidn.main.util.Linkage;
	import alternativa.engine3d.materials.StandardMaterial;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.resources.BitmapTextureResource;
	
	///
	///
	/// 不要
	///
	///
	
	public class ColladaUtil 
	{
		/// 
		public static function getTexturePathList ( data :XML ) :/*String*/Array
		{
			var list :Array = [];
			
			var ns :Namespace = new Namespace("http://www.collada.org/2005/11/COLLADASchema");
			default xml namespace = ns;
			
			for each (var image :XML in data.library_images.image)
			{
				/// Debug.log(image.init_from);
				var path :String = image.init_from;
				
				var a :Array = path.split("/");
				path = a[a.length - 1];
				
				list.push(path);
			}
			return list;
		}
		
		/// ParseManager の init 時に使用する用 (XML)
		public static function getMaterialObjectFromXML ( data :XML ) :Object
		{
			var list :/*String*/Array = getTexturePathList(data);
			
			var obj :Object = { };
			
			/// Debug.log("[ColladaUtil]", list);
			
			for (var j :int = 0; j < list.length; j ++)
			{
				var linkage :String = list[j].replace(/^[0-9]+/, "");
				/// Debug.log("[ColladaUtil]", "hasDefinition", linkage, Linkage.hasDefinition(linkage));
				if (Linkage.hasDefinition(linkage))
					obj[list[j]] = new TextureMaterial(new BitmapTextureResource(Linkage.getBitmapData(linkage)));
			}
			return obj;
		}
		
		/// ParseManager の init 時に使用する用 (String)
		public static function getMaterialObjectFromString ( diffuse :/*String*/Array, normal :/*String*/Array = null  ) :Object
		{
			var list :Array = diffuse;
			
			var obj :Object = { };
			
			for (var j :int = 0; j < diffuse.length; j ++)
			{
				var linkageDiffuse :String = diffuse[j].replace(/^[0-9]+/, "");
				
				if (! normal) obj[diffuse[j]] = new  TextureMaterial(new BitmapTextureResource(Linkage.getBitmapData(linkageDiffuse)));
				else
				{
					var linkageNormal :String = normal[j].replace(/^[0-9]+/, "");
					obj[diffuse[j]] = new StandardMaterial(new BitmapTextureResource(Linkage.getBitmapData(linkageDiffuse)), new BitmapTextureResource(Linkage.getBitmapData(linkageNormal)));	
				}
			}
			return obj;
		}
		
	}
}