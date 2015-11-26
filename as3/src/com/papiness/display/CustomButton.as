package com.papiness.display 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * マウスオーバー時：再生、アウト時：逆再生のインタラクションボタン。
	 * @author daniwell
	 */
	public class CustomButton extends MovieClip
	{
		
		public function CustomButton() 
		{
			_init();
			
		}
		
		// ------------------------------------------------------------------- private methods
		private function _init ( ) :void
		{
			stop();
			addFrameScript(totalFrames-1, stop);
			
			buttonMode    = true;
			mouseChildren = false;
			
			addEventListener( MouseEvent.MOUSE_OVER, _mouseOverHandler );
			addEventListener( MouseEvent.MOUSE_OUT,  _mouseOutHandler );
		}
		
		// ------------------------------------------------------------------- Event
		private function _mouseOverHandler ( evt :MouseEvent ) :void
		{
			removeEventListener( Event.ENTER_FRAME, _enterFrame );
			play();
		}
		private function _mouseOutHandler ( evt :MouseEvent ) :void
		{
			addEventListener( Event.ENTER_FRAME, _enterFrame );	
		}
		
		private function _enterFrame ( evt :Event ) :void
		{
			if ( currentFrame != 1 )
			{
				prevFrame();
			}
			else
			{
				removeEventListener( Event.ENTER_FRAME, _enterFrame );
				stop();
			}
		}
	}
	
}