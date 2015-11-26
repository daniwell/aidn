package aidn.alternativa3d.objects 
{
	import alternativa.engine3d.animation.AnimationClip;
	import alternativa.engine3d.animation.AnimationController;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.loaders.ParserCollada;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.materials.VertexLightTextureMaterial;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.resources.BitmapTextureResource;
	
	import flash.display.Bitmap;
	import flash.display.Stage3D;
	import mx.core.BitmapAsset;
	
	///
	///
	/// 不要 (-> ParseManager)
	///
	///
	
	public class ColladaModel extends Object3D
	{
		private var _stage3D  :Stage3D;
		private var _material :TextureMaterial;
		
		private var _animationController :AnimationController;
		private var _animationClips      :/*AnimationClip*/Array = [];
		
		private var _textureResources :/*BitmapTextureResource*/Array = [];
		
		
		public function ColladaModel ( stage3D :Stage3D, parent :Object3D = null ) 
		{
			_stage3D = stage3D;
			if (parent) parent.addChild(this);
		}
		
		public function init ( dae :*, texture :*, isLightMaterial :Boolean = false ) :void
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
			
			
			
			var boxs :/*BoundBox*/Array = [];
			
			// Mesh
			for each (var obj :Object3D in parser.objects)
			{
				var mesh :Mesh = obj as Mesh;
				if (mesh)
				{
					mesh.setMaterialToAllSurfaces(_material);
					addChild(obj);
					
					// mesh.calculateBoundBox();
					// boxs.push(mesh.boundBox);
				}
			}
			
			
			
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
		 * @param	id
		 */
		public function addAnimation ( dae :*, id :int ) :void
		{
			if (! (dae is XML)) dae = new XML(dae);
			
			// Animation Clip
			var animationClip :AnimationClip = ParserCollada.parseAnimation(dae);
			animationClip.attach(this, true);
			
			_animationClips[id] = animationClip;
			
			
			// Animation Controller
			if (! _animationController)
			{
				_animationController      =  new AnimationController();
				_animationController.root = animationClip;
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
		public function changeAnimation ( id :int, speed :Number = 1.0, loop :Boolean = true ) :void
		{
			_animationClips[id].speed = speed;
			_animationClips[id].loop  = loop;
			_animationController.root = _animationClips[id];
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
		
		public function get scale ( ) :Number { return scaleX; };
		public function set scale ( value :Number ) :void { scaleX = scaleY = scaleZ = value; };
		
	}
}