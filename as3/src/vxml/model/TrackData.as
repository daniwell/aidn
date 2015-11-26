package vxml.model 
{
	import vxml.model.track.Note;
	
	
	public class TrackData
	{
		
		public var notes :/*Note*/Array;
		public var noteTotal :int;
		
		public function TrackData ( xml :XML = null ) 
		{
			if (xml) init(xml);
		}
		
		public function init ( xml :XML ) :void
		{
			var i :int;
			notes = [];
			
			for each ( var note :XML in xml.note )
			{
				notes[i++] = new Note(note);
			}
			noteTotal = i;
		}
	}
}