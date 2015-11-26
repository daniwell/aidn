package aidn.alternativa3d.controller 
{
	import aidn.alternativa3d.model.SliceData;
	import alternativa.engine3d.animation.AnimationClip;
	import alternativa.engine3d.animation.AnimationController;
	import alternativa.engine3d.animation.AnimationSwitcher;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.loaders.ParserCollada;
	import alternativa.engine3d.loaders.ParserMaterial;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.materials.VertexLightTextureMaterial;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.objects.Surface;
	import alternativa.engine3d.resources.BitmapTextureResource;
	import flash.display.Bitmap;
	import flash.display.Stage3D;
	import mx.core.BitmapAsset;
	
	///
	///
	/// 不要 (-> ParseManager)
	///
	///
	
	public class ColladaManager extends ModelManager
	{
		private var _stage3D  :Stage3D;
		
		private var _animationController :AnimationController;
		private var _animationSwitcher   :AnimationSwitcher;
		private var _animationClips      :/*AnimationClip*/Array = [];
		
		
		private var _nowAnimationId :int;
		
		private var _textureResources :/*BitmapTextureResource*/Array = [];
		
		
		public function ColladaManager ( stage3D :Stage3D, parent :Object3D = null ) 
		{
			_stage3D = stage3D;
			
			var model :Object3D = new Object3D();
			super(model, null, parent);
		}
		
		// ------------------------------------------------------------------- public
		
		public function init ( dae :*, texture :*, isLightMaterial :Boolean = false ) :Vector.<AnimationClip>
		{
			if (! (dae is XML)) dae = new XML(dae);
			
			
			// Parser
			var parser :ParserCollada = new ParserCollada();
			parser.parse(dae);
			
			// Texture
			addTexture(texture, 0);
			var txtRes :BitmapTextureResource = _textureResources[0];
			
			if (! isLightMaterial)	_material = new TextureMaterial(txtRes);
			else					_material = new VertexLightTextureMaterial(txtRes);
			
			_material.alphaThreshold = 1;
			
			var boxs :/*BoundBox*/Array = [];
			
			// Mesh
			for each (var obj :Object3D in parser.objects)
			{
				var mesh :Mesh = obj as Mesh;
				if (mesh)
				{
					for (var i :int = 0; i < mesh.numSurfaces; i ++)
					{
						var surface  :Surface = mesh.getSurface(i);
						var pm :ParserMaterial = surface.material as ParserMaterial;
						
						if (pm && pm.textures["diffuse"]) surface.material = _material;
					}
					
					// mesh.setMaterialToAllSurfaces(_material);
					_model.addChild(obj);
					
					// mesh.calculateBoundBox();
					// boxs.push(mesh.boundBox);
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
		 * @param	dae
		 * @param	slices
		 */
		public function addAnimation ( dae :*, slices :/*SliceData*/Array ) :void
		{
			if (! slices) return;
			
			var animationClip :AnimationClip;
			
			if (! (dae is AnimationClip))
			{
				if (! (dae is XML)) dae = new XML(dae);
				animationClip = ParserCollada.parseAnimation(dae);
			}
			else
			{
				animationClip = AnimationClip(dae);
			}
			
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
		 * @param	texture
		 * @param	id
		 */
		public function addTexture ( texture :*, id :int ) :void
		{
			if (texture is Bitmap || texture is BitmapAsset) texture = texture.bitmapData;
			
			var texResource :BitmapTextureResource = new BitmapTextureResource(texture);
			texResource.upload(_stage3D.context3D);
			
			_textureResources[id] = texResource;
		}
		
		/**
		 * アニメーションの切り替え。
		 * @param	id
		 * @param	speed	再生速度。
		 * @param	loop	ループするかどうか。
		 */
		public function changeAnimation ( id :int, speed :Number = 1.0, loop :Boolean = true, morphingTime :Number = 0.2, startTime :Number = -1 ) :void
		{
			if (_nowAnimationId == id)
			{
				if (_animationSwitcher.speed == speed && _animationClips[_nowAnimationId].loop == loop) return;
			}
			_nowAnimationId = id;
			
			_animationClips[id].loop  = loop;
			if (0 <= startTime) _animationClips[id].time = startTime;
			_animationSwitcher.activate(_animationClips[id], morphingTime);
			_animationSwitcher.speed = speed;
		}
		
		/**
		 * テクスチャーの切り替え。
		 * @param	id
		 */
		public function changeMaterial ( id :int ) :void
		{
			_material.diffuseMap = _textureResources[id];
		}
		
		
		/*
		public function setBounds ( ) :void
		{
			BoundBox().intersects;
		}
		//*/
		
	}
}