package aidn.main.commands 
{
	import aidn.main.commands.base.CommandBase;
	import aidn.main.events.CommandEvent;
	
	
	public class SequentialCommand extends CommandBase
	{
		
		private var _rates :/*Number*/Array;
		private var _sum   :Number;
		
		private var _commands :/*CommandBase*/Array;
		
		
		private var _now   :int;
		private var _total :int;
		
		private var _compRate :Number;
		private var _nowRate  :Number;
		
		
		public function SequentialCommand() 
		{
			_sum = _total = 0;
			_rates = [];
			_commands = [];
		}
		
		// ------------------------------------------------------------------- override
		
		override public function execute ( ) :void 
		{
			_now = _compRate = 0;
			
			_execute();
		}
		override public function cancel():void 
		{
			if (_total <= _now) return;
			
			_commands[_now].removeEventListener(CommandEvent.COMPLETE, _complete);
			_commands[_now].removeEventListener(CommandEvent.PROGRESS, _progress);
			_commands[_now].removeEventListener(CommandEvent.FAILED,   _failed);
			_commands[_now].cancel();
		}
		
		
		// ------------------------------------------------------------------- public
		
		public function add ( command :CommandBase, rate :Number = 1.0 ) :void 
		{
			_commands[_total] = command;
			_rates[_total] = rate;
			_sum += rate;
			
			_total ++;
		}
		
		public function reset ( ) :void
		{
			cancel();
			
			_now = _compRate = 0;
			_sum = _total = 0;
			_rates = [];
			_commands = [];
		}

		// ------------------------------------------------------------------- private
		
		private function _execute ( ) :void
		{
			if (_now < _total)
			{
				_nowRate = _rates[_now] / _sum;
				
				_commands[_now].addEventListener(CommandEvent.COMPLETE, _complete);
				_commands[_now].addEventListener(CommandEvent.PROGRESS, _progress);
				_commands[_now].addEventListener(CommandEvent.FAILED,   _failed);
				_commands[_now].execute();
			}
			else
			{
				_dispatchComplete();
			}
		}
		
		/**  */
		protected function _completeCommand ( cmd :CommandBase, now :int ) :void { }
		
		// ------------------------------------------------------------------- Event
		
		private function _complete ( evt :CommandEvent ) :void 
		{
			_commands[_now].removeEventListener(CommandEvent.COMPLETE, _complete);
			_commands[_now].removeEventListener(CommandEvent.PROGRESS, _progress);
			_commands[_now].removeEventListener(CommandEvent.FAILED,   _failed);
			
			_compRate += _nowRate;
			_dispatchProgress(_compRate);
			
			_completeCommand(_commands[_now], _now);
			
			_now ++;
			_execute();
		}
		private function _progress ( evt :CommandEvent ) :void 
		{
			_dispatchProgress(_compRate + evt.percent * _nowRate);
		}
		private function _failed ( evt :CommandEvent ) :void 
		{
			_commands[_now].removeEventListener(CommandEvent.COMPLETE, _complete);
			_commands[_now].removeEventListener(CommandEvent.PROGRESS, _progress);
			_commands[_now].removeEventListener(CommandEvent.FAILED,   _failed);
			
			_dispatchFailed();
		}
		
		
		// ------------------------------------------------------------------- getter
		
		public function get commands ( ) :/*CommandBase*/Array { return _commands; }
		
	}
}