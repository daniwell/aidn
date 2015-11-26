package aidn.main.events 
{
	import flash.events.Event;
	
	public class CommandEvent extends Event
	{
		public static const COMPLETE :String = "commandComplete";
		public static const PROGRESS :String = "commandProgress";
		public static const FAILED   :String = "commandFailed";
		
		public var percent      :Number;
		public var errorCode    :int;
		
		
		public function CommandEvent(type :String, bubbles :Boolean = false, cancelable :Boolean = false) 
		{
			super(type, bubbles, cancelable)
		}
		
		override public function clone ( ) :Event
		{
			var e :CommandEvent = new CommandEvent(type, bubbles, cancelable);
			e.errorCode = errorCode;
			return e;
		}
	}
}