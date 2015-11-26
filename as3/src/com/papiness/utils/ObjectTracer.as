package com.papiness.utils
{
	
	/**
	 * Ojbect の中身を trace します。
	 * @author daniwell
	 */
	public class ObjectTracer 
	{
		public static function traceObj ( obj :Object ) :String
		{
			var s :String = "-------------------- object\n";
			
			trace( obj );
			
			for (var key :String in obj )
			{
				s += "[" + key + "]: " + obj[key] + "\n";
			}
			
			trace(s);
			
			return s;
		}
		
	}
}