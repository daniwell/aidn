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
			bpm  = xml.masterTrack.tempo.bpm / 100;
			beat = 60000 / bpm;
			
			trace(bpm, beat);
			
			var len :int = xml.vsTrack.musicalPart.note.length();
			noteLen = len;
			
			trace("len", len);
			for (var i :int = 0; i < len; i ++)
			{
				var x :XML = xml.vsTrack.musicalPart.note[i];
				notes[i] = new VSQXNote(x, beat);
			}
		}
		
	}
}