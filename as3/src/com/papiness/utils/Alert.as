package com.papiness.utils
{
	import flash.external.ExternalInterface;
	
	/**
	 * JavaScript の alert を用いて任意の値を表示します（ブラウザ上でのチェック用）。
	 * @author daniwell
	 */
	public class Alert 
	{	
		/**
		 * alert を実行します。
		 * @param	value		alert で表示する内容。
		 * @param	traceFlag	出力ウィンドウに出力するかどうか。
		 */
		public static function show ( value :*, traceFlag :Boolean = false ) :void
		{
			var s :String = new String();
			
			if ( value is Array )
			{
				var a :Array = value;
				var l :int = a.length;
				
				for ( var i :int = 0; i < l; i ++ )
					s += a[i].toString() + " ";
			}
			else
				s = value.toString();
			
			if ( traceFlag ) trace( value );
			
			ExternalInterface.call("alert", s);
		}
	}
}