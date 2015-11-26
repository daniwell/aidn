package aidn.main.controller 
{
	import aidn.main.events.ViewEvent;
	import aidn.main.view.base.ViewBase;
	
	public class ViewManager 
	{
		private var _prevState :int;
		private var  _nowState :int;
		
		private var _viewList :/*ViewBase*/Array;
		
		public function ViewManager() 
		{
			_viewList = [];
			_nowState = _prevState = - 1;
		}
		
		public function addView ( view :ViewBase, id :int ) :void
		{
			_viewList[id] = view;
			view.addEventListener(ViewEvent.HIDE_COMPLETE, _hideComplete);
		}
		public function removeView ( view :ViewBase ) :void
		{
			var l :int = _viewList.length;
			for (var i :int = 0; i < l; i ++)
			{
				if (_viewList[i] == view)
				{
					view.removeEventListener(ViewEvent.HIDE_COMPLETE, _hideComplete);
					_viewList[i] = null;
					break;
				}
			}
		}
		
		public function show ( id :int ) :void
		{
			_prevState = _nowState;
			_nowState  = id;
			
			_hideStart();
		}
		public function hide ( ) :void
		{
			show(-1);
		}
		
		// ------------------------------------------------------------------- private
		private function _hideStart ( ) :void
		{
			if (0 <= _prevState && _viewList[_prevState])	_viewList[_prevState].hide();
			else											_showStart();
		}
		private function _showStart ( ) :void
		{
			if (0 <= _nowState && _viewList[_nowState])	_viewList[_nowState].show();
		}
		
		// ------------------------------------------------------------------- Event
		
		private function _hideComplete ( evt :ViewEvent ) :void 
		{
			_showStart();
		}
		
		public function get nowState  () :int { return _nowState;  }
		public function get prevState () :int { return _prevState; }
		
	}
}