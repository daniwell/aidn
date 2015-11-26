package aidn.android.display.base 
{
	import aidn.main.display.base.DisplayBase;
	import aidn.main.events.DisplayEvent;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class RadioButtonBase extends DisplayBase
	{
		public var id :int = -1;
		
		private var _on  :MovieClip;
		private var _off :MovieClip;
		
		private var _selected :Boolean;
		
		private var _clickFunc :Function;
		
		
		public function RadioButtonBase ( dobj :DisplayObjectContainer, parent :DisplayObjectContainer = null )
		{
			super(dobj, parent);
		}
		
		public function init ( nameOn :String = "on", nameOff :String = "off", selected :Boolean = false ) :void
		{
			_on  = _getClip(nameOn);
			_off = _getClip(nameOff);
			
			this.selected = selected;
		}
		
		/** RadioButtonManager と組み合わせて使う時は不要 */
		public function setClickEvent ( clickFunc :Function ) :void
		{
			_clickFunc = clickFunc;
			_dobj.addEventListener(MouseEvent.CLICK, _click);
		}
		
		
		// ------------------------------------------------------------------- Event
		
		private function _click ( evt :MouseEvent ) :void 
		{
			var e :DisplayEvent = new DisplayEvent(MouseEvent.CLICK);
			e.self = this;
			
			_clickFunc(e);
		}
		
		// ------------------------------------------------------------------- getter & setter
		
		public function get selected ( ) :Boolean 
		{
			return _selected;
		}
		
		public function set selected ( value :Boolean ) :void 
		{
			_selected = value;
			_on.visible = _selected;
			_off.visible = ! _selected;
		}
		
	}
}