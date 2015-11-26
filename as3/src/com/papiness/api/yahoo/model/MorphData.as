package com.papiness.api.yahoo.model 
{
	/**
	 * 形態素のデータ。
	 * @author daniwell
	 */
	public class MorphData 
	{
		/** 品詞 */
		public var pos      :String;
		/** 形態素の表記 */
		public var surface  :String;
		/** 形態素の原型 */
		public var baseform :String;
		
		/*  */
		public var count :int;
		
		
		public function MorphData() 
		{
			count = 0;
		}
	}
}