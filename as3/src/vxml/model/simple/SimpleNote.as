package vxml.model.simple 
{
	import aidn.main.util.MathUtil;
	import vxml.model.track.Note;
	
	public class SimpleNote
	{
		/* 時間(ミリ秒) */
		public var time :Number;
		/* 長さ(ミリ秒) */
		public var duration :Number;
		
		/* ノート番号 */
		public var noteNum  :int;
		/* ベロシティ(0-1) */
		public var velocity :Number;
		
		/* 歌詞 */
		public var lyric    :String;
		/* 発音 */
		public var phoneme  :String;
		
		public function SimpleNote ( note :Note = null, t :Number = 0, d :Number = 0 ) 
		{
			if (! note) return;
			
			time     = MathUtil.round(t, 100);
			duration = MathUtil.round(d, 100);
			
			noteNum  = MathUtil.round(note.noteNum, 100);
			velocity = MathUtil.round(note.velocity / 127, 100);
			lyric    = note.lyric;
			phoneme  = note.phoneme;
		}
		
		
		public function clone ( ) :SimpleNote
		{
			var sn :SimpleNote = new SimpleNote();
			
			sn.time     = time;
			sn.duration = duration;
			sn.noteNum  = noteNum;
			sn.velocity = velocity;
			sn.lyric    = lyric;
			sn.phoneme  = phoneme;
			
			return sn;
		}
		
	}
}