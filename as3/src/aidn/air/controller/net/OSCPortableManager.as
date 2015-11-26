package aidn.air.controller.net 
{
	import aidn.air.events.CustomOSCEvent;
	import aidn.air.util.OSCUtil;
	import aidn.main.util.Debug;
	import flash.utils.ByteArray;
	import org.tuio.osc.OSCBundle;
	import org.tuio.osc.OSCMessage;
	
	
	/**
	 * @require http://code.google.com/p/tuio-as3/
	 * @require https://github.com/wouterverweirder/AIR-Mobile-UDP-Extension/blob/master/ane/UDPSocket.ane
	 */
	
	/** @eventType aidn.air.events.CustomOSCEvent.RECEIVED */
	[Event(name="oscReceived", type="aidn.air.events.CustomOSCEvent")] 
	
	
	public class OSCPortableManager extends UDPSocketPortableManager
	{
		public function OSCPortableManager ( ) 
		{
			
		}
		
		override public function init ( localIP :String, localPort :int ) :Boolean 
		{
			return super.init(localIP, localPort);
		}
		
		override public function sendOSCMessage ( message :OSCMessage, targetIP :String, targetPort :int ) :void 
		{
			Debug.log(this, "send:", message.address, message.arguments, targetIP, targetPort);
			this.send(message.getBytes(), targetIP, targetPort);
		}
		
		override protected function _dispatchDatagramSocketData ( data :ByteArray ) :void 
		{
			super._dispatchDatagramSocketData(data);
			
			var e :CustomOSCEvent = new CustomOSCEvent(CustomOSCEvent.RECEIVED);
			e.message = OSCUtil.getMessage(data);
			
			Debug.log("---------------------------- received");
			Debug.log("address:", e.message.address);
			Debug.log("arguments:", e.message.arguments);
			Debug.log("----------------------------");
			
			dispatchEvent(e);
		}
	}
}