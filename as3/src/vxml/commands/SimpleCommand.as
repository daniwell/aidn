package vxml.commands 
{
	import aidn.main.commands.URLLoaderCommand;
	import flash.events.Event;
	import vxml.model.simple.SimpleData;
	
	
	public class SimpleCommand extends URLLoaderCommand
	{
		private var _simpleData :SimpleData;
		private var _offset     :Number;
		
		public function SimpleCommand ( url :String, offset :Number = 0 ) 
		{
			super(url);
			_offset = offset;
		}
		
		// ------------------------------------------------------------------- Event
		
		protected override function _complete ( evt :Event ) :void 
		{
			super._complete(evt);
		}
		
		public function get simpleData ( ) :SimpleData
		{
			if (! _simpleData && data)
			{
				_simpleData = new SimpleData();
				_simpleData.input(String(data), _offset);
			}
			
			return _simpleData;
		}
		
	}

}