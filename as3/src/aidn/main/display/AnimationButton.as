package aidn.main.display 
{
	import aidn.main.display.base.ButtonBase;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class AnimationButton extends ButtonBase
	{
		
		private var _clip :MovieClip;
		
		public function AnimationButton ( clip :MovieClip, clickFunc :Function = null ) 
		{
			super(clip, clickFunc);
			
			_clip = clip;
			
			clip.gotoAndStop(1);
			clip.addFrameScript(clip.totalFrames - 1, clip.stop);
			clip.addEventListener( MouseEvent.MOUSE_OVER, _mouseOver );
			clip.addEventListener( MouseEvent.MOUSE_OUT,  _mouseOut );
		}
		
		// ------------------------------------------------------------------- Event
		/* MOUSE OVER */
		private function _mouseOver ( evt :MouseEvent ) :void 
		{
			_clip.removeEventListener( Event.ENTER_FRAME, _enterFrame );
			_clip.play();
		}
		/* MOUSE OUT */
		private function _mouseOut ( evt :MouseEvent ) :void 
		{
			_clip.addEventListener( Event.ENTER_FRAME, _enterFrame );	
		}
		/* ENTER FRAME */
		private function _enterFrame ( evt :Event ) :void
		{
			if ( _clip.currentFrame != 1 )
			{
				_clip.prevFrame();
			}
			else
			{
				_clip.removeEventListener( Event.ENTER_FRAME, _enterFrame );
				_clip.stop();
			}
		}
	}
}