package com.papiness.api.twitter.model 
{
	/**
	 * Twitter のユーザーステータス
	 * @author daniwell
	 */
	public class UserStatus 
	{
		/** id */
		public var screen_name       :String;
		/** 名前 */
		public var name              :String;
		/** 現在地 */
		public var location          :String;
		/** Web */
		public var url               :String;
		/** 自己紹介 */
		public var description       :String;
		/** アイコンURL */
		public var profile_image_url :String;
		/** フォローしている数 */
		public var friends_count     :int;
		/** フォローされている数 */
		public var followers_count   :int;
		/** お気に入り数 */
		public var favourites_count  :int;
		/** ツイート数 */
		public var statuses_count    :int;
		/** (自分が)フォローしているか */
		public var following         :Boolean;
		
		
		public function UserStatus() 
		{
			
		}	
	}
}