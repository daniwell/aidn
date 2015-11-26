package vxml.util 
{
	import vxml.model.simple.SimpleData;
	
	public class SimpleDataUtil 
	{
		
		/**
		 * SimpleData を複数文字連結します。
		 * @param	simpleData		SimpleData
		 * @param	cData			連結歌詞データ(ex. Array ["ある日","森の中","クマさんと",...])
		 * @param	isAll			cData に含まれないものを、そのまま残すかどうか
		 * @return
		 */
		public static function merge ( simpleData :SimpleData, cData :/*String*/Array, isAll :Boolean = true ) :SimpleData
		{
			var n   :int = 0;
			var len :int = cData.length;
			
			var td :SimpleData = simpleData;
			var sd :SimpleData = new SimpleData();
			sd.notes = [];
			
			sd.now = td.now = 0;
			
			
			LOOP:
			while (td.now < td.total)
			{
				var s :String;
				if (n < len)
				{
					s = cData[n ++];
				}
				else
				{
					if (isAll)	s = "　";
					else		break;
				}
				
				var c :String = s.charAt(0);
				var l :int    = s.length;
				
				
				while (td.notes[td.now].lyric != c)	// 一致しない場合
				{
					// SimpleData 追加
					if (isAll) sd.notes[sd.now ++] = td.notes[td.now]; // .clone();
					
					td.now ++;
					if (td.total <= td.now) break LOOP;
				}
				
				// SimpleData 追加
				sd.notes[sd.now]       = td.notes[td.now];
				sd.notes[sd.now].lyric = s;
				
				if (td.now + l - 1 < td.total)
				{
					// duration の計算 : (endTime - startTime) + duration
					sd.notes[sd.now ++].duration = (td.notes[td.now+l-1].time - td.notes[td.now].time) + td.notes[td.now+l-1].duration;
				}
				td.now += l;
				
			}	// while end
			
			
			sd.now   = 0;
			sd.total = sd.notes.length;
			
			return sd;
		}
	}
}