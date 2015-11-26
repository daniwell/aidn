package aidn.air.util 
{
	import aidn.main.util.Debug;
	import flash.net.InterfaceAddress;
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;
	
	public class NetworkUtil 
	{
		/**
		 * IPアドレス を取得します。
		 * @param	ipVersion	IPアドレスの種類(IPv4,IPv6)
		 * @return
		 */
		public static function getIPAddress ( ipVersion :String = "IPv4" ) :String
		{
			var ia :InterfaceAddress = getInterfaceAddress(ipVersion);
			if (ia) return ia.address;
			return null;
		}
		
		/**
		 * ブロードキャストアドレス を取得します。
		 * @param	ipVersion	IPアドレスの種類(IPv4,IPv6)
		 * @return
		 */
		public static function getBroadcastAddress ( ipVersion :String = "IPv4" ) :String
		{
			var ia :InterfaceAddress = getInterfaceAddress(ipVersion);
			if (ia) return ia.broadcast;
			return null;
		}
		
		
		/**
		 * InterfaceAddress を取得します。
		 * @param	ipVersion	IPアドレスの種類(IPv4,IPv6)
		 * @return
		 */
		public static function getInterfaceAddress ( ipVersion :String = "IPv4" ) :InterfaceAddress
		{
			var i :int;
			
			if (! NetworkInfo.isSupported)
			{
				Debug.log("[NetworkUtil] NetworkInfo is not supported.");
				return null;
			}
			
			var interfaces       :Vector.<NetworkInterface> = NetworkInfo.networkInfo.findInterfaces();
			var currentInterface :NetworkInterface;
			
			for (i = 0; i < interfaces.length; i++)
			{
				var networkInterface :NetworkInterface = interfaces[i];
				if (networkInterface.active)
				{
					currentInterface = networkInterface;
					break;
				}
			}
			
			if (currentInterface)
			{
				var addresses :Vector.<InterfaceAddress> = currentInterface.addresses;
				
				for (i = 0; i < addresses.length; i++)
				{
					var interfaceAddress :InterfaceAddress = addresses[i];
					if(interfaceAddress.ipVersion == ipVersion) return interfaceAddress;
				}
			}
			
			Debug.log("[NetworkUtil] IP Address is NULL");
			return null;
		}
		
		
		/// Debug.log Interfaces Infomation
		public static function findInterface ( ) :void
		{
			var results:Vector.<NetworkInterface> = NetworkInfo.networkInfo.findInterfaces();
			
			var output :String = "";
			
			for (var i:int = 0; i < results.length; i++)
			{
				output = output + "Name: " + results[i].name + "\n" + "DisplayName: " + results[i].displayName + "\n" + "MTU: " + results[i].mtu + "\n" + "HardwareAddr: " + results[i].hardwareAddress + "\n" + "Active: " + results[i].active + "\n";
				for (var j:int = 0; j < results[i].addresses.length; j++)
				{
					output = output + "Addr: " + results[i].addresses[j].address + "\n" + "Broadcast: " + results[i].addresses[j].broadcast + "\n" + "PrefixLength: " + results[i].addresses[j].prefixLength + "\n" + "IPVersion: " + results[i].addresses[j].ipVersion + "\n";
				}
				output = output + "\n";
			}
			
			Debug.log(output);
		}
		
	}
}