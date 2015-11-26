package aidn.air.display 
{
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowRenderMode;
	
	public class CustomNativeWindowInitOptions extends NativeWindowInitOptions
	{
		public var name :String = "";
		
		public function CustomNativeWindowInitOptions( name :String = "" ) 
		{
			this.name = name;
		}
		public function init ( maximizable :Boolean = true, minimizable :Boolean = true, resizable :Boolean = true, chrome :String = "standard", transparent :Boolean = false, type :String = "normal" ) :void
		{
			this.maximizable  = maximizable;
			this.minimizable  = minimizable;
			this.resizable    = resizable;
			this.systemChrome = chrome;
			this.transparent  = transparent;
			this.type         = type;
		}
		
	}
}