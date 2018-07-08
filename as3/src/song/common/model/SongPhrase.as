package song.common.model 
{
	public class SongPhrase 
	{
		/** 歌詞フレーズ */
		public var lyric :String;
		
		public var notes :/*SongNote*/Array;
		
		/** 位置 */
		public var position :int;
		/** 時間位置 (ミリ秒) */
		public var time :Number;
		/** 長さ (ミリ秒) */
		public var duration :Number;
		
		
		public function SongPhrase() 
		{
			
		}
		
		public function init (notes :/*SongNote*/Array, enote :SongNote) :void
		{
			var l :int = notes.length;
			var s :String = "";
			
			for (var i :int = 0; i < l; i ++)
			{
				var n :SongNote = notes[i];
				
				switch (n.lyric)
				{
				case "_":
					s += " ";
					break;
				default:
					s += n.lyric;
				}
				
				
				if (i == 0)
				{
					time     = n.time;
					position = n.position;
					duration = enote.time - n.time;
				}
			}
			
			this.lyric = s;
			this.notes = notes;
			
			trace("-------------");
			trace(lyric);
		}
		
	}
}