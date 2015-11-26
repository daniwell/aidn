package aidn.main.util 
{
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	
	public class SoundSpectram 
	{
		private static var _nlist :Array;
		private static var _len   :int;
		
		private static var _fftmode :Boolean;
		
		private static var _friction :Number;
		
		private static var _emin :Number;
		private static var _emax :Number;
		
		
		public static function init ( fftmode :Boolean = false, len :int = 512, friction :Number = 0.3, emin :Number = - 1.0, emax :Number = 1.0 ) :void
		{
			_fftmode = fftmode;
			
			_len  = len;
			_emin = emin;
			_emax = emax;
			
			_friction = friction;
			
			_nlist = [];
			for (var i :int = 0; i < _len; i ++) _nlist[i] = 0;
		}
		
		public static function update ( ) :/*Number*/Array
		{
			var i :int, n :Number;
			
			try
			{
				var ba :ByteArray = new ByteArray();
				SoundMixer.computeSpectrum(ba, _fftmode);
				
				for (i = 0; i < _len; i++)
				{
					n = ba.readFloat();
					_nlist[i] += (n - _nlist[i]) * _friction;
				}
			}
			catch ( e :* )
			{
				for (i = 0; i < _len; i++)
				{
					n = MathUtil.rand(_emin, _emax);
					_nlist[i] += (n - _nlist[i]) * _friction;
				}
			}
			
			return _nlist;
		}
		
		public static function get length () :int { return _len; }
	}
}