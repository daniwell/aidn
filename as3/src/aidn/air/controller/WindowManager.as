package aidn.air.controller 
{
	import aidn.air.display.CustomNativeWindow;
	import aidn.air.display.CustomNativeWindowInitOptions;
	
	public class WindowManager 
	{
		private var _windows :Object;
		private var _total   :int;
		
		public function WindowManager() 
		{
			_windows = {};
		}
		
		// ------------------------------------------------------------------- public
		
		public function generateWindow ( options :CustomNativeWindowInitOptions ) :CustomNativeWindow
		{
			var name :String = options.name;
			
			if (! hasWindow(name))
			{
				var cnw :CustomNativeWindow = new CustomNativeWindow(options);
				cnw.activate();
				
				_windows[name] = cnw;
				_total ++;
			}
			
			return _windows[name];
		}
		
		public function hasWindow ( name :String ) :Boolean
		{
			return (_windows[name] is CustomNativeWindow);
		}
		public function getWindow ( name :String ) :CustomNativeWindow
		{
			return _windows[name];
		}
		
		
		
		// ------------------------------------------------------------------- private
		
		// ------------------------------------------------------------------- Event		
		
		
	}

}