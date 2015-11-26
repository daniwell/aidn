package aidn.alternativa3d.controller 
{
	import aidn.alternativa3d.model.SliceData;
	import aidn.main.util.Debug;
	import alternativa.engine3d.animation.AnimationClip;
	import alternativa.engine3d.animation.AnimationController;
	import alternativa.engine3d.animation.AnimationSwitcher;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.loaders.Parser;
	import alternativa.engine3d.loaders.ParserA3D;
	import alternativa.engine3d.loaders.ParserCollada;
	import alternativa.engine3d.loaders.ParserMaterial;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.materials.VertexLightTextureMaterial;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.objects.Surface;
	import alternativa.engine3d.resources.BitmapTextureResource;
	import alternativa.engine3d.resources.ExternalTextureResource;
	import alternativa.engine3d.resources.TextureResource;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Stage3D;
	import flash.utils.ByteArray;
	import mx.core.BitmapAsset;
	
	public class ParseManager extends ModelManager
	{
		private var _stage3D  :Stage3D;
		
		private var _animationController :AnimationController;
		private var _animationSwitcher   :AnimationSwitcher;
		private var _animationClips      :/*AnimationClip*/Array = [];
		
		private var _nowAnimationId :int;
		
		private var _resources :Array = [];
		private var _materials :Object;
		
		
		public function ParseManager ( stage3D :Stage3D, parent :Object3D = null ) 
		{
			_stage3D = stage3D;
			
			var model :Object3D = new Object3D();
			super(model, null, parent);
		}
		
		// ------------------------------------------------------------------- public
		
		/**
		 * 初期化
		 * @param	data		Collada(XML, String) or A3D(ByteArray)
		 * @param	material	Object or Material
		 * @return
		 */
		public function init ( data :*, material :* ) :Vector.<AnimationClip>
		{
			// Parser
			var parser :Parser;
			
			if (data is String || data is XML)
			{
				parser = new ParserCollada();
				ParserCollada(parser).parse(XML(data));
			}
			else if (data is ByteArray)
			{
				parser = new ParserA3D();
				ParserA3D(parser).parse(data);
			}
			else
			{
				Debug.log("data type error");
				return null;
			}
			
			if (material is TextureMaterial)	_material  = material;
			else								_materials = material;
			
			// Mesh
			for each (var obj :Object3D in parser.objects)
			{
				if (! obj.parent && obj is Object3D) _model.addChild(obj);
				if (material == null) continue;
				
				var mesh :Mesh = obj as Mesh;
				if (mesh)
				{
					if (_material)
					{
						mesh.setMaterialToAllSurfaces(_material);
					}
					else
					{
						for (var i :int = 0; i < mesh.numSurfaces; i ++)
						{
							var surface  :Surface = mesh.getSurface(i);
							var pm :ParserMaterial = surface.material as ParserMaterial;
							if (pm != null)
							{
								var diffuse :ExternalTextureResource = pm.textures["diffuse"];
								
								if (diffuse)
								{
									var a :Array = diffuse.url.split("/");
									var keyDiffuse :String = a[a.length - 1];
									
									surface.material = _materials[keyDiffuse];
								}
								else
								{
									// 単色塗りの場合のテクスチャ生成
									var bmd :BitmapData;
									if (0 <= pm.colors["diffuse"])	bmd = new BitmapData(1, 1, true, pm.colors["diffuse"]);
									else							bmd = new BitmapData(1, 1, true, 0xff999999);
									surface.material = new VertexLightTextureMaterial(new BitmapTextureResource(bmd));
								}
							}
						}
					}
				}
			}
			
			return parser.animations;
		}
		
		/**
		 * アニメーションのアップデート。
		 */
		public function updataAnimation ( ) :void
		{
			_animationController.update();
		}
		
		/**
		 * アニメーションを追加。
		 * @param	data	AnimationClip or Collada(XML, String)
		 * @param	slices
		 */
		public function addAnimation ( data :*, slices :/*SliceData*/Array ) :void
		{
			var animationClip :AnimationClip;
			
			if (data is String || data is XML)
			{
				animationClip = ParserCollada.parseAnimation(XML(data));
			}
			else if (data is AnimationClip)
			{
				animationClip = data;
			}
			else
			{
				Debug.log("data type error");
				return;
			}
			
			// Animation Clip
			animationClip.attach(_model, true);
			
			// Animation Switcher
			if (! _animationSwitcher) _animationSwitcher = new AnimationSwitcher();
			
			var l :int = slices.length;
			for (var i :int = 0; i < l; i ++)
			{
				var s    :SliceData = slices[i];
				var clip :AnimationClip = animationClip.slice(s.start, s.end);
				/// clip.attach(_model, true);
				
				_animationClips[s.id] = clip;
				_animationSwitcher.addAnimation(clip);
			}
			
			/// Animation Controller
			if (! _animationController)
			{
				_animationController      =  new AnimationController();
				_animationController.root = _animationSwitcher;
			}
		}
		
		/**
		 * テクスチャーを追加。
		 * @param	id
		 * @param	diffuse		Object or Resouce(BitmapData, Bitmap, BitmapAsset)
		 * @param	upload		リソースを upload するかどうか
		 */
		public function addTexture ( id :int, diffuse :*, upload :Boolean = false ) :void
		{
			var obj :Object;
			var key :String;
			
			/// Diffuse
			if (diffuse is Bitmap || diffuse is BitmapAsset || diffuse is BitmapData || diffuse is TextureResource)
			{
				/// 1 resource
				_resources[id] = _getResource(diffuse, upload);
			}
			else
			{
				/// obj resources
				obj = { };
				for (key in diffuse) obj[key] = _getResource(diffuse[key], upload);
				_resources[id] = obj;
			}
		}
		
		
		private function _getResource ( data :*, upload :Boolean = false ) :TextureResource
		{
			var res :TextureResource;
			
			if (data is Bitmap || data is BitmapAsset) data = data.bitmapData;
			if (data is BitmapData)
			{
				res = new BitmapTextureResource(data);
				if (upload && ! res.isUploaded) res.upload(_stage3D.context3D);
			}
			else if (data is TextureResource)
			{
				res = data;
				if (upload && ! res.isUploaded) res.upload(_stage3D.context3D);
			}
			else res = null;
			
			return res;
		}
		
		
		/**
		 * アニメーションの切り替え。
		 * @param	id
		 * @param	speed		再生速度。
		 * @param	loop		ループするかどうか。
		 * @param	crossfade	アニメーションのクロスフェード時間。
		 * @param	startTime	開始時間。
		 */
		public function changeAnimation ( id :int, speed :Number = 1.0, loop :Boolean = true, crossfade :Number = 0.2, startTime :Number = -1 ) :void
		{
			if (_nowAnimationId == id)
			{
				if (_animationSwitcher.speed == speed && _animationClips[_nowAnimationId].loop == loop) return;
			}
			_nowAnimationId = id;
			
			_animationClips[id].loop  = loop;
			if (0 <= startTime) _animationClips[id].time = startTime;
			_animationSwitcher.activate(_animationClips[id], crossfade);
			_animationSwitcher.speed = speed;
		}
		
		/**
		 * テクスチャーの切り替え。
		 * @param	id
		 */
		public function changeMaterial ( id :int ) :void
		{
			var key :String;
			
			/// Diffuse
			if (_resources[id] is TextureResource)	_material.diffuseMap = _resources[id];
			else									for (key in _materials) _materials[key].diffuseMap = _resources[id][key];
		}
		
		
		/// Alpha
		override public function get alpha ( ) :Number 
		{
			if (_materials) for each (var m :TextureMaterial in _materials) return m.alpha;
			return _material.alpha;
		}
		/// Alpha
		override public function set alpha ( value :Number ) :void 
		{
			if (_materials)	for each (var m :TextureMaterial in _materials) m.alpha = value;
			else			_material.alpha = value;
		}
	}
}