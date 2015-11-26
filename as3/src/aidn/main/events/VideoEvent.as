package aidn.main.events 
{
	import flash.events.Event;
	
	public class VideoEvent extends Event
	{
		public static const INIT      :String = "videoInit";
		public static const START     :String = "videoStart";
		public static const END       :String = "videoEnd";
		public static const META_DATA :String = "videoMetaData";
		
		public function VideoEvent(type :String, bubbles :Boolean = false, cancelable :Boolean = false) 
		{
			super(type, bubbles, cancelable)
		}
	}
}