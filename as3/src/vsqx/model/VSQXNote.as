package vsqx.model 
{
	public class VSQXNote 
	{
		/** 位置 */
		public var position :int;
		/** 時間位置 (ミリ秒) */
		public var time :Number;
		/** 長さ */
		public var duration :int;
		
		/** 音程 */
		public var note :int;		
		/** 歌詞 */
		public var lyric :String;
		
		public function VSQXNote (xml :XML, beat :Number = 500) 
		{
			position = xml.posTick;
			duration = xml.durTick;
			note     = xml.noteNum;
			lyric    = xml.lyric;
			
			time = position * beat / 480;
		}		
	}
}