package com.papiness.api.twitter.model 
{
	/**
	 * 1 ツイート分のデータ
	 * @author daniwell
	 */
	public class TweetData 
	{
		/** ツイートID */
		public var id         :Number;
		/** ツイート本文 */
		public var text       :String;
		/** 生成時刻 */
		public var created_at :Date;
		
		public function TweetData() 
		{
			
		}
	}
}