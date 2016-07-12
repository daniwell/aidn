package mxml.model 
{
	
	public class MasterData 
	{
		/// BPM
		public var bpm :int = 120;
		/// 1拍あたりのミリ秒
		public var msecPerBeat :Number;
		/// 1拍あたりの長さ
		public var durationPerBeat :int = 480;
		
		public function MasterData ( part :XML = null ) 
		{
			if (part) _init(part);
		}
		
		private function _init ( part :XML ) :void
		{
			for each (var measure :XML in part.measure)
			{
				if (measure.hasOwnProperty("direction"))
				{
					bpm = int(measure.direction.sound.@tempo);
				}
				if (measure.hasOwnProperty("attributes"))
				{
					durationPerBeat = measure.attributes.divisions;
				}
			}
			msecPerBeat = 60000 / bpm;
		}
		
	}

}