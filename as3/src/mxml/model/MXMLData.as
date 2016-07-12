package mxml.model 
{
	import mxml.model.part.Note;
	public class MXMLData 
	{
		private var _masterData :MasterData;
		private var _partDatas  :/*PartData*/Array;
		
		
		public function MXMLData ( xml :XML = null ) 
		{
			if (xml) _init(xml);
		}
		
		private function _init ( xml :XML ) :void
		{
			_partDatas = [];
			var part :XML;
			
			for each (part in xml.part)
				if (! _masterData) _masterData = new MasterData(part);
			for each (part in xml.part)
				_partDatas.push(new PartData(part, _masterData));
			
		}
		
		public function fromText ( str :String ) :void
		{
			var a :Array = str.split("\n");
			
			_masterData = new MasterData();
			_masterData.bpm = int(a[0]);
			_masterData.msecPerBeat = 60000 / _masterData.bpm;
			
			var pd :PartData = new PartData();
			var dur :int = 0;
			
			pd.notes = [];
			
			for (var i :int = 1; i < a.length; i ++)
			{
				var s :Array = a[i].split(",");
				if (s.length < 3) continue;
				
				var n :Note = new Note();
				n.lyric    = s[0];
				n.noteNum  = int(s[1]);
				n.duration = int(s[2]);
				n.time     = Number(s[3]);
				
				n.pos = dur;
				dur += n.duration;
				
				n.isRest = (n.lyric == "" && n.noteNum == -1);
				
				pd.notes.push(n);
			}
			pd.noteTotal = pd.notes.length;
			
			_partDatas = [pd];
		}
		
		public function toText () :String
		{
			if (_partDatas.length < 1) return "";
			
			var p :PartData = _partDatas[0];
			var s :String   = _masterData.bpm + "";
			
			for (var i :int = 0; i < p.noteTotal; i ++)
			{
				var n :Note = p.notes[i];
				s += "\n" + n.lyric + "," + n.noteNum + "," + n.duration + "," + n.time;
			}
			return s;
		}
		
		public function get masterData ( ) :MasterData { return _masterData; }
		public function get partDatas  ( ) :Array/*PartData*/ { return _partDatas; }
	}
}