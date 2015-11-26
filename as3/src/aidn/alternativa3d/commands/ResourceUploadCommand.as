package aidn.alternativa3d.commands 
{
	import aidn.main.commands.base.CommandBase;
	import aidn.main.core.StageReference;
	import aidn.main.util.Debug;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Resource;
	import flash.display.Stage3D;
	import flash.utils.getTimer;
	
	public class ResourceUploadCommand extends CommandBase
	{
		private var _stage3D :Stage3D;
		private var _scene   :Object3D;
		
		private var _resources :Vector.<Resource>;
		private var _total     :int;
		private var _now       :int;
		
		private var _interval  :Number;
		
		private var _res :Vector.<Resource>;
		
		/**
		 * 
		 * @param	stage3D
		 * @param	scene
		 * @param	interval	1 フレームの間に実行するミリ秒
		 */
		public function ResourceUploadCommand ( stage3D :Stage3D, scene :Object3D, interval :Number = 30 ) 
		{
			_stage3D  = stage3D;
			_scene    = scene;
			_interval = interval;
			
			_res = new Vector.<Resource>();
		}
		
		override public function execute ( ) :void 
		{
			var res :Vector.<Resource> = _scene.getResources(true);
			
			var i :int = 0;
			var l :int;
			
			/// 未 upload のものだけ
			_resources = new Vector.<Resource>();
			for (i = 0, l = res.length; i < l; i ++) if (! res[i].isUploaded) _resources.push( res[i]);
			
			_total = _resources.length;
			_now   = 0;
			
			StageReference.addEnterFrameFunction(_enterFrame);
		}
		
		public function addResources ( res :Vector.<Resource> ) :void
		{
			_res = _res.concat(res);
		}
		public function resetResources ( ) :void
		{
			_res = null;
			_res = new Vector.<Resource>();
		}
		
		private function _enterFrame ( ) :void
		{
			var t :Number = getTimer();
			
			for (; _now < _total; _now ++)
			{
				if (_resources[_now] && ! _resources[_now].isUploaded) _resources[_now].upload(_stage3D.context3D);
				
				if (_interval < getTimer() - t) break;
			}
			_dispatchProgress(_now / _total);
			
			if (_now == _total) _complete();
		}
		
		private function _complete ( ) :void
		{
			StageReference.removeEnterFrameFunction(_enterFrame);
			_dispatchComplete();
		}
	}
}