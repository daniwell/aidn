package aidn.alternativa3d.model 
{
	/**
	 * for ColladaManager
	 */
	
	public class SliceData 
	{
		public var id    :int;
		public var start :Number;
		public var end   :Number;
		
		public function SliceData ( id :int, start :Number = 0, end :Number = Number.MAX_VALUE ) 
		{
			this.id    = id;
			this.start = start;
			this.end   = end;
		}	
	}
}