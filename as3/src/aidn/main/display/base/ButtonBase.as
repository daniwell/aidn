package aidn.main.display.base 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class ButtonBase extends DisplayBase
	{
		protected var _over :MovieClip;
		protected var _out  :MovieClip;
		
		private var _mouseOverFunction :Function;
		private var  _mouseOutFunction :Function;
		
		public function ButtonBase ( dobj :DisplayObjectContainer, clickFunc :Function = null, parent :DisplayObjectContainer = null ) :void
		{
			super(dobj, parent);
			
			if (dobj is Sprite)
			{
				Sprite(dobj).buttonMode    = true;
				Sprite(dobj).mouseChildren = false;
			}
			if (dobj is MovieClip)
			{
				MovieClip(dobj).buttonMode    = true;
				MovieClip(dobj).mouseChildren = false;
			}
			
			if (dobj.getChildByName("over") && dobj.getChildByName("out"))
			{
				_over = dobj.getChildByName("over") as MovieClip;
				_out  = dobj.getChildByName("out")  as MovieClip;
				
				_over.visible = false;
			}
			_addEvents();
			
			if (clickFunc != null) _dobj.addEventListener(MouseEvent.CLICK, clickFunc);
		}
		
		// ------------------------------------------------------------------- protected
		
		protected function _addEvents ( ) :void
		{
			_dobj.addEventListener(MouseEvent.MOUSE_OVER, _mouseOver);
			_dobj.addEventListener(MouseEvent.MOUSE_OUT,  _mouseOut);
		}
		protected function _removeEvents ( ) :void
		{
			_dobj.removeEventListener(MouseEvent.MOUSE_OVER, _mouseOver);
			_dobj.removeEventListener(MouseEvent.MOUSE_OUT,  _mouseOut);
		}
		
		
		// ------------------------------------------------------------------- public
		/**
		 * マウスオーバー、マウスアウト時のイベントを付加。
		 * @param	mouseOverFunction
		 * @param	mouseOutFunction
		 */
		public function setMouseEvent ( mouseOverFunction :Function, mouseOutFunction :Function = null ) :void
		{
			_mouseOverFunction = mouseOverFunction;
			 _mouseOutFunction =  mouseOutFunction;
		}
		
		
		// ------------------------------------------------------------------- Event
		/* MOUSE OVER */
		private function _mouseOver ( evt :MouseEvent ) :void 
		{
			if (_over)
			{
				_over.visible = true;
				 _out.visible = false;
			}
			if (_mouseOverFunction != null) _mouseOverFunction();
		}
		/* MOUSE OUT */
		private function _mouseOut ( evt :MouseEvent ) :void 
		{
			if (_over)
			{
				_over.visible = false;
				 _out.visible = true;
			}
			if (_mouseOutFunction != null) _mouseOutFunction();
		}
	}
}