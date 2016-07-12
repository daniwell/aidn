package mxml.model 
{
	import mxml.model.part.Note;
	
	public class PartData 
	{
		public var notes :/*Note*/Array;
		public var noteTotal :int;
		
		public var now :int = 0;
		
		private var _masterData :MasterData;
		
		public function PartData ( part :XML = null, master :MasterData = null ) 
		{
			_masterData = master;
			if (part) _init(part);
		}
		
		private function _init ( part :XML ) :void
		{
			notes = [];
			
			var dur :int = 0;
			
			for each (var measure :XML in part.measure)
			{
				for each (var note :XML in measure.note)
				{
					var n :Note = new Note(note);
					n.pos = dur;
					
					if (_masterData)
					{
						var t :Number = (dur / _masterData.durationPerBeat) * _masterData.msecPerBeat;
						n.time = Math.round(t);
					}
					
					dur += n.duration;
					notes.push(n);
				}
			}
			noteTotal = notes.length;
		}
		
	}

}