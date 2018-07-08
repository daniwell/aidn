package song.common.model 
{
	public class SongNote 
	{
		/** 位置 */
		public var position :int;
		/** 時間位置 (ミリ秒) */
		public var time :Number;
		/** 長さ (ミリ秒) */
		public var duration :Number;
		
		/** 音程 */
		public var note :int;		
		/** 歌詞 */
		public var lyric :String;
		
		
		public function SongNote() 
		{
			
		}
		
	}

}