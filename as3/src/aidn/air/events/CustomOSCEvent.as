package aidn.air.events 
{
	import flash.events.Event;
	import org.tuio.osc.OSCMessage;
	
	/**
	 * @require http://code.google.com/p/tuio-as3/
	 */
	
	public class CustomOSCEvent extends Event
	{
		public static const RECEIVED :String = "oscReceived";
		
		public var message :OSCMessage;
		
		public function CustomOSCEvent(type :String, bubbles :Boolean = false, cancelable :Boolean = false) 
		{
			super(type, bubbles, cancelable)
		}
		
		override public function clone ( ) :Event
		{
			var e :CustomOSCEvent = new CustomOSCEvent(type, bubbles, cancelable)
			e.message = message;
			return e;
		}
	}
}