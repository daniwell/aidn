package aidn.main.util 
{
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	public class CompressUtil 
	{
		public static function compress ( data :* ) :ByteArray
		{
			var ba :ByteArray = new ByteArray();
			
			if (data is String )
			{
				// ba.write(data, "utf-8");
				ba.writeUTFBytes(data);
			}
			else if (data is Number ) ba.writeFloat(data);
			else if (data is Boolean) ba.writeBoolean(data);
			else                      ba.writeObject(data);
			
			ba.compress();
			return ba;
		}
		
		public static function save ( ba :ByteArray, filename :String = "" ) :void
		{
			var fr :FileReference = new FileReference();
			fr.save(ba, filename);
		}
	}
}