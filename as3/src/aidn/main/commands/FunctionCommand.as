package aidn.main.commands 
{
	import aidn.main.commands.base.CommandBase;
	
	public class FunctionCommand extends CommandBase
	{
		private var _target    :*;
		private var _eventType :String;
		private var _func      :Function;
		private var _params    :Array;
		
		public function FunctionCommand ( target :*, func :Function, params :Array = null, eventType :String = null )
		{
			_target    = target;
			_func      = func;
			_params    = params;
			_eventType = eventType;
			
			if (_eventType) _target.addEventListener(_eventType, _complete);
		}
		
		override public function execute ( ) :void 
		{
			_func.apply(_target, _params);
			if (! _eventType) _dispatchComplete();
		}
		
		private function _complete ( evt :* ) :void
		{
			_target.removeEventListener(_eventType, _complete);
			_dispatchComplete();
		}
	}
}