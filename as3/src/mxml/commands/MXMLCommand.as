package mxml.commands 
{
	import aidn.main.commands.URLLoaderCommand;
	import flash.events.Event;
	import mxml.model.MXMLData;
	import mxml.model.MasterData;
	import mxml.model.PartData;
	
	public class MXMLCommand extends URLLoaderCommand
	{
		private var _mxmlData :MXMLData;
		
		public function MXMLCommand ( url :String ) 
		{
			super(url);
		}
		
		
		// ------------------------------------------------------------------- private
		
		private function _parse ( data :* ) :void
		{
			try {
				var xml :XML;
				if (data is XML)	xml = data;
				else				xml = XML(data);
			} catch ( e :* ) {
				trace(this, "xml parse error.");
				return;
			}
			
			_mxmlData = new MXMLData(xml);
			
			//// 
			//// trace(_mxmlData.toText());
		}
		
		// ------------------------------------------------------------------- Event
		
		protected override function _complete ( evt :Event ) :void 
		{
			_parse(data);
			
			super._complete(evt);
		}
		
		public function get mxmlData ( ) :MXMLData { return _mxmlData; }
	}
}