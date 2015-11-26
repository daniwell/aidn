package aidn.android.commands 
{
	import aidn.main.commands.base.CommandBase;
	import aidn.main.core.StageReference;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import org.audiofx.mp3.MP3FileReferenceLoader;
	import org.audiofx.mp3.MP3SoundEvent;
	
	public class SamplesCommand extends CommandBase
	{
		private var _type :int;
		
		private var _file    :FileReference;
		private var _sound   :Sound;
		private var _samples :ByteArray;
		private var _path    :String;
		
		
		private var _interval  :Number;
		private var _threshold :Number;
		
		private var _mp3frl :MP3FileReferenceLoader;
		
		
		private const TYPE_SOUND  :int = 0;
		private const TYPE_STRING :int = 1;
		private const TYPE_FILE   :int = 2;
		
		
		private var    _loadPercentage :Number = 0.5;
		private var _extractPercentage :Number = 0.5;
		
		
		/**
		 * (要 StageReference, MP3FileReferenceLoader)
		 * @param	value		Sound or or FileReference or String
		 */
		public function SamplesCommand ( value :*, threshold :Number = 0.001, loadPercentage :Number = 0.5, extractPercentage :Number = 0.5 ) 
		{
			_loadPercentage    = loadPercentage;
			_extractPercentage = extractPercentage;
			
			if (value is Sound)
			{
				   _loadPercentage = 0;
				_extractPercentage = 1.0;
				
				_type  = TYPE_SOUND;
				_sound = value;
			}
			else if (value is String)
			{
				_type = TYPE_STRING;
				_path = value;
			}
			else
			{
				_type = TYPE_FILE;
				_file = value;
			}
			
			_interval  = 1000 / StageReference.stage.frameRate;
			_threshold = threshold;
		}
		
		// ------------------------------------------------------------------- override
		
		override public function execute ( ) :void 
		{
			switch ( _type ) 
			{
				case TYPE_SOUND:
					_soundComplete(null);
					break;
				case TYPE_STRING:
					if (_sound)
					{
						_sound.removeEventListener(ProgressEvent.PROGRESS, _soundProgress);
						_sound.removeEventListener(Event.COMPLETE, _soundComplete);
						_sound = null;
					}
					
					_sound = new Sound();
					_sound.addEventListener(ProgressEvent.PROGRESS, _soundProgress);
					_sound.addEventListener(Event.COMPLETE, _soundComplete);
					_sound.load(new URLRequest(_path));
					break;
				case TYPE_FILE:
					_sound = new Sound();
					
					_mp3frl = new MP3FileReferenceLoader();
					_addSoundEvents();
					_mp3frl.getSound(_file);
					break;	
			}
		}
		
		override public function cancel():void 
		{
			try { _sound.close(); } catch (e:Error) { };
			_removeSoundEvents();
			
			StageReference.removeEnterFrameFunction(_enterFrame);
		}
		
		// ------------------------------------------------------------------- private
		
		private function _addSoundEvents ( ) :void
		{
			if (_file)
			{
				_file.addEventListener(ProgressEvent.PROGRESS, _soundProgress);
				_file.addEventListener(IOErrorEvent.IO_ERROR,  _soundIoError);
			}
			if (_mp3frl) _mp3frl.addEventListener(MP3SoundEvent.COMPLETE, _soundComplete);
		}
		
		private function _removeSoundEvents ( ) :void
		{
			if (_file)
			{
				_file.removeEventListener(ProgressEvent.PROGRESS, _soundProgress);
				_file.removeEventListener(IOErrorEvent.IO_ERROR,  _soundIoError);
			}
			if (_mp3frl) _mp3frl.removeEventListener(MP3SoundEvent.COMPLETE, _soundComplete);
		}
		
		private function _triming ( threshold :Number = 0.001 ) :void
		{
			_samples.position = 0;
			
			if (threshold <= 0) return;
			
			var i   :int = 0;
			var n   :Number;
			var ba  :ByteArray;
			var len :uint = _samples.length;
			
			// [前] 無音トリミング
			while (1)
			{
				if ( threshold < _samples.readDouble() )
				{
					ba = new ByteArray();
					ba.writeBytes(_samples, _samples.position, len - _samples.position);
					
					_samples = ba;
					len = _samples.length;
					break;
				}
				if (len <= _samples.position) break;
			}
			
			// [後] 無音トリミング
			while (1)
			{
				i ++; _samples.position = len - i * 64;
				if (_samples.position <= 0) break;
				
				if ( threshold < _samples.readDouble() )
				{
					ba = new ByteArray();
					ba.writeBytes ( _samples, 0, len - i * 64);
					
					_samples = ba;
					break;
				}
			}
		}
		
		
		// ------------------------------------------------------------------- Event
		
		/* SOUND PROGRESS */
		private function _soundProgress ( evt :ProgressEvent ) :void 
		{
			var p :Number = evt.bytesLoaded / evt.bytesTotal * _loadPercentage;
			_dispatchProgress(p);
		}
		/* SOUND COMPLETE */
		private function _soundComplete ( evt :* ) :void 
		{
			if (evt is MP3SoundEvent)
			{
				_sound = evt.sound;
				_removeSoundEvents();
			}
			else
			{
				_sound.removeEventListener(ProgressEvent.PROGRESS, _soundProgress);
				_sound.removeEventListener(Event.COMPLETE,         _soundComplete);
			}
			
			_samples = new ByteArray();
			
			StageReference.addEnterFrameFunction(_enterFrame);
		}
		/* SOUND IO ERROR */
		private function _soundIoError ( evt :IOErrorEvent ) :void 
		{
			_removeSoundEvents();
			_dispatchFailed();
		}
		
		
		/* EXTRACT */
		private function _enterFrame ( ) :void
		{
			const LENGTH :int = 2048;
			
			var len  :Number;
			var time :Number  = getTimer();
			var flag :Boolean = true;
			
			do {
				len = _sound.extract( _samples, LENGTH );
				if ( _interval < getTimer() - time ) {
					flag = false;
					break;
				}
			} while ( LENGTH <= len );
			
			
			if ( ! flag )	// PROGRESS
			{	
				var p :Number = _samples.length / (_sound.length * 352.8);
				if (_type != TYPE_SOUND) p = p * _extractPercentage + _loadPercentage;
				
				_dispatchProgress(p);
			}
			else			// COMPLETE
			{
				StageReference.removeEnterFrameFunction(_enterFrame);
				_triming(_threshold);
				
				_dispatchComplete();
			}
		}
		
		// ------------------------------------------------------------------- getter
		
		public function get samples ( ) :ByteArray { return _samples; }
		
	}
}