package aidn.main.util 
{
	
	public class MathSoundUtil 
	{
		/** 
		 * 秒 を ポジション値 に変換します。
		 * @param sec	秒(sec)。
		 * @return		ポジション値。
		 */
		public static function fromSecToPosition ( sec :Number ) :int { return (sec * 44100); }
		
		/** 
		 * ポジション値 を 秒 に変換します。
		 * @param position	ポジション値。
		 * @return			秒(sec)。
		 */
		public static function fromPositionToSec ( position :int ) :Number { return (position * 0.0441); }
		
		
		/**
		 * 任意のBPMにおける、1 拍あたりの秒数を求めます。
		 * @param	bpm		任意のBMP。
		 * @return
		 */
		public static function secPerBeat ( bpm :Number ) :Number { return 60 / bpm; }
		
	}
}