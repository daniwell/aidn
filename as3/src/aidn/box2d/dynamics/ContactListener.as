package aidn.box2d.dynamics 
{
	import aidn.box2d.Box2d;
	import aidn.box2d.events.ContactEvent;
	import Box2D.Collision.b2ContactPoint;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.Contacts.b2ContactResult;
	
	public class ContactListener extends b2ContactListener
	{
		
		private var _box2d :Box2d;
		
		public function ContactListener ( box2d :Box2d ) 
		{
			_box2d = box2d;
		}
		
		override public function Add ( point :b2ContactPoint ) :void 
		{
			var e :ContactEvent = new ContactEvent(ContactEvent.ADD);
			e.point = point;
			_box2d.dispatchEvent(e);
		}
		override public function Result ( point :b2ContactResult ) :void 
		{
			var e :ContactEvent = new ContactEvent(ContactEvent.RESULT);
			e.pointResult = point;
			_box2d.dispatchEvent(e);
		}
		override public function Persist ( point :b2ContactPoint ) :void 
		{
			var e :ContactEvent = new ContactEvent(ContactEvent.PERSIST);
			e.point = point;
			_box2d.dispatchEvent(e);
		}
		override public function Remove ( point:b2ContactPoint ) :void 
		{
			var e :ContactEvent = new ContactEvent(ContactEvent.REMOVE);
			e.point = point;
			_box2d.dispatchEvent(e);
		}
		
	}
}