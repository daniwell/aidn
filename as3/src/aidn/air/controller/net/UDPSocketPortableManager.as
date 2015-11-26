package aidn.air.controller.net 
{
	import aidn.main.util.Debug;
	import be.aboutme.nativeExtensions.udp.UDPSocket;
	import flash.events.DatagramSocketDataEvent;
	import flash.utils.ByteArray;
	import org.tuio.osc.OSCMessage;
	
	/**
	 * @require http://code.google.com/p/tuio-as3/
	 * @require https://github.com/wouterverweirder/AIR-Mobile-UDP-Extension/blob/master/ane/UDPSocket.ane
	 * 
	 * 
	 * -------------
	 * Memo for FlashDevelop
	 * 
	 * [bat/Packager.bat]
	 * call adt -package ...(略)... -extdir lib/ane/
	 * 
	 * [application.xml]
	 * <supportedProfiles>mobileDevice extendedMobileDevice</supportedProfiles>
	 * <extensions>
	 * 	<extensionID>be.aboutme.nativeExtensions.udp.UDPSocket</extensionID>
	 * </extensions>
	 * 
	 * <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
	 * <uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>
	 */
	
	public class UDPSocketPortableManager extends AbstractUDPSocketManager
	{
		private var _udpSocket :UDPSocket;
		
		
		public function UDPSocketPortableManager ( ) 
		{
			
		}
		
		// ------------------------------------------------------------------- public
		/* 初期化 & 受信待機 */
		override public function init ( localIP :String, localPort :int ) :Boolean
		{
			Debug.log(this, "INIT", localIP, localPort);
			
			_udpSocket = new UDPSocket();
			_udpSocket.addEventListener(DatagramSocketDataEvent.DATA, _udpDataHandler);
			
			try {
				_udpSocket.bind(localPort, localIP);
				_udpSocket.receive();
				return true;
			} catch ( e :Error ) {
				Debug.log(this, "INIT ERROR:", e.message);
			}
			return false;
		}
		
		/* 送信 */
		override public function send ( ba :ByteArray, targetIP :String, targetPort :int ) :void
		{
			try {
				_udpSocket.send(ba, targetIP, targetPort);
			} catch ( e :Error ) { Debug.log(this, "SEND ERROR:", e.message); }
		}
		
		/* 接続を閉じる */
		override public function close ( ) :void
		{
			try { _udpSocket.close(); } catch ( e :Error ) { }
		}
		
		// ------------------------------------------------------------------- private
		
		private function _udpDataHandler ( evt :DatagramSocketDataEvent ) :void 
		{
			_dispatchDatagramSocketData(evt.data);
		}
		
	}
}