package aidn.air.display 
{
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	
	public class CustomNativeWindow extends NativeWindow
	{
		private var _name    :String;
		private var _options :CustomNativeWindowInitOptions;
		
		public function CustomNativeWindow ( options :CustomNativeWindowInitOptions ) 
		{
			super(options);
			
			_name    = options.name;
			_options = options;
		}
		
		// ------------------------------------------------------------------- public
		
		
		// ------------------------------------------------------------------- getter
		
		public function get name    ( ) :String {	return _name; }
		public function get options ( ) :CustomNativeWindowInitOptions { return _options; }
		
		
	}
}