package com.papiness.utils 
{
	import flash.text.Font;
	
	/**
	 * 
	 * @author daniwell
	 */
	public class FontUtil
	{
		/**
		 * インストールされているフォントの配列を取得します。
		 * @param	langType		0: すべて, 1: 英字のみ, 2: 日本語のみ
		 * @param	embedOnly		埋込みのみ取得するかどうか。
		 * @param	traceFontName	フォント名を標準出力するかどうか。
		 */
		public static function getFontList ( langType :uint = 0, embedOnly :Boolean = false, traceFontName :Boolean = false ) :/*Font*/Array
		{
			var list :/*Font*/Array = Font.enumerateFonts(!embedOnly);
			var retList :/*Font*/Array = new Array();
			
			var i :int;
			var l :uint = list.length;
			
			switch ( langType )
			{
			case 0:		/* All */
				retList = list;
				break;
			case 1:		/* En */
				for ( i = 0; i < l; i ++ )
					if ( list[i].fontName.replace(/[a-zA-Z0-9_\-\s]/g, "") == "" )
						retList.push( list[i] );
				break;
			case 2:		/* Jp */
				for ( i = 0; i < l; i ++ )
					if ( list[i].fontName.replace(/[a-zA-Z0-9_\-\s]/g, "") != "" )
						retList.push( list[i] );
				break;
			}
			
			if ( traceFontName ) _trace(retList);
			
			return retList;
		}
		
		private static function _trace ( list :/*Font*/Array ) :void
		{
			var i :int;
			var l :uint = list.length;
			
			for ( i = 0; i < l; i ++ )	trace( list[i].fontName );
		}
	}
}