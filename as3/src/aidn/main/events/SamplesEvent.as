package aidn.main.events 
{
	import flash.events.Event;
	
	public class SamplesEvent extends Event
	{
		public static const SOUND_COMPLETE :String = "soundComplete";
		
		
		public function SamplesEvent (type :String, bubbles :Boolean = false, cancelable :Boolean = false) 
		{
			super(type, bubbles, cancelable)
		}
		
		override public function clone ( ) :Event
		{
			var e :SamplesEvent = new SamplesEvent(type, bubbles, cancelable);
			return e;
		}
	}
}