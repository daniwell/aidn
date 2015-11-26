package aidn.main.view.base 
{
	import aidn.main.core.StageReference;
	import aidn.main.view.base.ViewBase;
	import aidn.tweener.core.Tween;
	
	public class ExViewBase extends ViewBase
	{
		private var _fadeTime :Number;
		
		public function ExViewBase(fadeTime :Number = 0.1) 
		{
			_fadeTime = fadeTime;
			
			StageReference.addResizeFunction(_resize);
			visible = false;
		}
		
		override public function show():void 
		{
			Tween.show(this, _fadeTime, 0.0, _showComplete);
		}
		
		override public function hide():void 
		{
			Tween.hide(this, _fadeTime, 0.0, _hide);
		}
		private function _hide ( ) :void
		{
			visible = false;
			_hideComplete();
		}
		
		
		protected var _stw :int;
		protected var _sth :int;
		protected var _cw  :int;
		protected var _ch  :int;
		
		protected function _resize ( ) :void
		{
			_stw = StageReference.stageWidth;
			_sth = StageReference.stageHeight;
			_cw  = _stw / 2;
			_ch  = _sth / 2;
		}
		
	}
}