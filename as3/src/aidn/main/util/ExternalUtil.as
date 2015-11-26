package aidn.main.util 
{
	import flash.external.ExternalInterface;
	import flash.system.Capabilities;
	
	public class ExternalUtil 
	{
		
		public static function getLangage ( def :String = "ja", useJs :Boolean = false ) :String
		{
			var s :String = "";
			
			if (useJs)
			{
				try {
					s = ExternalInterface.call("function(){ var lng = (navigator.browserLanguage || navigator.language || navigator.userLanguage).substr(0,2); return lng; }");
				} catch ( e :* ) {
					s = def;
				}
			}
			else
			{
				s = Capabilities.language;
			}
			
			return s;
		}
		
		public static function isJapan ( def :String = "ja", useJs :Boolean = false ) :Boolean
		{
			return (getLangage(def, useJs).toLowerCase() == "ja");
		}
		
		
		
		public static function fullscreen ( ) :void
		{
			try {
				ExternalInterface.call("aidn.util.fullscreen", "container");
			} catch ( e:* ) { }
		}
		
		public static function enabledFullscreen ( ) :Boolean
		{
			try {
				return ExternalInterface.call("aidn.util.enabledFullscreen", true);
			} catch ( e:* ) { }
			return false;
		}
		
	}
}