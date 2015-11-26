package aidn.main.controller 
{
	import aidn.main.core.StageReference;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	public class DragDropManager
	{
		private var _target :DisplayObjectContainer;
		
		private var _down :Function;
		private var _move :Function;
		private var _up   :Function;
		
		public function DragDropManager ( target :DisplayObjectContainer ) 
		{
			_target = target;
		}
		
		// ------------------------------------------------------------------- public
		
		public function init ( down :Function, move :Function, up :Function ) :DragDropManager
		{
			_down = down;
			_move = move;
			_up   = up;
			
			_target.addEventListener(MouseEvent.MOUSE_DOWN, _mouseDown);
			
			return this;
		}
		
		public function start ( ) :void
		{
			stop();
			start();
		}
		public function stop ( ) :void
		{
			_target.removeEventListener(MouseEvent.MOUSE_DOWN, _mouseDown);
			StageReference.stage.removeEventListener(MouseEvent.MOUSE_MOVE, _mouseMove);
			StageReference.stage.removeEventListener(MouseEvent.MOUSE_UP,   _mouseUp);
		}
		
		// ------------------------------------------------------------------- Event
		
		private function _mouseDown ( evt :MouseEvent ) :void 
		{
			_down();
			
			StageReference.stage.addEventListener(MouseEvent.MOUSE_MOVE, _mouseMove);
			StageReference.stage.addEventListener(MouseEvent.MOUSE_UP,   _mouseUp);
		}
		private function _mouseMove ( evt :MouseEvent ) :void 
		{
			_move();
		}
		private function _mouseUp ( evt :MouseEvent ) :void 
		{
			_up();
			
			StageReference.stage.removeEventListener(MouseEvent.MOUSE_MOVE, _mouseMove);
			StageReference.stage.removeEventListener(MouseEvent.MOUSE_UP,   _mouseUp);
		}
	}
}