package com.papiness.api.twitter.utils   
{
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.utils.escapeMultiByte;
	import flash.net.navigateToURL;
	
	/**
	 * 
	 * @author daniwell
	 */
	public class TwitterUtil 
	{
		private static var url :String = "http://twitter.com/home?status=";
		
		
		/**
		 * ツイートします。
		 * @param	text	テキスト。
		 * @param	blank	別ウィンドウで開くかどうかのフラグ。
		 */
		public static function tweet ( text :String, blank :Boolean = false ) :void
		{
			var s :String = escapeMultiByte( text );
			
			if ( blank )
			{
				if ( ExternalInterface.available )	ExternalInterface.call("window.open", url + s);
				else								navigateToURL( new URLRequest(url + s) );
			}
			else
			{
				navigateToURL( new URLRequest(url + s), "_self" );
			}
		}
	}
}