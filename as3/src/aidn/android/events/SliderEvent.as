package aidn.android.events 
{
	import flash.events.Event;
	
	public class SliderEvent extends Event
	{
		public static const CHANGE :String = "sliderChange";
		
		public var value :Number;
		
		public function SliderEvent(type :String, bubbles :Boolean = false, cancelable :Boolean = false) 
		{
			super(type, bubbles, cancelable)
		}
		
		override public function clone ( ) :Event
		{
			var e :SliderEvent = new SliderEvent(type, bubbles, cancelable)
			e.value = value;
			return e;
		}
	}
}