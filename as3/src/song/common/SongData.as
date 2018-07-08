package song.common 
{
	import song.common.model.SongNote;
	import song.common.model.SongPhrase;
	import vsqx.model.VSQXData;
	import vsqx.model.VSQXNote;
	
	public class SongData 
	{
		
		/** BPM */
		public var bpm :int = 120;
		/** 一拍あたりの時間 (ミリ秒) */
		public var beat :Number = 500;
		
		/** ノート */
		public var notes :/*SongNote*/Array;
		/** フレーズ */
		public var phrases :/*SongPhrase*/Array;
		
		
		public function SongData() 
		{
			
		}
		
		public function initVSQX (data :VSQXData, sepaChar :String = "e") :void
		{
			bpm  = data.bpm;
			beat = data.beat;
			
			notes = [];
			phrases = [];
			
			var tmps :/*SongNote*/Array = [];
			
			for (var i :int = 0; i < data.noteLen; i ++)
			{
				var n :VSQXNote = data.notes[i];
				
				var sn :SongNote = new SongNote();
				sn.duration = (n.duration / 480) * beat;
				sn.lyric    = n.lyric;
				sn.note     = n.note;
				sn.position = n.position;
				sn.time     = n.time;
				
				if (sn.lyric == sepaChar)
				{
					var phrase :SongPhrase = new SongPhrase();
					phrase.init(tmps, sn);
					phrases.push(phrase);
					
					tmps = [];
				}
				else
				{
					tmps.push(sn);
				}
				
				notes.push(sn);
			}
		}
		
	}

}