package vxml.model.simple 
{
	import vxml.model.MasterData;
	import vxml.model.TrackData;
	
	public class SimpleData
	{
		
		public var notes :/*SimpleNote*/Array;
		public var total :int;
		
		public var now :int = 0;
		
		private const SEPARATOR :String = ",";
		
		public function SimpleData( masterData :MasterData = null, trackData :TrackData = null, offset :Number = 0 ) 
		{
			if (! masterData || ! trackData) return;
			_int(masterData, trackData, offset);
		}
		
		
		
		public function output ( t :int = 6 ) :String
		{
			var data :String = "";
			
			var a :Array = [];
			var n :int   = 0;
			if (6 < t) t = 6;
			
			for (var i :int = 0; i < total; i ++)
			{
				a = [notes[i].lyric, notes[i].phoneme, notes[i].time, notes[i].duration, notes[i].noteNum, notes[i].velocity];
				
				for (n = 0; n < t; n ++)
				{
					if (n < t - 1)	data += a[n] + SEPARATOR;
					else			data += a[n] + "\n";
				}
			}
			return data;
		}
		public function input ( value :String, offset :Number = 0 ) :SimpleData
		{
			var lines :/*String*/Array = value.split("\n");
			var l :int = lines.length;
			
			notes = [];
			
			for (var i :int = 0; i < l; i ++)
			{
				var a :/*String*/Array = lines[i].split(SEPARATOR);
				if (3 <= a.length)
				{
					var note :SimpleNote = new SimpleNote();
					
					note.lyric    = a[0];
					note.phoneme  = a[1];
					note.time     = Number(a[2]) + offset;
					
					if (a[3] != null)	note.duration = Number(a[3]);
					else				note.duration = 100;
					if (a[4] != null)	note.noteNum = int(a[4]);
					else				note.noteNum = 60;
					if (a[5] != null)	note.velocity = Number(a[5]);
					else				note.velocity = 1.0;
					
					notes.push(note);
				}
				else 
				{
					// trace("error:", a);
				}
			}
			
			total = notes.length;
			
			return this;
		}
		
		public function getCharSet ( ) :String
		{
			var obj :Object = { };
			
			var i :int, j :int;
			var l :int;
			var c :String;
			
			var s :String = "";
			
			for (i = 0; i < total; i ++)
			{
				l = notes[i].lyric.length;
				
				for (j = 0; j < l; j ++)
				{
					c = notes[i].lyric.charAt(j);
					if (obj[c] != 1)
					{
						s += c;
						obj[c] = 1;
					}
				}
			}
			obj = null;
			return s;
		}
		
		
		private function _int ( md :MasterData, td :TrackData, offset :Number = 0 ) :void
		{
			notes = [];
			total = td.noteTotal;
			
			var t :Number = offset;
			
			for (var i :int = 0; i < total; i ++)
			{
				t += td.notes[i].pos / md.resolution * md.timeDef.msecPerBeat;
				notes[i] = new SimpleNote( td.notes[i], t, td.notes[i].duration / md.resolution * md.timeDef.msecPerBeat );
			}
		}
	}
}