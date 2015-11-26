package vxml.model 
{
	import vxml.model.master.SingerDef;
	import vxml.model.master.TimeDef;
	
	
	public class MasterData
	{
		/* シーケンス名 */
		public var seqName     :String;
		/* 1拍の長さ */
		public var resolution  :int;
		/* ボリューム */
		public var volume      :Number;
		public var panpot      :int;
		
		public var timeDef   :TimeDef;
		public var singerDef :SingerDef;
		
		
		public function MasterData ( xml :XML = null ) 
		{
			if (xml) init(xml);
		}
		
		public function init ( xml :XML ) :void
		{
			seqName    =        xml.seqName[0];
			resolution =    int(xml.resolution[0]);
			volume     = Number(xml.volume[0]);
			panpot     =    int(xml.panpot[0]);
			
			timeDef   = new TimeDef(xml.timeSig[0], xml.tempo[0]);
			singerDef = new SingerDef(xml.singerDef[0]);
		}
		
	}

}