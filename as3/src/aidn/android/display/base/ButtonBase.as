package aidn.android.display.base 
{
	import aidn.main.display.base.DisplayBase;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.ui.Multitouch;
	
	public class ButtonBase extends DisplayBase
	{
		public function ButtonBase ( dobj :DisplayObjectContainer, tapFunc :Function = null, parent :DisplayObjectContainer = null ) :void
		{
			super(dobj, parent);
			dobj.mouseChildren = false;
			
			if (tapFunc != null)
			{
				if (Multitouch.supportsTouchEvents)
					_dobj.addEventListener(TouchEvent.TOUCH_TAP, tapFunc);
				else
					_dobj.addEventListener(MouseEvent.CLICK, tapFunc);
			}
		}
		
	}
}