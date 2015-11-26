package aidn.api.twitter.commands 
{
	import aidn.api.APIBaseCommand;
	import aidn.api.twitter.constant.TwitterMethod;
	import aidn.api.twitter.constant.TwitterPath;
	import aidn.api.twitter.model.TwitterData;
	import com.adobe.serialization.json.JSON;
	import flash.net.URLRequestMethod;
	
	
	public class TwitterSearchCommand extends APIBaseCommand
	{
		private var _twitterDatas :/*TwitterData*/Array;
		
		/**
		 * 
		 * @param	q
		 * @param	count
		 * @param	resultType		'mixed', 'recent' or 'popular'
		 */
		public function TwitterSearchCommand ( q :String, count :int =  10, resultType :String = "recent" ) 
		{
			super(TwitterPath.API_PATH, { method: TwitterMethod.SEARCH, q: q, count: count, result_type: resultType }, URLRequestMethod.POST);
		}
		
		override protected function _parseData ( ) :Boolean 
		{
			try {
				var json :Object = JSON.decode(data);
			} catch ( e :* ) {
				trace(this, "parse error");
				return false;
			}
			if (json.errors) return false;
			if (! json.statuses) return false;
			
			_twitterDatas = [];
			
			var l :int = int(json.statuses.length);
			for (var i :int = 0; i < l; i ++)
			{
				var td :TwitterData = new TwitterData(json.statuses[i]);
				_twitterDatas[i] = td;
			}
			
			return true;
		}
		
		public function get twitterDatas():Array/*TwitterData*/ { return _twitterDatas; }
	}

}