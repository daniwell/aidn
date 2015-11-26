package com.papiness.audio
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	
	
	/**
	 * Sound オブジェクトを制御します。
	 * @author daniwell
	 */
	public class SoundController extends EventDispatcher
	{
		private var _so :Sound;
		private var _ch :SoundChannel;
		
		private var _volume :Number;
		private var _pan    :Number;
		
		
		
		/**
		 * SoundController オブジェクトを生成します。
		 * @param	sound	セットする Sound オブジェクトです。
		 */
		public function SoundController( sound :Sound = null ) :void 
		{
			_ch = new SoundChannel();
			if ( sound ) _so = sound;
		}
		/**
		 * Sound オブジェクトをセットします。
		 * @param	sound	セットする Sound オブジェクトです。
		 */
		public function setSound ( sound :Sound ) :void
		{
			if ( _dobj ) stopBeatCount();
			_so = sound;
			
		}
		
		
		public static const BEAT :String = "beat";
		
		private var _bpm      :Number;
		private var _dobj     :DisplayObject;
		private var _interval :Number;
		private var _prevPos  :Number;
		
		
		public function startBeatCount ( bpm :Number = 120, dobj :DisplayObject = null ) :void
		{
			_prevPos = 0;
			
			_bpm      = bpm;
			_interval = 60000 / bpm;
			
			_dobj = dobj;
			
			_dobj.addEventListener(Event.ENTER_FRAME, _entarFrame);
		}
		public function stopBeatCount ( ) :void
		{
			_dobj.removeEventListener(Event.ENTER_FRAME, _entarFrame);
		}
		
		
		/**
		 * サウンドを再生します。
		 * @param	startTime		再生を開始する初期位置 (ミリ秒単位) です。
		 * @param	loops			サウンドチャネルの再生が停止するまで startTime 値に戻ってサウンドの再生を繰り返す回数を定義します。
		 */
		public function play ( startTime :Number = 0, loops :int = 0 ) :void
		{
			_ch = _so.play(startTime, loops, _ch.soundTransform);
			
			if ( ! _ch.hasEventListener(Event.SOUND_COMPLETE) )
				_ch.addEventListener(Event.SOUND_COMPLETE, _soundComplete);
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
		
		
		/* ENTER FRAME for BEAT_COUNT */
		private function _entarFrame ( evt :Event ) :void
		{
			var def :Number = _ch.position - _prevPos;
			// trace( _ch.position, _prevPos );
			
			if ( _interval < def || def < 0 )
			{
				_prevPos  += _interval;
				if ( def < 0 ) _prevPos = 0;
				
				dispatchEvent( new Event(SoundController.BEAT) );
			}
		}
		/* SOUND COMPLETE */
		private function _soundComplete ( evt :Event ) :void
		{
			dispatchEvent( evt );
		}
		
		// ------------------------------------------------------------------- getter
		/** ボリュームです。範囲は 0 (無音) ～ 1 (フルボリューム) です。 */
		public function get volume () :Number { return _volume; }
		/** サウンドの左から右へのパンです。範囲は -1 (完全に左へパン) ～ 1 (完全に右へパン) です。 */
		public function get pan    () :Number { return _pan; }
		/** 現在の再生位置です。 */
		public function get position ( ) :Number { return _ch.position }
		
		
		// ------------------------------------------------------------------- setter
		
		/** @private */
		public function set volume ( value :Number ) :void 
		{
			if ( value <   0 ) value = 0;
			if (  10 < value ) value = 10;
			
			_volume = value;
			
			var strans :SoundTransform = _ch.soundTransform;
			strans.volume = _volume;
			_ch.soundTransform = strans;
		}
		/** @private */
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