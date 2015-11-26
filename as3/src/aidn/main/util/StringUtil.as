package aidn.main.util 
{
	
	public class StringUtil 
	{
		
		public static function checkHiragana ( str :String ) :Boolean
		{
			return RegExp(/[ぁ-ん]/).test(str);
		}
		public static function checkKatakana ( str :String ) :Boolean
		{
			return RegExp(/[ァ-ン]/).test(str);
		}
		
		/** 桁揃え */
		public static function digits ( num :Number, d :int, c :String = "0" ) :String
		{
			var s :String = num.toString();
			var l :int = s.length;
			for (var i :int = l; i < d; i ++) s = c + s;
			return s;
		}
		
		/**
		 * 3桁区切り
		 * @param	n
		 * @return
		 */
		public static function separateNum ( n :Number ) :String
		{
			if (n < 1000) return String(n);
			
			
			var s :String = new String(n).replace(/,/g, ""); 
			
			var t :String = s;
			t = s.replace(/^(-?\d+)(\d{3})/, "$1,$2");
			
			while ( s != t )
			{
				s = t;
				t = s.replace(/^(-?\d+)(\d{3})/, "$1,$2");
			}
			return t; 
		}
	}
}