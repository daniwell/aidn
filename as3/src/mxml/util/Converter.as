package mxml.util 
{
	public class Converter 
	{
		private static var _hash :Object = {
			"C": 0,
			"D": 2,
			"E": 4,
			"F": 5,
			"G": 7,
			"A": 9,
			"B": 11
		}
		
		public static function getNoteNumber ( step :String, alter :int, octave :int ) :int
		{
			var n :int = int(_hash[step]) + alter + (octave + 1) * 12;
			return n;
		}
	}
}