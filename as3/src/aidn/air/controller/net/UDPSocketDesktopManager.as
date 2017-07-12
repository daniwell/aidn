package aidn.air.controller.net 
{
	import aidn.main.util.Debug;
	import flash.events.DatagramSocketDataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.DatagramSocket;
	import flash.utils.ByteArray;
	
	
	public class UDPSocketDesktopManager extends AbstractUDPSocketManager
	{
		private var _datagramSocket :DatagramSocket;
		
		public function UDPSocketDesktopManager() 
		{
			
		}
		
		// ------------------------------------------------------------------- public
		/* 初期化 & 受信待機 */
		override public function init ( localIP :String, localPort :int ) :Boolean
		{
			Debug.log(this, "INIT", localIP, localPort);
			
			_datagramSocket = new DatagramSocket();
			_datagramSocket.addEventListener(DatagramSocketDataEvent.DATA, _dataReceived);
			_datagramSocket.addEventListener(IOErrorEvent.IO_ERROR,        _dataError);
			_datagramSocket.addEventListener(Event.CLOSE,                  _dataClose);
			
			try {
				_datagramSocket.bind(localPort, localIP);
				_datagramSocket.receive();
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
				_datagramSocket.send(ba, 0, 0, targetIP, targetPort);
			} catch ( e :Error ) { Debug.log(this, "SEND ERROR:", e.message); }
		}
		
		/* 接続を閉じる */
		override public function close ( ) :void
		{
			try { _datagramSocket.close(); } catch ( e :Error ) { }
		}
		
		// ------------------------------------------------------------------- private
		
		private function _dataReceived ( evt :DatagramSocketDataEvent ) :void 
		{
			_dispatchDatagramSocketData(evt.data);
		}
		
		private function _dataError ( evt :IOErrorEvent ) :void 
		{
			Debug.log(this, "ERROR");
		}
		private function _dataClose(e:Event):void 
		{
			Debug.log(this, "CLOSE");
		}
		
	}
}