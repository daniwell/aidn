package vxml.commands 
{
	import aidn.main.commands.URLLoaderCommand;
	import flash.events.Event;
	import vxml.model.MasterData;
	import vxml.model.TrackData;
	
	
	public class VXMLCommand extends URLLoaderCommand
	{
		private var _masterData :MasterData;
		private var _trackDatas :/*TrackData*/Array;
		
		public function VXMLCommand ( url :String ) 
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
			
			_masterData = new MasterData(xml.masterInfo[0]);
			
			_trackDatas = [];
			for each ( var track :XML in xml.trackInfo )
			{
				_trackDatas.push(new TrackData(track));
			}
		}
		
		// ------------------------------------------------------------------- Event
		
		protected override function _complete ( evt :Event ) :void 
		{
			super._complete(evt);
		}
		
		
		public function get masterData ( ) :MasterData
		{
			if (! _masterData && data) _parse(data);
			return _masterData;
		}
		public function get trackDatas ( ) :/*TrackData*/Array
		{
			if (! _trackDatas && data) _parse(data);
			return _trackDatas;
		}
		
	}
}