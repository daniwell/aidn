package com.papiness.utils
{
	/**
	 * なんちゃって形態素解析を行います。
	 * @author daniwell
	 */
	public class Morphological 
	{
		// ------------------------------------------------------------------- public methods
		/**
		 * 名詞の形態素を取得します（おそらく）。
		 * @param	value		解析対象の文章。
		 * @param	minLength	最小文字数。
		 * @return
		 */
		public static function getNouns ( value :String, minLength :int = 1 ) :/*String*/Array
		{
			var a :Array = new Array();
			
			var tmp :Array = value.match(/[一-龠々〆ヵヶ]+|[ァ-ヴー]{2,20}|[a-zA-Z0-9]{2,20}|[ａ-ｚＡ-Ｚ０-９]{2,20}/g);
			var i :int;
			var l :int = tmp.length;
			
			for ( i = 1; i < l; i ++ )
			{
				if ( TextFiltering.check(tmp[i],_checkList) )  continue;
				if ( tmp[i].length < minLength ) continue;
				a.push( tmp[i] );
			}
			
			return a;
		}
		
		/**
		 * 形容詞などの連体形の形態素を取得します（おそらく）。
		 * @param	value		解析対象の文章。
		 * @return
		 */
		public static function getAdjectives ( value :String ) :/*String*/Array
		{
			var i :int, l :int;
			
			var reg1 :RegExp = /[一-龠々〆ヵヶァ-ヴー]([ぁ-ん]+[ないのうくすつぬふむゆる])(?:[一-龠々〆ヵヶァ-ヴー]+|もの|こと)/g;
			var reg2 :RegExp = /[,.、。 　]([ぁ-ん一-龠][ぁ-ん]*[ないのうくすつぬふむゆる])(?:[一-龠々〆ヵヶァ-ヴー]+|もの|こと)/g;
			
			var a1 :/*String*/Array;
			var a2 :/*String*/Array;
			
			var a :Array = new Array();
			var s :String;
			
			while ( a1 = reg1.exec(value) )
			{
				l = a1.length;
				for ( i = 1; i < l; i ++ )
				{
					s = a1[i].replace(/(する|でなければ|について|ならば|までを|までの|くらい|なのか|として|とは|なら|から|まで|して|だけ|より|ほど|など|って|では|は|で|を|の|が|に|へ|と|て|い)/, "");
					if ( 2 < s.length && ! TextFiltering.check(s,_checkList) ) a.push(s);
				}
			}
			
			while ( a2 = reg2.exec(value) )
			{
				l = a2.length;
				for ( i = 1; i < l; i ++ )
				{
					s = a2[i];
					if ( 1 < s.length && ! TextFiltering.check(s,_checkList) ) a.push(s);
				}
			}
			
			return a;
		}
		
		
		/* 除外リスト */
		private static const _checkList :/*String*/Array = 
		[
			"さす", "こと", "もの", "ある", "する", "ない",
			"よる", "なお", "ほど", "ほか", "つく", "ため",
			"ここ", "これ", "それ", "いう", "いる", "なる",
			"できる", "方", "いい", "中", "この", "やる",
			"え", "こちら",
			"gt", "br", "lt", "quot", "amp"
		];
		
	}
}