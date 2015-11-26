package aidn.main.util.sns 
{
	import flash.external.ExternalInterface;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.utils.escapeMultiByte;
	
	public class TwitterUtil
	{
		private static const PATH :String = "https://twitter.com/intent/tweet?"		// "http://twitter.com/share?";
		
		/**
		 * 
		 * @param	text		本文。
		 * @param	url			ツイートするURL。
		 * @param	related		ツイート完了後に表示するユーザー。半角カンマ(,)区切り。
		 * @param	counturl	カウントするURL。通常はナシでよい。
		 * @param	via
		 * @param	param
		 */
		public static function doTweet ( text :String, url :String = null, related :String = null, counturl :String = null, via :String = null, param :Object = null ) :void
		{
			var u :String = PATH + "text="  + escapeMultiByte(text);
			if (url)      u += "&url="      + escapeMultiByte(url);
			if (related)  u += "&related="  + related;
			if (counturl) u += "&counturl=" + escapeMultiByte(counturl);
			if (via)      u += "&via="      + via;
			
			if (param)
			{
				for (var key :String in param)
				{
					u += "&" + key + "=" + escapeMultiByte(param[key]);
				}
			}
			
			if ( ExternalInterface.available )
			{
				try {
					ExternalInterface.call("window.open", u, "tw", "width=730, height=460, personalbar=0,toolbar=0,scrollbars=1,resizable=1");
				} catch ( e :* ) {
					navigateToURL( new URLRequest(u) );
				}
			}
			else navigateToURL( new URLRequest(u) );
		}
	}
}