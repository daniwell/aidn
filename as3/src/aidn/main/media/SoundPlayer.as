package aidn.main.media 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	/** @eventType Event.SOUND_COMPLETE */
	[Event(name="soundComplete", type="flash.events.Event")]
	
	
	public class SoundPlayer extends EventDispatcher
	{
		private var _so :Sound;
		private var _ch :SoundChannel;
		
		private var _volume :Number;
		private var _pan    :Number;
		
		
		/**
		 * SoundPlayer オブジェクトを生成します。
		 * @param	sound	セットする Sound オブジェクトです。
		 */
		public function SoundPlayer ( sound :Sound ) :void 
		{
			_ch = new SoundChannel();
			_so = sound;
		}
		
		/**
		 * サウンドを再生します。
		 * @param	startTime		再生を開始する初期位置 (ミリ秒単位) です。
		 * @param	loops			サウンドチャネルの再生が停止するまで startTime 値に戻ってサウンドの再生を繰り返す回数を定義します。
		 */
		public function play ( startTime :Number = 0, loops :int = 0 ) :void
		{
			_ch = _so.play(startTime, loops, _ch.soundTransform);
			if ( ! _ch.hasEventListener(Event.SOUND_COMPLETE) ) _ch.addEventListener(Event.SOUND_COMPLETE, _soundComplete);
		}
		/**
		 * サウンドを停止します。
		 * @return			停止時における再生位置を返します。
		 */
		public function stop ( ) :Number
		{
			var pos :Number = _ch.position;
			_ch.stop();
			
			return pos;
		}
		
		public function kill ( ) :void
		{
			stop();
			
			try { _so.close(); } catch (e:*) { }
			
			_ch.removeEventListener(Event.SOUND_COMPLETE, _soundComplete);
			_ch = null;
			_so = null;
		}
		
		
		// ------------------------------------------------------------------- Event
		/* SOUND COMPLETE */
		private function _soundComplete ( evt :Event ) :void
		{
			dispatchEvent( evt );
		}
		
		// ------------------------------------------------------------------- getter
		/** ボリュームです。範囲は 0 (無音) ～ 1 (フルボリューム) です。 */
		public function get volume   ( ) :Number { return _volume; }
		/** サウンドの左から右へのパンです。範囲は -1 (完全に左へパン) ～ 1 (完全に右へパン) です。 */
		public function get pan      ( ) :Number { return _pan; }
		/** 現在の再生位置です。 */
		public function get position ( ) :Number { return _ch.position; }
		/** サウンドの長さです。 */
		public function get length   ( ) :Number { return _so.length; }
		
		
		// ------------------------------------------------------------------- setter
		
		public function set volume ( value :Number ) :void 
		{
			if ( value <   0 ) value = 0;
			if (  10 < value ) value = 10;
			
			_volume = value;
			
			var strans :SoundTransform = _ch.soundTransform;
			strans.volume = _volume;
			_ch.soundTransform = strans;
		}
		public function set pan ( value :Number ) :void 
		{
			if ( value <  -1 ) value = -1;
			if ( 1   < value ) value = 1;
			
			_pan = value;
			
			var strans :SoundTransform = _ch.soundTransform;
			strans.pan = _pan;
			_ch.soundTransform = strans;
		}
	}

}