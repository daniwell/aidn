package aidn.android.controller 
{
	import aidn.android.display.base.RadioButtonBase;
	import aidn.android.events.RadioButtonEvent;
	import aidn.main.events.DisplayEvent;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	/** @eventType RadioButtonEvent.CHANGE */
	[Event(name="radioButtonChange",   type="aidn.android.events.RadioButtonEvent")]
	
	
	public class RadioButtonManager extends EventDispatcher
	{
		private var _list :/*RadioButtonBase*/Array;
		
		public function RadioButtonManager() 
		{
			_list = [];
		}
		
		public function add ( rbb :RadioButtonBase, id :int ) :void
		{
			_list[id] = rbb;
			rbb.id = id;
			rbb.setClickEvent(_clickButton);
		}
		
		public function setSelected ( id :int, eventDispatched :Boolean = false ) :void
		{
			var l :int = _list.length;
			for (var i :int = 0; i < l; i ++)
			{
				if (_list[i] is RadioButtonBase)
				{
					if (i != id)	_list[i].selected = false;
					else			_list[i].selected = true;
				}
			}
			
			if (eventDispatched)
			{
				// RadioButtonEvent.CHANGE
				var e :RadioButtonEvent = new RadioButtonEvent(RadioButtonEvent.CHANGE);
				e.id = id;
				dispatchEvent(e);	
			}
		}
		
		/* CLICK */
		private function _clickButton ( evt :DisplayEvent ) :void
		{
			var rbb :RadioButtonBase = evt.self as RadioButtonBase;
			setSelected(rbb.id, true);
		}
		
	}
}