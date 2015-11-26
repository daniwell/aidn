package aidn.android.events 
{
	import flash.events.Event;
	
	public class RadioButtonEvent extends Event
	{
		public static const CHANGE :String = "radioButtonChange";
		
		public var id :int;
		
		
		public function RadioButtonEvent(type :String, bubbles :Boolean = false, cancelable :Boolean = false) 
		{
			super(type, bubbles, cancelable)
		}
		
		override public function clone ( ) :Event
		{
			var e :RadioButtonEvent = new RadioButtonEvent(type, bubbles, cancelable)
			e.id = id;
			return e;
		}
	}
}