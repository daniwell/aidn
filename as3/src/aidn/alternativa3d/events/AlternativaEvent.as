package aidn.alternativa3d.events 
{
	import flash.events.Event;
	
	public class AlternativaEvent extends Event
	{
		public static const READY  :String = "ready";
		public static const RENDER :String = "render";
		
		public function AlternativaEvent(type :String, bubbles :Boolean = false, cancelable :Boolean = false) 
		{
			super(type, bubbles, cancelable)
		}
	}
}