package vxml.model.track 
{
	
	public class Note
	{
		
		/* 前のノートからの相対位置 */
		public var pos      :int;
		/* ノート番号 */
		public var noteNum  :int;
		/* ベロシティ */
		public var velocity :int;
		/* 長さ */
		public var duration :int;
		/* 歌詞 */
		public var lyric    :String;
		/* 発音 */
		public var phoneme  :String;
		public var decay    :int;
		public var accent   :int;
		
		/*
		public var bendDepth         :int;
		public var bendLength        :int;
		public var risingPortamento  :int;
		public var fallingPortamento :int;
		*/
		
		
		public function Note ( note :XML ) 
		{
			pos      = int(note.pos[0]);
			noteNum  = int(note.noteNum[0]);
			velocity = int(note.velocity[0]);
			duration = int(note.duration[0]);
			lyric    = note.lyric[0];
			phoneme  = note.phoneme[0];
			pos      = int(note.pos[0]);
			accent   = int(note.accent[0]);
		}
		
	}

}