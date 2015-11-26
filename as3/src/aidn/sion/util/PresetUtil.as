package aidn.sion.util 
{
	import org.si.sion.SiONVoice;
	import org.si.sion.utils.SiONPresetVoice;
	
	public class PresetUtil 
	{
		private static var _preset :SiONPresetVoice;
		
		public static function init ( includeFlag :int = 0xffff ) :void
		{
			_preset = new SiONPresetVoice(includeFlag);
		}
		public static function getVoice ( name :String ) :SiONVoice
		{
			return _preset[name];
		}
	}
}