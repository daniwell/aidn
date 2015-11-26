package aidn.main.events 
{
	import flash.events.Event;
	
	
	public class ViewEvent extends Event
	{
		public static const SHOW_COMPLETE :String = "showComplete";
		public static const HIDE_COMPLETE :String = "hideComplete";
		
		public function ViewEvent(type :String, bubbles :Boolean = false, cancelable :Boolean = false) 
		{
			super(type, bubbles, cancelable)
		}
		
	}
}