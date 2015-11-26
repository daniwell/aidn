package aidn.box2d.events 
{
	import Box2D.Collision.b2ContactPoint;
	import Box2D.Dynamics.Contacts.b2ContactResult;
	import flash.events.Event;
	
	public class ContactEvent extends Event
	{
		/* 衝突が起こったとき */
		public static const ADD     :String = "contactAdd";
		/* 衝突の計算が終わったあと */
		public static const RESULT  :String = "contactResult";
		/* 衝突してから離れるまで、定期的に */
		public static const PERSIST :String = "contactPersist";
		/* 衝突したオブジェクト同士が離れたとき */
		public static const REMOVE  :String = "contactRemove";
		
		public var point       :b2ContactPoint;
		public var pointResult :b2ContactResult;
		
		
		public function ContactEvent(type :String, bubbles :Boolean = false, cancelable :Boolean = false) 
		{
			super(type, bubbles, cancelable)
		}
		
		override public function clone ( ) :Event
		{
			var e :ContactEvent = new ContactEvent(type, bubbles, cancelable)
			e.point = point;
			e.pointResult = pointResult;
			return e;
		}
		
	}
}