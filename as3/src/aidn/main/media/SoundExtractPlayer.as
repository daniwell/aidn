package aidn.main.media 
{
	import aidn.main.util.MathSoundUtil;
	import flash.events.EventDispatcher;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.ByteArray;
	
	public class SoundExtractPlayer extends EventDispatcher
	{
		
		private const BUFFER_LENGTH :Number = 2048;
		
		
		private var _exSound :Sound;
		
		
		private var _sound   :Sound;
		private var _channel :SoundChannel;
		
		
		
		private var _ba    :ByteArray = new ByteArray();
		private var _speed :Number    = 1;
		
		private var _position :Number;
		private var _total    :Number;
		
		private var _pan      :Number = 0;
		private var _vol      :Number = 1;
		
		
		
		public function SoundExtractPlayer ( sound :Sound ) 
		{
			_exSound = sound;
			
			
			_sound   = new Sound();
			_channel = new SoundChannel();
		}
		
		
		// ------------------------------------------------------------------- public
		
		/**
		 * 再生。
		 * @param	startTime	開始位置(秒)。
		 */
		public function play ( startTime :Number = 0 ) :void
		{
			if (! _sound.hasEventListener(SampleDataEvent.SAMPLE_DATA))
				_sound.addEventListener(SampleDataEvent.SAMPLE_DATA, _sampleData);
			
			_position = MathSoundUtil.fromSecToPosition(startTime);
			_total    = _exSound.length * 44.1;
				
			_channel.stop();
			_channel = _sound.play();
		}
		/**
		 * 停止。
		 */
		public function stop ( ) :void
		{
			_sound.removeEventListener(SampleDataEvent.SAMPLE_DATA, _sampleData);
			
			_channel.stop();
		}
		
		
		// ------------------------------------------------------------------- Event
		
		/* SAMPLE DATA */
		private function _sampleData ( evt :SampleDataEvent ) :void 
		{
			_ba.clear();
			
			var left  :Number;
			var right :Number;
			
			var len :Number = int(BUFFER_LENGTH * _speed) + 16;
			var num :Number = _exSound.extract(_ba, len, _position);
			
			// 足りない時
			if (num < len) { len -= _ba.length / 8; _exSound.extract(_ba, len, 0); }
			
			
			for ( var c :int = 0; c < BUFFER_LENGTH; c ++ )
			{	
				_position += _speed;
				if (_total - 1 < _position)	_position = 0;
				
				_ba.position = int(c * _speed) * 8;
				
				try
				{	
					// left, right
					if ( 0 < _pan )	left  = _ba.readFloat() * _vol * (1 - _pan);
					else			left  = _ba.readFloat() * _vol;
					if ( _pan < 0 )	right = _ba.readFloat() * _vol * (1 + _pan);
					else			right = _ba.readFloat() * _vol;
				}
				catch ( e :* ) { trace(e); left = right = 0; }
				
				evt.data.writeFloat( left );
				evt.data.writeFloat( right );
			}
		}
		
		
		
		
		// ------------------------------------------------------------------- getter & setter
		/** 音量 */
		public function get volume ( ) :Number { return _vol;   }
		/** 左右パン */
		public function get pan    ( ) :Number { return _pan;   }
		/** 再生速度(今のところ 0 以上限定) */
		public function get speed  ( ) :Number { return _speed; }
		
		
		/** 現在時間 */
		public function get nowTime   ( ) :Number { return MathSoundUtil.fromPositionToSec(_position); }
		/** 合計時間 */
		public function get totalTime ( ) :Number { return _exSound.length / 1000; }
		
		
		public function set volume ( value :Number ) :void { _vol   = value; }
		public function set pan    ( value :Number ) :void { _pan   = value; }
		public function set speed  ( value :Number ) :void { if (value < 0) { value = 0; } _speed = value; }
		
	}

}