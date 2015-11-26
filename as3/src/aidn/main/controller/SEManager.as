package aidn.main.controller 
{
	import aidn.main.media.SoundPlayer;
	import aidn.main.util.Linkage;
	
	public class SEManager 
	{
		private var _ses   :/*SoundPlayer*/Array;
		private var _total :int;
		
		private var _defaultVolume :Number;
		
		
		public function SEManager ( name :String = "SE", defaultVolume :Number = 1.0 ) 
		{
			_ses = [];
			_defaultVolume = defaultVolume;
			
			for (var i :int = 0; Linkage.hasDefinition(name + i); i ++)
				_ses[i] = new SoundPlayer(Linkage.getSound(name + i));
			
			_total = i;
			_defaultVolume = defaultVolume;
		}
		
		public function add ( name :String ) :int
		{
			if (! Linkage.hasDefinition(name)) return -1;
			_ses.push(new SoundPlayer(Linkage.getSound(name)));
			_total = _ses.length;
			
			return (_total - 1);
		}
		
		
		public function play ( n :int, volume :Number = -1 ) :void
		{
			if (n < 0 || _total <= n) return;
			
			_ses[n].play();
			if (volume < 0) _ses[n].volume = _defaultVolume;
			else			_ses[n].volume = volume;
		}
		
		public function stop ( n :int ) :void
		{
			if (n < 0 || _total <= n) return;
			_ses[n].stop();
		}
		
		public function stopAll ( ) :void
		{
			for (var i :int = 0; i < _total; i ++)
				_ses[i].stop();
		}
		
	}
}