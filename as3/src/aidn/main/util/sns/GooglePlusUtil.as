package aidn.main.util.sns 
{
	import flash.external.ExternalInterface;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.utils.escapeMultiByte;
	public class GooglePlusUtil 
	{
		private static const PATH :String = "https://plus.google.com/share";
		
		public static function share ( url :String ) :void
		{
			var u :String = PATH + "?url=" + escapeMultiByte(url);
			
			if ( ExternalInterface.available )
			{
				try {
					ExternalInterface.call("window.open", u, "gp", "width=960, height=790, personalbar=0,toolbar=0,scrollbars=1,resizable=1");
				} catch ( e :* ) {
					navigateToURL( new URLRequest(u) );
				}
			}
			else navigateToURL( new URLRequest(u) );
		}
		
	}
}