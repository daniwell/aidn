package aidn.main.controller 
{
	import aidn.main.media.SoundPlayer;
	import aidn.main.util.Linkage;
	import aidn.tweener.core.Tween;
	
	public class BGMManager 
	{
		private var _bgms   :/*SoundPlayer*/Array;
		private var _total :int;
		
		private var _defaultVolume :Number;
		
		private var _now :int;
		
		
		public function BGMManager ( name :String = "BGM", defaultVolume :Number = 1.0 ) 
		{
			_bgms = [];
			_defaultVolume = defaultVolume;
			
			for (var i :int = 0; Linkage.hasDefinition(name + i); i ++)
				_bgms[i] = new SoundPlayer(Linkage.getSound(name + i));
			
			_total = i;
			_defaultVolume = defaultVolume;
			
			_now = -1;
		}
		
		public function add ( name :String ) :int
		{
			if (! Linkage.hasDefinition(name)) return -1;
			_bgms.push(new SoundPlayer(Linkage.getSound(name)));
			_total = _bgms.length;
			
			return (_total - 1);
		}
		
		public function play ( n :int, volume :Number = -1, loops :int = 0, fadeTime :Number = 0.0, delay :Number = 0.0 ) :void
		{
			if (_now == n) return;
			
			stop(_now, fadeTime);
			
			if (n < 0 || _total <= n) return;
			
			if (volume < 0) volume = _defaultVolume;
			_bgms[n].volume = 0
			
			Tween.remove(_bgms[n]);
			Tween.add(_bgms[n], { volume: volume }, fadeTime, "linear", delay);
			
			_bgms[n].play(0, loops);
			_now = n;
		}
		
		public function stop ( n :int, fadeTime :Number = 0.0 ) :void
		{
			if (n < 0 || _total <= n) return;
			
			if (0 < fadeTime)
			{
				Tween.remove(_bgms[n]);
				Tween.add(_bgms[n], { volume: 0 }, fadeTime, "linear", 0, _bgms[n].stop);
			}
			else _bgms[n].stop();
			_now = -1;
		}
		
		public function stopAll ( fadeTime :Number = 0.0 ) :void
		{
			for (var i :int = 0; i < _total; i ++) stop(i, fadeTime);
		}
		
		/// 現在再生中
		public function get now ( ) :int { return _now; }
		
	}
}