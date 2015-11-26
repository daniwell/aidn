package aidn.main.commands 
{
	import aidn.main.commands.base.CommandBase;
	import aidn.main.core.StageReference;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	public class SamplesCommand extends CommandBase
	{
		private var _isSound :Boolean = false;
		
		private var _path    :String;
		private var _sound   :Sound;
		private var _samples :ByteArray;
		
		private var _interval  :Number;
		private var _threshold :Number;
		
		/**
		 * (要 StageReference)
		 * @param	pathOrSound		Sound or String
		 */
		public function SamplesCommand ( pathOrSound :*, threshold :Number = 0.001 ) 
		{
			if (pathOrSound is Sound)
			{
				_isSound = true;
				_sound   = pathOrSound;
			}
			else
			{
				_isSound = false;
				_path  = String(pathOrSound);
			}
			
			_interval  = 1000 / StageReference.stage.frameRate;
			_threshold = threshold;
		}
		
		// ------------------------------------------------------------------- override
		
		override public function execute ( ) :void 
		{
			if (_isSound)
			{
				_soundComplete(null);
			}
			else
			{
				_sound = new Sound();
				_addSoundEvents();
				_sound.load(new URLRequest(_path));	
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
			_sound.addEventListener(ProgressEvent.PROGRESS, _soundProgress);
			_sound.addEventListener(Event.COMPLETE,         _soundComplete);
			_sound.addEventListener(IOErrorEvent.IO_ERROR,  _soundIoError);
		}
		
		private function _removeSoundEvents ( ) :void
		{
			_sound.removeEventListener(ProgressEvent.PROGRESS, _soundProgress);
			_sound.removeEventListener(Event.COMPLETE,         _soundComplete);
			_sound.removeEventListener(IOErrorEvent.IO_ERROR,  _soundIoError);
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
			var p :Number = evt.bytesLoaded / evt.bytesTotal * 0.5;
			_dispatchProgress(p);
		}
		/* SOUND COMPLETE */
		private function _soundComplete ( evt :Event ) :void 
		{
			_samples = new ByteArray();
			
			_removeSoundEvents();
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
				if (! _isSound) p = p * 0.5 + 0.5;
				
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