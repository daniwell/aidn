package aidn.air.events 
{
	import aidn.air.controller.ClipboardManager;
	import flash.events.Event;
	
	public class DragEvent extends Event
	{
		public static const DRAG_ENTER_ALLOWED :String = "dragEnterAllowed";
		public static const DRAG_ENTER_DENIED  :String = "dragEnterDenied";
		public static const DRAG_DROP          :String = "dragDrop";
		
		public var clipboard :ClipboardManager;
		
		public function DragEvent(type :String, bubbles :Boolean = false, cancelable :Boolean = false) 
		{
			super(type, bubbles, cancelable)
		}
		
		override public function clone ( ) :Event
		{
			var e :DragEvent = new DragEvent(type, bubbles, cancelable);
			e.clipboard = clipboard;
			return e;
		}
	}
}