package com.papiness.audio
{
	import flash.events.*;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import org.sazameki.audio.format.wav.Wav;
	import org.sazameki.audio.core.AudioSamples;
	import org.sazameki.audio.core.AudioSetting;
	
	import com.papiness.audio.MP3Samples;
	
	/**
	* @eventType MP3Samples.SAMPLE_DATA
	*/
	[Event(name="sampleData", type="flash.events.Event")]
	
	/**
	 * [FP10] 複数の MP3Samples を再生及び制御します。
	 * @author daniwell
	 * @see MP3Samples
	 * @see "　"
	 * @see http://sazameki.org/
	 * @see "Require: org.sazameki.audio.format.wav.Wav"
	 * @see "Require: org.sazameki.audio.core.AudioSamples"
	 * @see "Require: org.sazameki.audio.core.AudioSetting"
	 */
	public class MP3Player extends EventDispatcher
	{
		private const BUFFER_LENGTH :Number = 2048;
		
		/** @private */
		public static const SAMPLE_DATA :String = "sampleData";
		
		
		private var _recFlag :Boolean;
		private var _aSamples :AudioSamples;
		
		private var _dsound :Sound;
		private var _channel :SoundChannel;
		
		private var _mp3samples :Vector.<MP3Samples>;
		
		private var _total :int;		// Sound ファイル数
		
		/** 新しい MP3Player オブジェクトを作成します。 */
		public function MP3Player() 
		{
			_init();
		}
		private function _init ( ) :void
		{
			_recFlag = false;
			
			_dsound  = new Sound();
			_channel = new SoundChannel();
			_dsound.addEventListener( SampleDataEvent.SAMPLE_DATA, _sampleData );
			
			_mp3samples = new Vector.<MP3Samples>();
			
			_aSamples = new AudioSamples( new AudioSetting(2, 44100, 16), 0 );
		}
		
		/**
		 * MP3Samples を追加します。
		 * @param mp3Samples 追加する MP3Samples です。 
		 */
		public function add ( mp3Samples :MP3Samples ) :void
		{
			_mp3samples.push( mp3Samples );
			mp3Samples.lock = true;
		}
		/**
		 * 追加した MP3Samples を削除します。
		 * @param number 追加した番号です。
		 */
		public function clear ( number :int ) :void
		{
			_mp3samples[number].lock = false;
			_mp3samples[number] = null;
			
			// MP3Player 上でのみクリア
		}
		
		/* ----- sample START, STOP ----- */
		/** 再生を開始します。 */
		public function sampleStart ( ) :void
		{
			_channel = _dsound.play();
		}
		/** 再生を停止します。 */
		public function sampleStop ( ) :void
		{
			_channel.stop();
		}
		
		/* ----- record START, STOP, CLEAR ----- */
		/** 録音を開始します。 */
		public function recordStart ( ) :void
		{
			_recFlag = true;
		}
		/** 録音を停止します。 */
		public function recordStop ( ) :void
		{
			_recFlag = false;
		}
		/** 録音したデータをクリアします。 */
		public function recordClear ( ) :void
		{
			_aSamples = new AudioSamples( new AudioSetting(2, 44100, 16), 0 );
		}
		
		/* ----- save ----- */
		/** 録音したデータを WAV で保存します。 */
		public function save ( ) :void
		{
			_saveWav();
		}
		private function _saveWav ( ) :void
		{
			var enc :Wav = new Wav();
			var ba :ByteArray = enc.encode( _aSamples );
			
			var fr :FileReference = new FileReference();
			fr.save( ba, "sound.wav" );
		}
		
		/* ----- PLAY, PAUSE, RESUME, STOP ----- */
		/** @private */
		public function play ( number :int, startTime :Number = 0 ) :void
		{
			_mp3samples[number].position = startTime;
			_mp3samples[number].playerPlay = true;
		}
		/** @private */
		public function pause ( number :int ) :void
		{
			_mp3samples[number].playerPlay = false;
		}
		/** @private */
		public function resume ( number :int ) :void
		{
			_mp3samples[number].playerPlay = true;
		}
		/** @private */
		public function stop ( number :int ) :void
		{
			_mp3samples[number].position = 0;
			_mp3samples[number].playerPlay = false;
		}
		
		
		/* SampleDataEvent */
		private function _sampleData ( evt :SampleDataEvent ) :void
		{
			var left  :Number;
			var right :Number;
			
			var bf :Boolean = false;
				
			
			for ( var c :int = 0; c < BUFFER_LENGTH; c ++ )
			{	
				left = right = 0;
				
				for ( var i :int = 0; i < _mp3samples.length; i ++ )
				{
					if ( _mp3samples[i] != null )
					{
						if ( _mp3samples[i].speed != 0 && _mp3samples[i].playerPlay )
						{
							_mp3samples[i].position_hide += _mp3samples[i].speed;
							
								if ( _mp3samples[i].position_hide < 0 )
									_mp3samples[i].position_hide = _mp3samples[i].total_hide-1;
								else if ( _mp3samples[i].total_hide - 1 < _mp3samples[i].position_hide )
									_mp3samples[i].position_hide = 0;
							
							_mp3samples[i].samples.position = Math.floor( _mp3samples[i].position_hide ) * 8;
							
							if ( 0 < _mp3samples[i].pan )	left  = _mp3samples[i].samples.readFloat() * _mp3samples[i].volume * (1-_mp3samples[i].pan);
							else							left  = _mp3samples[i].samples.readFloat() * _mp3samples[i].volume;
							
							if ( _mp3samples[i].pan < 0 )	right = _mp3samples[i].samples.readFloat() * _mp3samples[i].volume * (1+_mp3samples[i].pan);
							else							right = _mp3samples[i].samples.readFloat() * _mp3samples[i].volume;
							
							if ( 0.1 < left ) bf = true;
							
						}
					}
				}
				
				evt.data.writeFloat( left );
				evt.data.writeFloat( right );
				
				if ( _recFlag ) {
					_aSamples.left.push( left );
					_aSamples.right.push( right );
				}
			}
			
			dispatchEvent( new Event( MP3Player.SAMPLE_DATA ) );
		}
		
		
		/** @private */
		public function get mp3Samples():Vector.<MP3Samples> { return _mp3samples; }
	}
}