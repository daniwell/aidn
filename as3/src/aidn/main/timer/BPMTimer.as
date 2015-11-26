package aidn.main.timer 
{
	import aidn.main.core.StageReference;
	import flash.display.*;
	import flash.events.*;
	import flash.utils.getTimer;
	
	/** @eventType BPMTimer.BEAT */
	[Event(name="beat", type="flash.events.Event")]
	
	
	/**
	 * BPM タイマー
	 */
	public class BPMTimer extends EventDispatcher
	{
		public static const BEAT :String = "beat";
		
		private var _bpm       :Number;
		private var _startTime :uint;
		
		private var _count     :Number;
		private var _upCount   :Number;
		
		public function BPMTimer ( ) :void
		{
			
		}
		
		// ------------------------------------------------------------------- public
		/**
		 * カウントを開始します。
		 * @param	bpm
		 * @param	updateCount
		 */
		public function start( bpm :Number = 120, updateCount :int = 1 ):void
		{
			_bpm = bpm;
			_startTime = getTimer();
			
			_count   = 0;
			_upCount = updateCount;
			
			StageReference.removeEventListener( Event.ENTER_FRAME, _enterFrameHandler );
			   StageReference.addEventListener( Event.ENTER_FRAME, _enterFrameHandler );
			
			// 0 拍
			dispatchEvent( new Event( BPMTimer.BEAT ) );
		}
		
		/**
		 * 停止します。
		 */
		public function stop ( ) :void
		{
			StageReference.removeEventListener( Event.ENTER_FRAME, _enterFrameHandler );
		}
		
		// ------------------------------------------------------------------- Event
		/* ENTER FRAME */
		private function _enterFrameHandler ( evt :Event ) :void
		{
			var diff :uint   = getTimer() - _startTime;
			var beat :Number = 60000 / _bpm;
			
			if ( _count + _upCount <= diff / beat )
			{
				_count += _upCount;
				dispatchEvent( new Event( BPMTimer.BEAT ) );
			}	
		}
		
		// ------------------------------------------------------------------- getter
		/* BPM */
		public function get bpm   ( ) :Number { return _bpm; }
		/* 拍 */
		public function get count ( ) :Number { return _count; }
	}
}