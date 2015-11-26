package aidn.air.util 
{
	import flash.utils.ByteArray;
	import org.tuio.osc.OSCBundle;
	import org.tuio.osc.OSCMessage;
	
	public class OSCUtil 
	{
		public static function cloneOSCMessage ( message :OSCMessage ) :OSCMessage
		{
			var m :OSCMessage = new OSCMessage();
			m.address = message.address;
			
			for (var i :int = 0; i < message.arguments.length; i ++)
			{
				if (message.arguments[i] is String)	m.addArgument("s", message.arguments[i]);
				else								m.addArgument("i", message.arguments[i]);
			}
			return m;
		}
		
		/// OSC MESSAGE
		public static function getMessage ( data :ByteArray ) :OSCMessage
		{
			var out  :String = new String();
			var char :String = new String();
			while(data.bytesAvailable > 0){ char = data.readUTFBytes(4); out += char; if(char.length < 4) break; }
			data.position = 0;
			
			if (0 <= out.indexOf("#bundle"))
			{
				var bundle :OSCBundle = new OSCBundle(data);
				return OSCMessage(bundle.subPackets[0]);
			}
			return new OSCMessage(data);
		}
		
	}
}