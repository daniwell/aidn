package aidn.alternativa3d.view 
{
	import aidn.main.core.StageReference;
	import aidn.main.util.Debug;
	import aidn.main.util.key.KeyUtil;
	import alternativa.engine3d.controllers.SimpleObjectController;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.lights.AmbientLight;
	import alternativa.engine3d.lights.DirectionalLight;
	import alternativa.engine3d.lights.OmniLight;
	import alternativa.engine3d.materials.StandardMaterial;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.materials.VertexLightTextureMaterial;
	import alternativa.engine3d.objects.SkyBox;
	import alternativa.engine3d.resources.BitmapTextureResource;
	import alternativa.engine3d.shadows.DirectionalLightShadow;
	import alternativa.engine3d.shadows.OmniLightShadow;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	
	public class AlternativaTestBase extends AlternativaBase
	{
		private var _aLight :AmbientLight;
		private var _oLight :OmniLight;
		private var _dLight :DirectionalLight;
		
		protected var _controller :SimpleObjectController;
		
		public function AlternativaTestBase ( initStart :Boolean = true ) 
		{
			KeyUtil.init(StageReference.stage, _keyDown, _keyUp);
			if (initStart) init();
		}
		
		override protected function _ready ( ) :void 
		{
			super._ready();
			
			KeyUtil.start();
		}
		override protected function _render ( ) :void 
		{
			if (_controller) _controller.update();
			super._render();
		}
		
		public function initCameraController ( speed :Number = 250, speedMultiplier :Number = 3, mouseSensitivity :Number = 0.4 ) :void
		{
			_controller = new SimpleObjectController(StageReference.stage, camera, speed, speedMultiplier, mouseSensitivity);
		}
		
		
		public function addAmbientLight ( col :int = 0xffffff, intensity :Number = 0.5 ) :AmbientLight
		{
			//　環境光のライトを配置
			_aLight = new AmbientLight(col);
			_aLight.intensity = intensity;
			scene.addChild(_aLight);
			
			return _aLight;
		}
		public function addOmniLight ( begin :Number = 1000, end :Number = 10000, x :Number = 0, y :Number = 0, z :Number = 0, col :int = 0xffffff ) :OmniLight
		{
			//　全方向のライトを配置
			_oLight = new OmniLight(col, begin, end);
			_oLight.x = x;
			_oLight.y = y;
			_oLight.z = z;
			scene.addChild(_oLight);
			
			return _oLight;
		}
		public function addDirectionalLight ( x :Number = 0, y :Number = 0, z :Number = 0, lx :Number = 0, ly :Number = 0, lz :Number = 0, col :int = 0xffffff ) :DirectionalLight
		{
			// 指向性のライトを配置
			_dLight = new DirectionalLight(col);
			_dLight.x = x;
			_dLight.y = y;
			_dLight.z = z;
			_dLight.lookAt(lx, ly, lz);
			scene.addChild(_dLight);
			
			return _dLight;
		}
		
		public function addDirectionalShadow ( objs :/*Object3D*/Array ) :void
		{
			if (! _dLight) return;
			
			var shadow :DirectionalLightShadow = new DirectionalLightShadow(100, 100, -500, 500, 512, 2);
			for (var i :int = 0, l :int = objs.length; i < l; i ++) if (objs[i] is Object3D) shadow.addCaster(objs[i]);
			_dLight.useShadow = true;
			_dLight.shadow = shadow;
		}
		public function addOmniShadow ( objs :/*Object3D*/Array ) :void
		{
			if (! _oLight) return;
			
			var shadow :OmniLightShadow = new OmniLightShadow(512, 1);
			for (var i :int = 0, l :int = objs.length; i < l; i ++) if (objs[i] is Object3D) shadow.addCaster(objs[i]);
			_oLight.useShadow = true;
			_oLight.shadow = shadow;
		}
		
		
		
		/// get TextureMaterial from BitmapData
		protected function _getMaterial ( bmd :BitmapData, alphaThreshold :Number = 0 ) :TextureMaterial
		{
			var m :TextureMaterial = new TextureMaterial(new BitmapTextureResource(bmd));
			m.alphaThreshold = alphaThreshold;
			return m;
		}
		/// get VertexLightTextureMaterial from BitmapData
		protected function _getLightMaterial ( bmd :BitmapData, alphaThreshold :Number = 0 ) :TextureMaterial
		{
			var m :VertexLightTextureMaterial = new VertexLightTextureMaterial(new BitmapTextureResource(bmd));
			m.alphaThreshold = alphaThreshold;
			return m;
		}
		/// get StandardMaterial from BitmapData
		protected function _getStandardMaterial ( bmd :BitmapData, alphaThreshold :Number = 0 ) :TextureMaterial
		{
			var m :StandardMaterial = new StandardMaterial(new BitmapTextureResource(bmd), new BitmapTextureResource(new BitmapData(16, 16, false, 0xffffff)));
			m.alphaThreshold = alphaThreshold;
			return m;
		}
		
		
		protected function _keyDown ( evt :KeyboardEvent ) :void
		{
			switch ( evt.keyCode )
			{
				case Keyboard.P:
					var s :String = "[Camera]";
					s += "\n'x':" + camera.x + ", 'y':" + camera.y + ", 'z':" + camera.z;
					s += ",\n'rotX':" + camera.rotationX + ", 'rotY':" + camera.rotationY + ", 'rotZ':" + camera.rotationZ;
					Debug.log(s);
					break;
			}
		}
		
		protected function _keyUp ( evt :KeyboardEvent ) :void { }
	}
}