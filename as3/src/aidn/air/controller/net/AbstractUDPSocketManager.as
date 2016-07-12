package aidn.air.controller.net 
{
	import aidn.main.util.Debug;
	import flash.events.DatagramSocketDataEvent;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	//import org.tuio.osc.OSCMessage;
	
	/**
	 * @require http://code.google.com/p/tuio-as3/
	 */
	
	/** @eventType flash.events.DatagramSocketDataEvent.DATA */
	[Event(name="data", type="flash.events.DatagramSocketDataEvent")] 
	
	
	public class AbstractUDPSocketManager extends EventDispatcher
	{
		public function AbstractUDPSocketManager () { }
		
		// ------------------------------------------------------------------- public
		/* 初期化 & 受信待機 */
		public function init ( localIP :String, localPort :int ) :Boolean
		{
			return false;
		}
		
		/* 送信 */
		public function send ( ba :ByteArray, targetIP :String, targetPort :int ) :void
		{
			
		}
		/* 送信 (OSCMessage) */
		/*
		public function sendOSCMessage ( message :OSCMessage, targetIP :String, targetPort :int ) :void
		{
			Debug.log(this, "Method 'sendOSCMessage' is not used.");
		}
		*/
		
		
		/* 接続を閉じる */
		public function close ( ) :void
		{
			
		}
		
		// ------------------------------------------------------------------- protected
		///
		protected function _dispatchDatagramSocketData ( data :ByteArray ) :void
		{
			var e :DatagramSocketDataEvent = new DatagramSocketDataEvent(DatagramSocketDataEvent.DATA);
			e.data = data;
			dispatchEvent(e);
		}
	}
}