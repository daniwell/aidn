package aidn.air.core 
{
	import flash.desktop.NativeApplication;
	import flash.display.NativeWindow;
	import flash.display.Stage;
	
	public class AirReference 
	{
		private static var _stage             :Stage;
		private static var _nativeWindow      :NativeWindow;
		private static var _nativeApplication :NativeApplication;
		
		// ------------------------------------------------------------------- public
		
		public static function init ( stage :Stage ) :void
		{
			_stage = stage;
			_nativeWindow      = stage.nativeWindow;
			_nativeApplication = NativeApplication.nativeApplication;
			
			// _nativeWindow.addEventListener
			// _nativeApplication.addEventListener
		}
		
		/* アプリケーションの終了 */
		public static function exit ( ) :void
		{
			_nativeApplication.exit();
		}
		
		
		// ------------------------------------------------------------------- getter
		
		public static function get window      ( ) :NativeWindow      { return _nativeWindow; }
		public static function get application ( ) :NativeApplication { return _nativeApplication; }
		
	}
}