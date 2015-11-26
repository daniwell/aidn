package com.papiness.utils  
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class ButtonUtil 
	{
		
		public static function init ( clip :MovieClip, clickFunc :Function = null ) :void
		{
			clip.gotoAndStop(1);
			
			clip.buttonMode    = true;
			clip.mouseChildren = false;
			
			clip.addEventListener(MouseEvent.MOUSE_OVER, _mouseOver);
			clip.addEventListener(MouseEvent.MOUSE_OUT,  _mouseOut);
			
			if (clickFunc != null) clip.addEventListener(MouseEvent.CLICK, clickFunc);
		}
		
		/* MOUSE OVER */
		private static function _mouseOver ( evt :MouseEvent ) :void 
		{
			var mc :MovieClip = evt.target as MovieClip;
			mc.gotoAndStop(2);
		}
		/* MOUSE OUT */
		private static function _mouseOut ( evt :MouseEvent ) :void 
		{
			var mc :MovieClip = evt.target as MovieClip;
			mc.gotoAndStop(1);
		}
		
	}
}