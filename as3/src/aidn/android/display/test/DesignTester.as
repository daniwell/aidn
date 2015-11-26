package aidn.android.display.test 
{
	import aidn.android.core.AndroidReference;
	import aidn.main.core.StageReference;
	import aidn.main.display.base.DisplayBase;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.ui.Multitouch;
	
	public class DesignTester extends Sprite
	{
		private var _clip  :MovieClip;
		private var _frame :int = 1;
		
		public function DesignTester ( clip :MovieClip, stage :Stage ) 
		{
			StageReference.init(stage)
			AndroidReference.init(stage);
			
			
			_clip = clip;
			_clip.gotoAndStop(_frame);
			
			addChild(clip);
			
			if (Multitouch.supportsTouchEvents)
				_clip.addEventListener(TouchEvent.TOUCH_TAP, _tap);
			else
				_clip.addEventListener(MouseEvent.CLICK, _tap);
				
			StageReference.addResizeFunction(_resize);
		}
		
		private function _resize ( ) :void
		{
			_clip.width  = StageReference.stageWidth;
			_clip.height = StageReference.stageHeight
		}
		
		private function _tap ( evt :Event ) :void 
		{
			_frame ++;
			if (_clip.totalFrames < _frame) _frame = 1;
			
			_clip.gotoAndStop(_frame);
		}
		
	}
}