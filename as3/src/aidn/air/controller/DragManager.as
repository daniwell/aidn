package aidn.air.controller 
{
	import aidn.air.events.DragEvent;
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragManager;
	import flash.desktop.NativeDragOptions;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.NativeDragEvent;
	
	/** @eventType DragEvent.DRAG_ENTER_ALLOWED */
	[Event(name="dragEnterAllowed", type="aidn.air.events.DragEvent")]
	/** @eventType DragEvent.DRAG_ENTER_DENIED */
	[Event(name="dragEnterDenied",  type="aidn.air.events.DragEvent")]
	/** @eventType DragEvent.DRAG_DROP */
	[Event(name="dragDrop",         type="aidn.air.events.DragEvent")]
	
	
	public class DragManager extends EventDispatcher
	{
		private var _target       :InteractiveObject;
		private var _allowFormats :/*String*/Array;
		private var _allowTotal   :int;
		
		public function DragManager() 
		{
			
		}
		
		// ------------------------------------------------------------------- public
		
		public function init ( target :InteractiveObject, allowFormats :/*String*/Array = null ) :void
		{
			_target = target;
			_allowFormats = [];
			
			addAllowFormats(allowFormats);
			
			_target.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, _dragEnter);
			_target.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,  _dragDrop);
		}
		
		public function addAllowFormats ( clipboardFormats :/*String*/Array ) :void
		{
			if (clipboardFormats is Array)
			{
				_allowFormats = _allowFormats.concat(clipboardFormats);
				_allowTotal   = _allowFormats.length;
			}
		}
		
		// ------------------------------------------------------------------- Event
		
		private function _dragEnter ( evt :NativeDragEvent ) :void 
		{
			var e  :DragEvent;
			var cb :Clipboard = evt.clipboard;
			
			for (var i :int = 0; i < _allowTotal; i ++)
			{
				if (cb.hasFormat(_allowFormats[i]))
				{
					NativeDragManager.acceptDragDrop(_target);
					
					e = new DragEvent(DragEvent.DRAG_ENTER_ALLOWED);
					e.clipboard = new ClipboardManager(evt.clipboard);
					dispatchEvent(e);
					return;
				}
			}
			
			e = new DragEvent(DragEvent.DRAG_ENTER_DENIED);
			e.clipboard = new ClipboardManager(evt.clipboard);
			dispatchEvent(e);
		}
		private function _dragDrop ( evt :NativeDragEvent ) :void 
		{
			var e :DragEvent = new DragEvent(DragEvent.DRAG_DROP);
			e.clipboard = new ClipboardManager(evt.clipboard);
			dispatchEvent(e);
		}
		
	}
}