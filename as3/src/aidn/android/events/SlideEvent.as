package aidn.android.events 
{
	import flash.events.Event;
	
	public class SlideEvent extends Event
	{
		public static const UPDATE :String = "slideUpdate";
		
		public var percentX :Number;
		public var percentY :Number;
		
		public function SlideEvent(type :String, bubbles :Boolean = false, cancelable :Boolean = false) 
		{
			super(type, bubbles, cancelable)
		}
		
		override public function clone ( ) :Event
		{
			var e :SlideEvent = new SlideEvent(type, bubbles, cancelable)
			e.percentX = percentX;
			e.percentY = percentY;
			return e;
		}
		
	}
}