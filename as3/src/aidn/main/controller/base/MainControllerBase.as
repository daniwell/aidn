package aidn.main.controller.base 
{
	import aidn.main.controller.ViewManager;
	import aidn.main.view.base.ViewBase;
	import flash.display.DisplayObjectContainer;
	
	public class MainControllerBase 
	{
		protected var _viewManager :ViewManager;
		
		public function MainControllerBase ( ) 
		{
			_viewManager = new ViewManager();
		}
		
		public function initialize ( ) :void
		{
			
		}
		public function show ( id :int ) :void
		{
			_viewManager.show(id);
		}
		
		protected function _addView ( view :ViewBase, id :int, parent :DisplayObjectContainer = null ) :ViewBase
		{
			_viewManager.addView(view, id);
			if (parent) parent.addChild(view);
			return view;
		}
		
	}
}