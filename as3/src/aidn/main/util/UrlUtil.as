package aidn.main.util  
{
	import flash.external.ExternalInterface;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	public class UrlUtil 
	{
		
		public static function setTitle ( title :String ) :void
		{
			try {
				ExternalInterface.call("function(value){ document.title = value; }", title);
			} catch ( e :* ) { }
		}
		public static function setHash ( hash :String ) :void
		{
			try {
				ExternalInterface.call("function(value){ window.location.hash = value; }", hash);
			} catch ( e :* ) { }
		}
		public static function setHref ( href :String ) :void
		{
			try {
				ExternalInterface.call("function(value){ window.location.href = value; }", href);
			} catch ( e :* ) { }
		}
		
		public static function getHash ( ) :String
		{
			var s :String;
			
			try {
				s = ExternalInterface.call("function(){ return window.location.hash; }");
				if (! s) s = "";
			} catch ( e :* ) {
				s = "";
			}
			return s;
		}
		public static function getHref ( ) :String
		{
			var s :String = "";
			
			try {
				s = ExternalInterface.call("function(){ return window.location.href; }");
			} catch ( e :* ) { }
			return s;
		}
		
		/// URL からクエリーパラメータを取得
		public static function getParams ( sepa :String = "?" ) :Object
		{
			var obj :Object = { };
			
			var url :String = "";
			try {
				url = String( ExternalInterface.call("function(){ return window.location.href; }") );
			} catch ( e :* ) { }
			
			var tmp :Array = url.split(sepa);
			if (tmp.length < 2) return obj;
			
			var a :/*String*/Array = String(tmp[1]).split("&");
			for (var i :int = 0; i < a.length; i ++)
			{
				var k :/*String*/Array = a[i].split("=");
				if (k.length < 2) continue;
				
				var key    :String = k[0];
				var value  :String = k[1];
				obj[key] = value;
			}
			return obj;
		}
		
		public static function link ( url :String, blank :Boolean = false ) :void
		{
			if (blank)
			{
				var ua :String;
				
				try {
					ua = ExternalInterface.call("function(){ return navigator.userAgent; }");
				} catch ( e :* ) {
					ua = "";
				}
				
				if (ua.indexOf("MSIE") == -1)
					navigateToURL(new URLRequest(url), "_blank");
				else
					ExternalInterface.call('function(url){ window.open(url,"_blank"); }', url);
			}
			else
			{
				navigateToURL(new URLRequest(url), "_self");
			}
		}
		
		
	}
}