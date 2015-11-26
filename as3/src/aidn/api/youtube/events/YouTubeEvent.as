package aidn.api.youtube.events 
{
	import flash.events.Event;
	
	public class YouTubeEvent extends Event
	{
		public static const INIT_COMPLETE :String = "initComplete";
		public static const PLAY_COMPLETE :String = "playComplete";
		public static const PLAY          :String = "play";
		public static const PAUSE         :String = "pauses";
		
		
		public function YouTubeEvent(type :String, bubbles :Boolean = false, cancelable :Boolean = false) 
		{
			super(type, bubbles, cancelable)
		}
		
		override public function clone ( ) :Event
		{
			var e :YouTubeEvent = new YouTubeEvent(type, bubbles, cancelable);
			return e;
		}
		
	}

}