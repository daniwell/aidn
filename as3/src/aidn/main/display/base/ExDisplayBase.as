package aidn.main.display.base 
{
	import aidn.main.core.StageReference;
	import flash.display.DisplayObjectContainer;
	
	public class ExDisplayBase extends DisplayBase
	{
		
		public function ExDisplayBase ( dobj :DisplayObjectContainer, parent :DisplayObjectContainer = null ) 
		{
			super(dobj, parent);
			StageReference.addResizeFunction(_resize);
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