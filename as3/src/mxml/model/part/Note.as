package mxml.model.part 
{
	import mxml.util.Converter;
	
	public class Note 
	{
		/// 歌詞
		public var lyric :String = "";
		
		/// 休符
		public var isRest :Boolean = false;
		
		/// ノートナンバー（音程）
		public var noteNum :int = -1;
		
		/// 長さ
		public var duration :int = -1;
		
		/// 曲頭からのこのノートまでの長さ
		public var pos  :int    = -1;
		/// 曲頭からのこのノートまでの時間(ミリ秒)
		public var time :Number = -1;
		
		
		public function Note ( note :XML = null ) 
		{
			if (! note) return;
			
			isRest = note.hasOwnProperty("rest");
			
			if (note.hasOwnProperty("lyric"))
			{
				lyric = note.lyric.text;
			}
			if (note.hasOwnProperty("pitch"))
			{
				var step   :String = note.pitch.step;
				var alter  :int    = note.pitch.alter;
				var octave :int    = note.pitch.octave;
				noteNum = Converter.getNoteNumber(step, alter, octave);
				
				/// trace(lyric, noteNum);
			}
			
			duration = note.duration;
		}
		
	}

}