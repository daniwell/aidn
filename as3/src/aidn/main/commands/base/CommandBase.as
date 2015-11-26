package aidn.main.commands.base 
{
	import aidn.main.events.CommandEvent;
	import flash.events.EventDispatcher;
	
	/** @eventType CommandEvent.COMPLETE */
	[Event(name="commandComplete", type="aidn.main.events.CommandEvent")]
	/** @eventType CommandEvent.PROGRESS */
	[Event(name="commandProgress", type="aidn.main.events.CommandEvent")]
	/** @eventType CommandEvent.FAILED */
	[Event(name="commandFailed",   type="aidn.main.events.CommandEvent")]
	
	
	public class CommandBase extends EventDispatcher
	{
		
		public function CommandBase ( ) 
		{
			
		}
		
		public function execute ( ) :void { }
		public function cancel  ( ) :void { }
		
		protected function _dispatchComplete ( ) :void
		{
			dispatchEvent(new CommandEvent(CommandEvent.COMPLETE));
		}
		protected function _dispatchFailed ( errorCode :int = -1 ) :void
		{
			var e :CommandEvent = new CommandEvent(CommandEvent.FAILED);
			e.errorCode = errorCode;
			dispatchEvent(e);
		}
		protected function _dispatchProgress ( percent :Number ) :void
		{
			var e :CommandEvent = new CommandEvent(CommandEvent.PROGRESS);
			e.percent = percent;
			dispatchEvent(e);
		}
		
	}
}