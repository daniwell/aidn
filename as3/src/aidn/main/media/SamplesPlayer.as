package aidn.main.media 
{
	import aidn.main.events.SamplesEvent;
	import aidn.main.util.MathSoundUtil;
	import flash.events.EventDispatcher;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.ByteArray;
	
	/** @eventType SamplesEvent.SOUND_COMPLETE */
	[Event(name="soundComplete",   type="aidn.main.events.SamplesEvent")]
	
	
	public class SamplesPlayer extends EventDispatcher
	{
		private const BUFFER_LENGTH :Number = 2048;
		
		
		private var _samples :ByteArray;
		
		private var _sound   :Sound;
		private var _channel :SoundChannel;
		
		private var _total    :Number;
		private var _position :Number;
		
		private var _totalTime :Number;
		
		private var _pan :Number = 0;
		private var _vol :Number = 1;
		
		private var _loopCount :int;
		private var _loopTotal :int;
		
		private var _speed :Number = 1;
		
		
		public function SamplesPlayer ( samples :ByteArray ) 
		{
			_samples = samples;
			_total   = _samples.length / 8;
			
			_totalTime = MathSoundUtil.fromPositionToSec(_total);
			
			_sound   = new Sound();
			_channel = new SoundChannel();
		}
		
		// ------------------------------------------------------------------- public
		
		/**
		 * 再生。
		 * @param	startTime	開始位置(秒)。
		 * @param	loops		ループ回数。
		 */
		public function play ( startTime :Number = 0, loops :int = 0 ) :void
		{
			if (! _sound.hasEventListener(SampleDataEvent.SAMPLE_DATA))
				_sound.addEventListener(SampleDataEvent.SAMPLE_DATA, _sampleData);
			
			// 秒 -> ポジション値
			_position = MathSoundUtil.fromSecToPosition(startTime);
			
			_loopCount = 0;
			_loopTotal = loops;
			
			_channel.stop();
			_channel = _sound.play();
		}
		/**
		 * 停止。
		 */
		public function stop ( ) :void
		{
			_sound.removeEventListener(SampleDataEvent.SAMPLE_DATA, _sampleData);
			_position = 0;
			
			_channel.stop();
		}
		
		
		/** 破棄 */
		public function clear ( ) :void
		{
			if (_samples)
			{
				_samples.clear();
				_samples = null;
			}
		}
		
		// ------------------------------------------------------------------- private
		
		
		// ------------------------------------------------------------------- Event
		
		/* SAMPLE DATA */
		private function _sampleData ( evt :SampleDataEvent ) :void
		{	
			var left  :Number;
			var right :Number;
			
			var complete :Boolean = false;
			
			for ( var c :int = 0; c < BUFFER_LENGTH; c ++ )
			{	
				// Position
				_position += _speed;
				
				if (_position < 0 || _total - 1 < _position)
				{
					if (_loopTotal <= _loopCount)
					{
						complete = true;
						evt.data.writeFloat(0);
						evt.data.writeFloat(0);
						continue;
					}
					else
					{
						// LOOP
						_loopCount ++;
						
						if (_position < 0)	_position = _total - 1;
						else				_position = 0;
					}
				}
				
				// Samples Position
				_samples.position = Math.floor( _position ) * 8;
				
				// left, right
				if ( 0 < _pan )	left  = _samples.readFloat() * _vol * (1 - _pan);
				else			left  = _samples.readFloat() * _vol;
				if ( _pan < 0 )	right = _samples.readFloat() * _vol * (1 + _pan);
				else			right = _samples.readFloat() * _vol;
				
				evt.data.writeFloat( left );
				evt.data.writeFloat( right );
			}
			
			if (complete)
			{
				stop();
				dispatchEvent(new SamplesEvent(SamplesEvent.SOUND_COMPLETE));
			}
		}
		
		
		// ------------------------------------------------------------------- getter & setter
		/** 音量 */
		public function get volume ( ) :Number { return _vol;   }
		/** 左右パン */
		public function get pan    ( ) :Number { return _pan;   }
		/** 再生速度 */
		public function get speed  ( ) :Number { return _speed; }
		
		
		/** 現在時間 */
		public function get nowTime   ( ) :Number { return MathSoundUtil.fromPositionToSec(_position); }
		/** 合計時間 */
		public function get totalTime ( ) :Number { return _totalTime; }
		
		
		public function set volume ( value :Number ) :void { _vol   = value; }
		public function set pan    ( value :Number ) :void { _pan   = value; }
		public function set speed  ( value :Number ) :void { _speed = value; }
		
	}
}