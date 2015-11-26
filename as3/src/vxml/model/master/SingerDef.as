package vxml.model.master 
{
	
	public class SingerDef
	{
		
		public var lang         :int;
		public var singerType  :int;
		public var dbID        :String;
		public var singerName  :String;
		public var breathiness :int;
		public var brightness  :int;
		public var clearness   :int;
		public var opening     :int;
		public var gender      :int;
		
		public function SingerDef(singerDef :XML) 
		{
			lang        = int(singerDef.lang[0]);
			singerType  = int(singerDef.singerType[0]);
			dbID        = singerDef.dbID[0];
			singerName  = singerDef.singerName[0];
			breathiness = int(singerDef.breathiness[0]);
			brightness  = int(singerDef.brightness[0]);
			clearness   = int(singerDef.clearness[0]);
			opening     = int(singerDef.opening[0]);
			gender      = int(singerDef.gender[0]);
		}
	}
}