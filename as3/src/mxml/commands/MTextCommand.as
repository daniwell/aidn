package mxml.commands 
{
	import aidn.main.commands.URLLoaderCommand;
	import flash.events.Event;
	import mxml.model.MXMLData;
	
	public class MTextCommand extends URLLoaderCommand
	{
		private var _mxmlData :MXMLData;
		
		public function MTextCommand ( url :String ) 
		{
			super(url);
		}
		
		protected override function _complete ( evt :Event ) :void 
		{
			_mxmlData = new MXMLData();
			_mxmlData.fromText(String(data));
			
			super._complete(evt);
		}
		
		public function get mxmlData ( ) :MXMLData { return _mxmlData; }
	}
}