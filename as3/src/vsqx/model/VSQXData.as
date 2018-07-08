package vsqx.model 
{
	
	public class VSQXData 
	{
		/** BPM */
		public var bpm :int = 120;
		/** 一拍あたりの時間 (ミリ秒) */
		public var beat :Number = 500;
		
		/** ノート */
		public var notes :/*VSQXNote*/Array = [];
		/** ノート数 */
		public var noteLen :int = 0;
		
		public function VSQXData (xml :XML) 
		{
			this._init(xml);
		}
		
		private function _init (xml :XML) :void
		{
			var t :* = xml.masterTrack.tempo;
			
			if (0 < t.bpm)	bpm = t.bpm / 100;
			else			bpm = t.v / 100;
			beat = 60000 / bpm;
			
			trace(bpm, beat);
			
			var len :int;
			
			var part :* = xml.vsTrack.musicalPart;
			
			/// trace(part, part == null, part == undefined);
			if (part == undefined) part = xml.vsTrack.vsPart;
			
			
			len = part.note.length();
			
			noteLen = len;
			
			trace("len", len);
			for (var i :int = 0; i < len; i ++)
			{
				var x :XML = part.note[i];
				notes[i] = new VSQXNote(x, beat);
			}
		}
		
	}
}