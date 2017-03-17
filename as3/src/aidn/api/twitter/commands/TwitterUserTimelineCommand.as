package aidn.api.twitter.commands 
{
	import aidn.api.APIBaseCommand;
	import aidn.api.twitter.constant.TwitterMethod;
	import aidn.api.twitter.constant.TwitterPath;
	import aidn.api.twitter.model.TwitterData;
	import com.adobe.serialization.json.JSON;
	import flash.net.URLRequestMethod;
	
	
	public class TwitterUserTimelineCommand extends APIBaseCommand
	{
		private var _twitterDatas :/*TwitterData*/Array;
		
		public function TwitterUserTimelineCommand ( screenName :String, count :int =  10 ) 
		{
			super(TwitterPath.API_PATH, { method: TwitterMethod.USER_TIMELINE, screen_name: screenName, count: count }, URLRequestMethod.POST);
		}
		
		override protected function _parseData ( ) :Boolean 
		{
			try {
				var json :Object = com.adobe.serialization.json.JSON.decode(data);
			} catch ( e :* ) {
				trace(this, "parse error");
				return false;
			}
			if (json.errors) return false;
			
			_twitterDatas = [];
			
			var l :int = int(json.length);
			for (var i :int = 0; i < l; i ++)
			{
				var td :TwitterData = new TwitterData(json[i]);
				_twitterDatas[i] = td;
			}
			
			return true;
		}
		
		public function get twitterDatas():Array/*TwitterData*/ { return _twitterDatas; }
	}
}