package com.papiness.api.twitter.utils 
{
	import flash.utils.ByteArray;
	
	public class GIFAnimEncoder 
	{
		/**
		 * GIFアニメーションのバイト列を Twitter のアイコンで使用できるように末尾を書き換えます。
		 * @param	bytes	バイト列。
		 * @return
		 */
		public static function encodeBytes ( bytes :ByteArray ) :ByteArray
		{
			var ba :ByteArray = bytes;
			ba.position = ba.length - 1;
			ba.writeShort(0x3c2c);
			
			return ba;
		}
	}
}