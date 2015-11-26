package aidn.main.util.crypt 
{
	import com.hurlant.crypto.Crypto;
	import com.hurlant.crypto.symmetric.ICipher;
	import com.hurlant.crypto.symmetric.IPad;
	import com.hurlant.crypto.symmetric.IVMode;
	import com.hurlant.crypto.symmetric.PKCS5;
	import com.hurlant.util.Base64;
	import com.hurlant.util.Hex;
	import flash.utils.ByteArray;
	
	public class BlowFish 
	{
		
		public function BlowFish() 
		{
			
		}
		
		public function encrypt ( s :String, k :String, r :Boolean = false ) :String 
		{
			var cipher :ICipher = _getCrypto(k);
			var data :ByteArray = Hex.toArray(Hex.fromString(s));
			
			cipher.encrypt(data);
			
			var result :String = Hex.fromArray(data);
			var ivmode :IVMode = cipher as IVMode;
			var iv     :String = Hex.fromArray(ivmode.IV);
			
			if (r) return iv + result;
			return result + iv;
		}
		
		public function decrypt ( s :String, k :String, r :Boolean = false ) :String
		{
			var l :int = s.length;
			var enc :String;
			var iv  :String;
			
			if (r)
			{
				enc = s.substring(16, l);
				iv  = s.substring(0, 16);
			}
			else
			{
				enc = s.substring(0, l - 16);
				iv  = s.substring(l - 16, l);
			}
			
			
			var cipher :ICipher = _getCrypto(k);
			
			var ivmode :IVMode = cipher as IVMode;
			ivmode.IV = Hex.toArray(iv);
			
			var ba :ByteArray = Hex.toArray(enc);
			cipher.decrypt(ba);
			
			return Hex.toString(Hex.fromArray(ba));
		}
		
		private function _getCrypto ( k :String ) :ICipher
		{
			var key  :ByteArray = Hex.toArray(k);
			
			var pad    :IPad = new PKCS5;
			var cipher :ICipher = Crypto.getCipher("blowfish-cbc", key, pad);
			
			pad.setBlockSize(cipher.getBlockSize());
			
			return cipher;
		}
	}
}