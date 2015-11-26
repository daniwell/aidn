package vxml.model.master 
{
	
	public class TimeDef
	{
		
		public var measure     :int;
		public var numerator   :int;
		public var denominator :int;
		public var pos         :int;
		/* BPM */
		public var bpm         :int;
		
		/* 1拍あたりのミリ秒 */
		public var msecPerBeat   :Number;
		
		public function TimeDef(timeSig :XML, tempo :XML) 
		{
			measure     = int(timeSig.measure[0]);
			numerator   = int(timeSig.numerator[0]);
			denominator = int(timeSig.denominator[0]);
			pos         = int(tempo.pos[0]);
			bpm         = Math.round(Number(tempo.bpm[0]));
			
			msecPerBeat = 60000 / bpm;
		}
		
	}

}