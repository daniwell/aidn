package aidn.sion.events  
{
	import flash.events.Event;
	
	public class SiONEvent extends Event
	{
		/** BEAT 映像同期 */
		public static const BEAT :String = "sionBeat";
		/** STEP 音同期 */
		public static const STEP :String = "sionStep";
		
		public var count :int;
		
		public function SiONEvent(type :String, bubbles :Boolean = false, cancelable :Boolean = false) 
		{
			super(type, bubbles, cancelable)
		}
	}
}