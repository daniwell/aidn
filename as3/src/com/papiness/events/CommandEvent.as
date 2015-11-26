package com.papiness.events 
{
	import flash.events.Event;
	
	/**
	 * @author daniwell
	 */
	public class CommandEvent extends Event
	{
		public static const COMPLETE :String = "commandComplete";
		public static const PROGRESS :String = "commandProgress";
		public static const FAILED   :String = "commandFailed";
		
		public var percent :Number;
		
		public function CommandEvent(type :String, bubbles :Boolean = false, cancelable :Boolean = false) 
		{
			super(type, bubbles, cancelable)
		}
	}
}