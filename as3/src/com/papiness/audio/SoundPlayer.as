package com.papiness.audio 
{
	import flash.events.*;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	
	/**
	* @eventType SoundPlayer.ALL_COMPLETE
	*/
	[Event(name="all_complete", type="flash.events.Event")]
	/**
	* @eventType SoundPlayer.COMPLETE
	*/
	[Event(name="complete", type="flash.events.Event")]
	/**
	* @eventType SoundPlayer.PROGRESS
	*/
	[Event(name="progress", type="flash.events.Event")]
	
	/**
	 * 複数の MP3 ファイルを読み込んで制御します。
	 * @author daniwell
	 */
	public class SoundPlayer extends EventDispatcher
	{
		/** @private */
		public static const ALL_COMPLETE :String = "all_complete";
		/** @private */
		public static const COMPLETE     :String = "complete";
		/** @private */
		public static const PROGRESS     :String = "progress";
		
		
		private var _now   :int = 0;		
		private var _total :int = 0;
		
		private var _bytesLoaded :Number;
		private var _bytesTotal  :Number;
		
		
		private var _se    :/*Sound*/Array;
		private var _ch    :/*SoundChannel*/Array;
		
		private var _urls  :/*String*/Array;
		
		private var _hash     :Object;			// URL  hash
		private var _hashName :Object;			// NAME hash
		
		/**
		 * SoundPlayer オブジェクトを生成します。
		 */
		public function SoundPlayer() 
		{
			_init();
		}
		// ------------------------------------------------------------------- public method
		/**
		 * 読み込む MP3 ファイルを追加します。
		 * @param	url		MP3 ファイルまでのパス。
		 * @param	name	key となる名前。
		 */
		public function add ( url :String, name :String = null ) :void
		{
			_urls[_total] = url;
			
			_hash[url] = _total;
			if ( name )	_hashName[name] = _total;
			
			_total ++;
		}
		/**
		 * MP3 ファイルの読み込みを開始します。
		 */
		public function start () :void
		{
			_load();
		}
		
		/**
		 * key に基づく Sound オブジェクトを再生します。
		 * @param	key				番号, URL 又は Name のいずれか。
		 * @param	startTime		再生を開始する初期位置 (ミリ秒単位) です。
		 * @param	loops			サウンドチャネルの再生が停止するまで startTime 値に戻ってサウンドの再生を繰り返す回数を定義します。
		 */
		public function play ( key :*, startTime :Number = 0, loops :int = 0 ) :void
		{
			var n :int = _keyToNum(key);
			_ch[n] = _se[n].play(startTime, loops, _ch[n].soundTransform);
		}
		/**
		 * key に基づく Sound オブジェクトを停止します。
		 * @param	key		番号, URL 又は Name のいずれか。
		 * @return			停止時における再生位置を返します。
		 */
		public function stop ( key :* ) :Number
		{
			var n :int = _keyToNum(key);
			var pos :Number = _ch[n].position;
			
			_ch[n].stop();
			
			return pos;
		}
		/**
		 * すべての Sound オブジェクトを停止します。
		 */
		public function stopAll ( ) :void
		{
			for ( var n :int = 0; n < _total; n ++ )
				_ch[n].stop();
		}
		
		/**
		 * key に基づく Sound オブジェクトのボリュームを設定します。
		 * @param	key		番号, URL 又は Name のいずれか。
		 * @param	vol		ボリューム。範囲は 0 (無音) ～ 1 (フルボリューム)。
		 */
		public function setVolume ( key :*, vol :Number ) :void
		{
			if ( vol <   0 ) vol = 0;
			if (  10 < vol ) vol = 10;
			
			var n :int = _keyToNum(key);
			var strans :SoundTransform = _ch[n].soundTransform;
			strans.volume = vol;
			_ch[n].soundTransform = strans;
		}
		/**
		 * key に基づく Sound オブジェクトのボリュームを取得します。
		 * @param	key		番号, URL 又は Name のいずれか。
		 * @return			ボリューム。
		 */
		public function getVolume ( key :* ) :Number
		{
			var n :int = _keyToNum(key);
			return _ch[n].soundTransform.volume;
		}
		/**
		 * key に基づく Sound オブジェクトのパンを設定します。
		 * @param	key		番号, URL 又は Name のいずれか。
		 * @param	pan		パン。範囲は -1 (左) ～ 1 (右)。
		 */
		public function setPan ( key :*, pan :Number ) :void
		{
			if (   1 < pan ) pan =  1;
			if ( pan <  -1 ) pan = -1;
			
			var n :int = _keyToNum(key);
			var strans :SoundTransform = _ch[n].soundTransform;
			strans.pan = pan;
			_ch[n].soundTransform = strans;
		}
		/**
		 * key に基づく Sound オブジェクトのパンを取得します。
		 * @param	key		番号, URL 又は Name のいずれか。
		 * @return			パン。
		 */
		public function getPan ( key :* ) :Number
		{
			var n :int = _keyToNum(key);
			return _ch[n].soundTransform.pan;
		}
		
		/**
		 * すべて消去します。
		 */
		public function clear ( ) :void
		{
			_init();
		}
		
		/**
		 * 追加したファイルのすべての URL を取得します。
		 * @return
		 */
		public function getURLAll ( ) :Array
		{
			var a :Array = [];
			for ( var s :String in _hash )	a.push(s);
			return a;
		}
		/**
		 * 追加したファイルのすべての名前を取得します。
		 * @return
		 */
		public function getNameAll ( ) :Array
		{
			var a :Array = [];
			for ( var s :String in _hashName )	a.push(s);
			return a;
		}
		
		
		// ------------------------------------------------------------------- private method
		private function _init ( ) :void
		{
			_se   = new Array();
			_ch   = new Array();
			_urls = new Array();
			
			_hash     = new Object();
			_hashName = new Object();
		}
		private function _load ( ) :void
		{
			_se[_now] = new Sound();
			
			_se[_now].addEventListener( Event.COMPLETE, completeHandler );
            _se[_now].addEventListener( ProgressEvent.PROGRESS, progressHandler );
            _se[_now].addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler );
			_se[_now].load( new URLRequest(_urls[_now]) );
			
			_ch[_now] = new SoundChannel();
			
			_now ++;
		}
		private function _keyToNum ( key :* ) :int
		{
			var n :int = -1;
			
			if ( key is String )
			{
				if ( _hash[key] )	n = _hash[key];
				else				n = _hashName[key];
			}
			else n = key;
			
			return n;
		}
		
		// ------------------------------------------------------------------- Event
		private function completeHandler ( evt :Event ) :void
		{
			_se[_now-1].addEventListener( Event.COMPLETE, completeHandler );
			_se[_now-1].addEventListener( ProgressEvent.PROGRESS, progressHandler );
			_se[_now-1].addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler );
			
			dispatchEvent( new Event( SoundPlayer.COMPLETE ) );
			
			if ( _now != _total )	_load();
			else					dispatchEvent( new Event( SoundPlayer.ALL_COMPLETE ) );
		}
		
		private function progressHandler ( evt :ProgressEvent ) :void
		{
			_bytesLoaded = evt.bytesLoaded;
			_bytesTotal  = evt.bytesTotal;
			
			dispatchEvent( new Event( SoundPlayer.PROGRESS ) );
		}
		
		private function ioErrorHandler ( evt :Event ) :void
		{
			trace( "ioErrorHandler: " + evt );
		}
		
		// ------------------------------------------------------------------- getter
		/** 現在読み込み中の Sound オブジェクトの番号を返します。 */
		public function get now  () :int { return _now; }
		/** Sound オブジェクトの合計個数を返します。 */
		public function get total() :int { return _total; }
		
		/** 現在読み込み中の Sound オブジェクトの読み込み済バイト数を返します。 */
		public function get bytesLoaded() :Number { return _bytesLoaded; }
		/** 現在読み込み中の Sound オブジェクトの合計バイト数を返します。 */
		public function get bytesTotal () :Number { return _bytesTotal; }
	}
}