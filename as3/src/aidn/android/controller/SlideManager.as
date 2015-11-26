package aidn.android.controller 
{
	import aidn.android.events.SlideEvent;
	import aidn.main.core.StageReference;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	/** @eventType SlideEvent.UPDATE */
	[Event(name="slideUpdate",   type="aidn.android.events.SlideEvent")]
	
	public class SlideManager extends EventDispatcher
	{
		
		private var _container :Sprite;
		private var _mask      :Sprite;
		
		private var _target :DisplayObjectContainer;
		
		
		private var _diffW :int;
		private var _diffH :int;
		
		private var _downX :Number;
		private var _downY :Number;
		
		private var _tX :Number;
		private var _tY :Number;
		
		private var _sw :int;
		private var _sh :int;
		
		public function SlideManager() 
		{
			
		}
		
		// ------------------------------------------------------------------- public
		
		public function init ( target :DisplayObjectContainer, sw :int, sh :int ) :void
		{
			_target = target;
			
			if (! _target.parent) { trace(this, "Error: target.parent is undefined."); return; };
			
			// target, container
			_container = new Sprite();
			_target.parent.addChild(_container);
			
			_container.x = _target.x;
			_container.y = _target.y;
			_target.x = _target.y = 0;
			
			_container.addChild(_target);
			
			// mask
			_mask = new Sprite();
			_container.addChild(_mask);
			_target.mask = _mask;
			
			// update
			update(sw, sh);
			
			// MOUSE_DOWN
			_container.addEventListener(MouseEvent.MOUSE_DOWN, _mouseDown);
		}
		
		public function update ( sw :int = -1, sh :int = -1 ) :void
		{
			if (0 < sw) _sw = sw;
			if (0 < sh) _sh = sh;
			
			_mask.graphics.clear();
			_mask.graphics.beginFill(0);
			_mask.graphics.drawRect(0, 0, _sw, _sh);
			
			_container.graphics.clear();
			_container.graphics.beginFill(0, 0);
			_container.graphics.drawRect(0, 0, _sw, _sh);
			
			_diffW = _target.width  - _sw; if (_diffW < 0) _diffW = 0;
			_diffH = _target.height - _sh; if (_diffH < 0) _diffH = 0;
		}
		
		public function resetPosition ( eventDispatched :Boolean = false ) :void
		{
			_target.x = 0;
			_target.y = 0;
			
			if (eventDispatched)
			{
				// SlideEvent.UPDATE
				var e :SlideEvent = new SlideEvent(SlideEvent.UPDATE);
				e.percentX = e.percentY = 0;
				dispatchEvent(e);
			}
		}
		
		
		// ------------------------------------------------------------------- Event
		/* MOUSE DOWN */
		private function _mouseDown ( evt :MouseEvent ) :void 
		{
			_tX = _target.x;
			_tY = _target.y;
			
			_downX = _container.mouseX;
			_downY = _container.mouseY;
			
			StageReference.addEventListener(MouseEvent.MOUSE_MOVE, _mouseMove);
			StageReference.addEventListener(MouseEvent.MOUSE_UP,   _mouseUp);
		}
		/* MOUSE MOVE */
		private function _mouseMove ( evt :MouseEvent ) :void 
		{
			_updatePosition();
		}
		/* MOUSE UP */
		private function _mouseUp ( evt :MouseEvent ) :void 
		{
			_updatePosition();
			
			StageReference.removeEventListener(MouseEvent.MOUSE_MOVE, _mouseMove);
			StageReference.removeEventListener(MouseEvent.MOUSE_UP,   _mouseUp);
		}
		
		private function _updatePosition ( ) :void
		{
			var dx :Number = _container.mouseX - _downX;
			var dy :Number = _container.mouseY - _downY;
			
			var px :Number = _tX + dx;
			var py :Number = _tY + dy;
			if (0 < px) px = 0; else if (px < -_diffW) px = -_diffW;
			if (0 < py) py = 0; else if (py < -_diffH) py = -_diffH;
			
			_target.x = px;
			_target.y = py;
			
			
			// SlideEvent.UPDATE
			var e :SlideEvent = new SlideEvent(SlideEvent.UPDATE);
			if (_diffW != 0) e.percentX = _percentX = - px / _diffW; else e.percentX = 0;
			if (_diffH != 0) e.percentY = _percentY = - py / _diffH; else e.percentY = 0;
			dispatchEvent(e);
		}
		
		private var _percentX :Number = 0;
		private var _percentY :Number = 0;
		
		// ------------------------------------------------------------------- getter & setter
		
		public function get target    ( ) :DisplayObjectContainer { return _target; }
		public function get container ( ) :Sprite                 { return _container; }
		
		public function get x ( ) :Number { return _container.x; }
		public function get y ( ) :Number { return _container.y; }
		public function set x ( value :Number ) :void { _container.x = value; }
		public function set y ( value :Number ) :void { _container.y = value; }
		
		public function get percentX ( ) :Number { return _percentX; }
		public function get percentY ( ) :Number { return _percentY; }
		
		public function get diffW ( ) :Number { return _diffW; }
		public function get diffH ( ) :Number { return _diffH; }
	}
}