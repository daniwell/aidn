package aidn.main.util 
{
	import flash.external.ExternalInterface;
	import flash.system.Capabilities;
	
	public class GoogleAnalytics 
	{
		public static var id :String = "UA-27113912-1";	// default
		
		
		private static const FUNC_INIT  :String = "function(id){ window.PageTracker = _gat._getTracker(id); }";
		private static const FUNC_TRACK :String = "PageTracker._trackPageview";
		
		private static var _inited :Boolean = false;
		
		/** GA 計測 */
		public static function track ( value :String = "/" ) :void
		{
			if (! _inited) { try { ExternalInterface.call(FUNC_INIT, id); _inited = true; } catch ( e :* ) { }; }
			try { ExternalInterface.call(FUNC_TRACK, value); } catch ( e :* ) { };
		}
		
		/** Flash Player のバージョンを計測 */
		public static function trackPlayerVersion ( ) :void
		{
			if (! _inited) { try { ExternalInterface.call(FUNC_INIT, id); _inited = true; } catch ( e :* ) { }; }
			
			var s :String;
			var a :/*String*/Array = Capabilities.version.split(" ");
			
			if (2 <= a.length) s = a[1].split(",").join("_");
			
			if (s) {
				try { ExternalInterface.call(FUNC_TRACK, "/_fp/ver" + s); } catch ( e :* ) { };
			}
		}
	}
}