package com.papiness.api.twitter.model 
{
	
	/**
	 * Twitter の検索結果データ
	 * @author daniwell
	 */
	public class SearchData 
	{
		/** ツイートID */
		public var id         :String;
		/** ツイート本文 */
		public var text       :String;
		/** 生成時刻 */
		public var created_at :Date;
		/** アイコンURL */
		public var profile_image_url :String;
		
		
		/** 投稿ユーザー */
		//public var from_user    :String;	/////
		/** 投稿ユーザーID */
		//public var from_user_id :String;	/////
		/** 返信ユーザーID */
		//public var to_user_id   :String;	/////
		
		
		public var status_url :String;
		
		/* ユーザーネーム(半角英数_) */
		public var username :String;
		/* 名前(漢字かな混じり) */
		public var fullname :String;
		
		
		
		
		public function SearchData() 
		{
			
		}
		
	}
	
}