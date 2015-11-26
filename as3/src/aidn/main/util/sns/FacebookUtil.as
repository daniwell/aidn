package aidn.main.util.sns 
{
	import flash.external.ExternalInterface;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.utils.escapeMultiByte;
	
	public class FacebookUtil
	{
		private static const url :String = "http://www.facebook.com/sharer.php";
		
		public static function broadcast ( shareUul :String, shareTitle :String = "", window :String = "_blank" ) :void
		{
			var u :String = escapeMultiByte( shareUul );
			var t :String = escapeMultiByte( shareTitle );
			
			var reqUrl :String = url + "?u=" + u;
			if (0 < t.length) reqUrl += "&t=" + t;
			
			if ( window == "_blank" )
			{
				if ( ExternalInterface.available )
				{
					try {
						ExternalInterface.call("window.open", reqUrl, "fb", "width=730, height=460, personalbar=0,toolbar=0,scrollbars=1,resizable=1");
					} catch ( e :* ) {
						navigateToURL( new URLRequest(reqUrl) );
					}
				}
				else
				{
					navigateToURL( new URLRequest(reqUrl) );
				}
			}
			else
			{
				navigateToURL( new URLRequest(reqUrl), "_self" );
			}
		}
	}
}