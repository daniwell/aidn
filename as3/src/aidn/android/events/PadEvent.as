package aidn.android.events 
{
	import flash.events.Event;
	
	public class PadEvent extends Event
	{
		public static const UPDATE :String = "padUpdate";
		
		public var radian  :Number;
		public var percent :Number;
		
		public function PadEvent (type :String, bubbles :Boolean = false, cancelable :Boolean = false) 
		{
			super(type, bubbles, cancelable)
		}
		
		override public function clone ( ) :Event
		{
			var e :PadEvent = new PadEvent(type, bubbles, cancelable)
			e.radian  = radian;
			e.percent = percent;
			return e;
		}
		
	}
}