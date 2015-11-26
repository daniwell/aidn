package aidn.main.view.base 
{
	import aidn.main.events.ViewEvent;
	import flash.display.Sprite;
	
	
	/** @eventType ViewEvent.SHOW_COMPLETE */
	[Event(name="showComplete", type="aidn.main.events.ViewEvent")]
	/** @eventType ViewEvent.HIDE_COMPLETE */
	[Event(name="hideComplete",   type="aidn.main.events.ViewEvent")]
	
	
	public class ViewBase extends Sprite
	{
		private var _isShowing :Boolean = false;
		
		public function ViewBase() 
		{
			
		}
		
		// ------------------------------------------------------------------- public
		
		public function show ( ) :void { }
		public function hide ( ) :void { }
		
		// ------------------------------------------------------------------- protected
		
		protected function _showComplete ( ) :void
		{
			_isShowing = true;
			dispatchEvent(new ViewEvent(ViewEvent.SHOW_COMPLETE));
		}
		protected function _hideComplete ( ) :void
		{
			_isShowing = false;
			dispatchEvent(new ViewEvent(ViewEvent.HIDE_COMPLETE));
		}
		
		
		// ------------------------------------------------------------------- getter
		
		public function get isShowing ( ) :Boolean { return _isShowing; }
	}
}