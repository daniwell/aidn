package aidn.sion.controller 
{
	import aidn.sion.events.SiONEvent;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import org.si.sion.events.SiONTrackEvent;
	import org.si.sion.SiONDriver;
	import org.si.sion.SiONVoice;
	
	
	/**
	 * @require https://sites.google.com/site/sioncenterj/download/
	 */
	
	
	/** @eventType SiONEvent.BEAT */
	[Event(name="sionBeat", type="aidn.sion.events.SiONEvent")]
	/** @eventType SiONEvent.STEP */
	[Event(name="sionStep", type="aidn.sion.events.SiONEvent")]
	
	
	public class SiONManager extends EventDispatcher
	{
		
		private var _driver :SiONDriver;
		
		private var _nowStep :int;
		private var _nowBeat :int;
		
		
		// Asset
		private var _assetVoice  :SiONVoice;
		private var _assetNotes  :/*int*/Array;
		private var _assetLength :Number;
		
		private var _prevNote :int;
		
		
		private var _bpm    :Number;
		private var _volume :Number;
		
		
		public function SiONManager() 
		{
			
		}
		
		// ------------------------------------------------------------------- public methods
		/**
		 * 
		 * @param	bpm
		 * @param	volume
		 */
		public function init ( bpm :Number = 60, volume :Number = 1.0, intervalLength16 :Number = 1.0 ) :void
		{
			_driver = new SiONDriver();
			
			this.bpm    = bpm;
			this.volume = volume;
			
			_driver.setBeatCallbackInterval(intervalLength16);
			_driver.addEventListener( SiONTrackEvent.BEAT, _onBeat );
			_driver.setTimerInterruption( intervalLength16, _onTimerInterruption );
			
			
			_assetVoice  = new SiONVoice(10);
			_assetNotes  = [];
			_assetLength = 0;
		}
		
		
		/**
		 * 
		 * @param	sample
		 * @param	note
		 */
		public function setSample ( sample :Sound, note :int ) :void
		{
			_driver.setSamplerSound( note, sample );
			_assetNotes[note] = note;
		}
		
		/**
		 * 
		 * @param	note
		 * @param	isPreStop
		 */
		public function noteOnSample ( note :int, preStop :Boolean = true ) :void
		{
			if ( ! (0 <= _assetNotes[note]) ) return;
			if ( preStop && 0 <= _prevNote ) _driver.noteOff( _prevNote );
			
			_prevNote = _assetNotes[note];
			_driver.noteOn( _assetNotes[note], _assetVoice, _assetLength );
		}
		
		/**
		 * 
		 * @param	note
		 * @param	voice
		 * @param	len
		 */
		public function noteOnPreset ( note :int, voice :SiONVoice, len :Number = 1 ) :void
		{
			_driver.noteOn( note, voice, len );
		}
		
		
		/* 再生 */
		public function play ( ) :void
		{
			_nowStep = 0;
			_nowBeat = 0;
			if ( ! _driver.isPlaying ) _driver.play();
		}
		/* 一時停止からの再開 */
		public function resume ( ) :void
		{
			if ( ! _driver.isPlaying ) _driver.play();
		}
		/* 一時停止 */
		public function pause ( ) :void
		{
			_nowStep = _nowBeat;
			if ( _driver.isPlaying ) _driver.stop();
		}
		/* 停止 */
		public function stop ( ) :void
		{
			_nowStep = 0;
			_nowBeat = 0;
			if ( _driver.isPlaying ) _driver.stop();
		}
		
		
		// ------------------------------------------------------------------- Event
		/* 音同期 */
		private function _onTimerInterruption ( ) :void
		{
			var e :SiONEvent = new SiONEvent(SiONEvent.STEP);
			e.count = _nowStep;
			dispatchEvent(e);
			
			_nowStep ++;
		}
		
		/* 映像同期 */
		private function _onBeat ( evt :SiONTrackEvent ) :void 
		{
			var e :SiONEvent = new SiONEvent(SiONEvent.BEAT);
			e.count = _nowBeat;
			dispatchEvent(e);
			
			_nowBeat ++;
		}
		
		
		// ------------------------------------------------------------------- getter & setter
		
		public function get bpm():Number { return _bpm; }
		
		public function set bpm(value:Number):void 
		{
			_driver.bpm = _bpm = value;
		}
		
		public function get volume():Number { return _volume; }
		
		public function set volume(value:Number):void 
		{
			_driver.volume = _volume = value;
		}
		
	}
}