package aidn.android.display 
{
	import aidn.android.events.PadEvent;
	import aidn.main.core.StageReference;
	import aidn.main.util.MathUtil;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class Pad extends Sprite
	{
		private var _pad :DisplayObjectContainer;
		private var _r   :Number;
		
		public function Pad ( ) 
		{
			
		}
		
		public function init ( pad :DisplayObjectContainer, r :Number = 10 ) :void
		{
			_pad = pad;
			_r   = r;
			
			graphics.beginFill(0xff0000, 0.5);
			graphics.drawCircle(0,0,5);
			
			_init();	
		}
		
		private function _init ( ) :void
		{
			if (_pad.parent) _pad.parent.removeChild(_pad);
			addChild(_pad);
			
			_pad.addEventListener(MouseEvent.MOUSE_DOWN, _down);
		}
		
		
		private function _update ( mx :Number, my :Number ) :void
		{
			var rad :Number = Math.atan2(mx, my);
			
			// trace(MathUtil.toDeg(Math.atan2(my, mx)));
			
			var dr      :Number = _r * _r;
			var dxy     :Number = mx * mx + my * my;
			var percent :Number;
			
			if (dr < dxy)
			{
				_pad.x = _r * Math.sin(rad);
				_pad.y = _r * Math.cos(rad);
				
				percent = 1;
			}
			else
			{
				_pad.x = mx;
				_pad.y = my;
				
				percent = dxy / dr;
			}
			
			var e :PadEvent = new PadEvent(PadEvent.UPDATE);
			e.radian  = rad;
			e.percent = percent;
			dispatchEvent(e);
		}
		
		private function _down ( evt :MouseEvent ) :void 
		{
			// StageReference.addEventListener(MouseEvent.MOUSE_MOVE, _move);
			StageReference.addEventListener(MouseEvent.MOUSE_UP, _up);
			StageReference.addEnterFrameFunction(_enterFrame);
		}
		
		private function _enterFrame ( ) :void 
		{
			_update(this.mouseX, this.mouseY);
		}
		private function _up ( evt :MouseEvent ) :void 
		{
			_update(0,0);	
			
			// StageReference.removeEventListener(MouseEvent.MOUSE_MOVE, _move);
			StageReference.removeEventListener(MouseEvent.MOUSE_UP, _up);
			StageReference.removeEnterFrameFunction(_enterFrame);
			
		}
		
		
	}

}