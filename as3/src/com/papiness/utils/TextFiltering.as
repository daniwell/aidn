package com.papiness.utils 
{
	/**
	 * 文字のフィルタリングを行います。
	 * @author daniwell
	 */
	public class TextFiltering 
	{
		
		/**
		 * フィルタリングを行います。
		 * @param	word	調べるワード。
		 * @param	list	NGワードリスト。
		 * @param	index	true で部分一致、false で完全一致。
		 * @return
		 */
		public static function check ( word :String, list :/*String*/Array, index :Boolean = false ) :Boolean
		{
			return _check( word, list, index );
		}
		
		private static function _check ( word :String, arr :/*String*/Array, index :Boolean = false  ) :Boolean
		{
			var i :int;
			var l :int = arr.length;
			
			if ( ! index )	/* 完全一致 */
			{
				for ( i = 0; i < l; i ++ )
					if ( word == arr[i] ) return true;
			}
			else			/* 部分一致 */
			{
				for ( i = 0; i < l; i ++ )
					if ( word.indexOf( arr[i] ) != -1 ) return true;
			}
			return false;
		}
	}
}