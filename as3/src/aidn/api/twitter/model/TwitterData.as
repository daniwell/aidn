package aidn.api.twitter.model 
{
	import aidn.api.twitter.util.TwitterDateUtil;
	public class TwitterData 
	{
		
		/// ユーザーID
		public var id         :String;
		/// 名前
		public var name       :String;
		/// スクリーン名
		public var screenName :String;
		/// アイコン画像URL
		public var icon       :String;
		
		/// ツイートID
		public var tweetId    :String;
		
		/// 本文
		public var text :String;
		/// 投稿日時
		public var datePost    :Date;
		/// アカウント作成日時
		public var dateAccount :Date;
		
		/// フォロー数
		public var numFriends   :int;
		/// フォロワー数
		public var numFollowers :int;
		/// ツイート数
		public var numStatuses  :int;
		
		public function TwitterData ( obj :Object ) 
		{
			if (! obj) return;
			
			id         = obj.user.id;
			name       = obj.user.name;
			screenName = obj.user.screen_name;
			icon       = obj.user.profile_image_url;
			
			tweetId    = obj.id_str;
			
			text        = obj.text;
			datePost    = TwitterDateUtil.getDate(obj.created_at);
			dateAccount = TwitterDateUtil.getDate(obj.user.created_at);
			
			numFriends   = int(obj.user.friends_count);
			numFollowers = int(obj.user.followers_count);
			numStatuses  = int(obj.user.statuses_count);
		}
		
		public function toString ( ) :String
		{
			var s :String = "---------------------------------------------- [TwitterData]\n";
			s +=           "id:" + id           + "\n";
			s +=         "name:" + name         + "\n";
			s +=   "screenName:" + screenName   + "\n";
			s +=         "icon:" + icon         + "\n";
			s +=         "text:" + text         + "\n";
			s +=     "datePost:" + datePost     + "\n";
			s +=  "dateAccount:" + dateAccount  + "\n";
			s +=   "numFriends:" + numFriends   + "\n";
			s += "numFollowers:" + numFollowers + "\n";
			s +=  "numStatuses:" + numStatuses;
			
			return s;
		}
		
	}
}