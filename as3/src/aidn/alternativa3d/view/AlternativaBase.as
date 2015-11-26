package aidn.alternativa3d.view 
{
	import aidn.alternativa3d.core.CustomCamera3D;
	import aidn.alternativa3d.core.CustomObject3D;
	import aidn.alternativa3d.core.CustomView;
	import aidn.alternativa3d.events.AlternativaEvent;
	import aidn.main.core.StageReference;
	import alternativa.engine3d.core.Resource;
	import flash.display.Sprite;
	import flash.display.Stage3D;
	// import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	
	/** @eventType AlternativaEvent.READY */
	[Event(name="ready",  type="aidn.alternativa3d.events.AlternativaEvent")]
	/** @eventType AlternativaEvent.RENDER */
	[Event(name="render", type="aidn.alternativa3d.events.AlternativaEvent")]
	
	public class AlternativaBase extends Sprite
	{
		private var _stage3D :Stage3D;
		private var _scene   :CustomObject3D;
		private var _camera  :CustomCamera3D;
		
		
		/// FOR INIT
		private var __stageFit     :Boolean;
		private var __width        :int;
		private var __height       :int;
		private var __nearClipping :Number;
		private var __farClipping  :Number;
		private var __showDiagram  :Boolean;
		
		
		public function AlternativaBase ( ) 
		{
			
		}
		
		// ------------------------------------------------------------------- puiblic
		
		/** 初期化 */
		public function init ( stageFit :Boolean = true, width :int = -1, height: int = -1,
							   nearClipping :Number = 1, farClipping :Number = 10000, showDiagram :Boolean = false ) :void
		{
			__stageFit = stageFit;
			__width = width; __height = height;
			__nearClipping = nearClipping; __farClipping = farClipping;
			__showDiagram = showDiagram;
			
			
			_stage3D = StageReference.stage.stage3Ds[0];
			if (! _stage3D.context3D)
			{
				_stage3D.addEventListener(Event.CONTEXT3D_CREATE, _contextCreate);
				_stage3D.requestContext3D(Context3DRenderMode.AUTO);
				// _stage3D.requestContext3D(Context3DRenderMode.AUTO, Context3DProfile.BASELINE_EXTENDED);
			}
			else
			{
				_contextCreate(null);
			}
		}
		
		/** リソースのアップロード */
		public function uploadResource ( ) :void
		{
			for each (var resource :Resource in _scene.getResources(true))
				if (! resource.isUploaded) resource.upload(_stage3D.context3D);
		}
		
		/** レンダリング開始 */
		public function renderStart ( ) :void
		{
			StageReference.addEnterFrameFunction(_render);
		}
		/** レンダリング停止 */
		public function renderStop ( ) :void
		{
			StageReference.removeEnterFrameFunction(_render);
		}
		
		
		// ------------------------------------------------------------------- protected
		
		/** READY (準備完了) */
		protected function _ready ( ) :void
		{
			_scene  = new CustomObject3D();
			_camera = new CustomCamera3D(__nearClipping, __farClipping);
			
			
			if (__width  <= 0 || __stageFit) __width  = StageReference.stageWidth;
			if (__height <= 0 || __stageFit) __height = StageReference.stageHeight;
			
			
			_camera.view = new CustomView(__width, __height);
			_camera.view.hideLogo();
			
			_scene.addChild(_camera);
			
			addChild(_camera.view);
			if (__showDiagram) addChild(_camera.diagram);
			
			if (__stageFit)
			{
				_resize();
				StageReference.addResizeFunction(_resize);
			}
			
			
			dispatchEvent(new AlternativaEvent(AlternativaEvent.READY));
		}
		
		/** RENDER */
		protected function _render ( ) :void
		{
			_camera.render(_stage3D);
			dispatchEvent(new AlternativaEvent(AlternativaEvent.RENDER));
		}
		
		
		// ------------------------------------------------------------------- Event
		
		/* _contextCreate */
		private function _contextCreate ( evt :Event ) :void
		{
			_stage3D.removeEventListener(Event.CONTEXT3D_CREATE, _contextCreate);
			_ready();
		}
		
		/* RESIZE */
		protected function _resize ( ) :void
		{
			_camera.view.width  = StageReference.stageWidth;
			_camera.view.height = StageReference.stageHeight;
		}
		
		
		// ------------------------------------------------------------------- getter
		
		/** Stage3D */
		public function get stage3D () :Stage3D        { return _stage3D;     }
		/** Scene */
		public function get scene   () :CustomObject3D { return _scene;       }
		/** Camera */
		public function get camera  () :CustomCamera3D { return _camera;      }
		/** CustomView */
		public function get view    () :CustomView     { return _camera.view as CustomView; }
		
	}
}