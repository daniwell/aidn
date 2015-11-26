package com.papiness.audio
{
	import flash.display.Sprite;
	import flash.events.*;
	import flash.media.*;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import org.audiofx.mp3.MP3FileReferenceLoader;
	import org.audiofx.mp3.MP3SoundEvent;
	
	/**
	* @eventType MP3Samples.COMPLETE
	*/
	[Event(name="complete", type="flash.events.Event")]
	/**
	* @eventType MP3Samples.PROGRESS
	*/
	[Event(name="progress", type="flash.events.Event")]
	/**
	* @eventType MP3Samples.SAMPLE_DATA
	*/
	[Event(name="sampleData", type="flash.events.Event")]
	
	/**
	 * [FP10] MP3 を ByteArray に読み込んで再生します。
 * @example MP3 を読み込んで再生するサンプル:
 * <listing version="3.0">
var sound :MP3Samples = new MP3Samples();
sound.addEventListener( MP3Samples.PROGRESS, onProgress );
sound.addEventListener( MP3Samples.COMPLETE, onComplete );
sound.load( "sound.mp3" );

function onProgress ( evt: Event ) :void
{
	trace( sound.progressNow / sound.progressTotal );
}
function onComplete ( evt: Event ) :void
{
	sound.volume = 0.5;  // 音量
	sound.pan = 0;       // パン
	sound.speed = 1;     // 再生速度

	sound.play();
}
 * </listing>
	 * @author daniwell
	 * @see MP3Player
	 * @see "　"
	 * @see http://www.flexiblefactory.co.uk/flexible/?p=46
	 * @see "Require: org.audiofx.mp3.MP3FileReferenceLoader"
	 * @see "Require: org.audiofx.mp3.MP3SoundEvent"
	 */
	public class MP3Samples extends Sprite
	{
		private const BUFFER_LENGTH :Number = 2048;
		
		/** @private */
		public static const PROGRESS :String = "progress";
		/** @private */
		public static const COMPLETE :String = "complete"; 
		/** @private */
		public static const SAMPLE_DATA :String = "sampleData";
		
		//
		public static const SELECT :String = "select";
		
		private var _prognum    :int;		// -1 or 0 or 1
		private var _progLoaded	:Number;
		private var _progTotal	:Number;
		
		private var _fps		:int;		// mp3 解析時のFPS
		private var _interval	:Number;	// 
		
		private var _channel	:SoundChannel;
		private var _dsound		:Sound;
		private var _mp3sound	:Sound;
		private var _mp3FRL		:MP3FileReferenceLoader;
		
		private var _samples	:ByteArray;
		
		private var _total		:Number;	// 全体長
		private var _position	:Number;	// 位置
		private var _speed		:Number;	// 最生速度
		
		private var _totalTime		:Number;	// 全体長 (sec)
		
		
		private var _pauseTime	:Number;
		
		private var _fr			:FileReference;
		
		private var _vol		:Number; 
		private var _pan		:Number;
		
		
		private var _lock		:Boolean;
		private var _playerPlay	:Boolean;
		
		
		/** 新しい MP3Samples オブジェクトを作成します。 */
		public function MP3Samples() 
		{
			_init();
		}
		private function _init () :void
		{
			fps = 30;
			
			_prognum = -1;
			
			_speed = 1.0;
			_pauseTime = 0;
			_vol = 1.0;
			_pan = 0.0;
			
			_lock = false;
			_playerPlay = false;
			
			_fr = new FileReference();
			
			_channel  = new SoundChannel();
			_dsound   = new Sound();
			_mp3sound = new Sound();
			_mp3FRL   = new MP3FileReferenceLoader();
		}
		
		/** ファイル参照ダイアログボックスを表示し、MP3ファイル選択後、読み込み開始します。 */
		public function browse ( ) :void
		{
			_fr.addEventListener( Event.SELECT, _onSelect );
			_fr.browse( [ new FileFilter( "MP3 Sound (*.mp3)","*.mp3" ) ] );
		}
		private function _onSelect ( evt :Event ) :void
		{
			//
			dispatchEvent( new Event( MP3Samples.SELECT ) );
			
			
			_channel.stop();
			_dsound.removeEventListener( SampleDataEvent.SAMPLE_DATA, _sampleData );
			
			_prognum = 0;
			_samples = null;
			_samples = new ByteArray();
			
			_fr.removeEventListener( Event.SELECT, _onSelect );
			
			//_fr = new FileReference();
			//_mp3FRL   = new MP3FileReferenceLoader();
			
			
			_fr.addEventListener( ProgressEvent.PROGRESS, _onProgress );
			_mp3FRL.addEventListener( MP3SoundEvent.COMPLETE, _onComplete );
			_mp3FRL.getSound( _fr );
		}
		
		/**
		 * MP3ファイルを読み込みます。
		 * @param url MP3ファイルまでのパスです。 
		 */
		public function load ( url :String ) :void
		{
			_channel.stop();
			_dsound.removeEventListener( SampleDataEvent.SAMPLE_DATA, _sampleData );
			
			_prognum = 0;
			_samples = null;
			_samples = new ByteArray();
			
			_mp3sound.load( new URLRequest( url ) );
			_mp3sound.addEventListener( ProgressEvent.PROGRESS, _onProgress );
			_mp3sound.addEventListener( Event.COMPLETE, _onComplete );
		}
		
		/**
		 * MP3ファイルの読み込みを中止します。
		 * @return 読み込み中以外、又は失敗した場合は false を返します。
		 */
		public function close ( ) :Boolean
		{
			if ( _prognum == 0 )		// FileReference ロード中
			{
				if ( _mp3sound.hasEventListener( ProgressEvent.PROGRESS ) )
				{
					_prognum = -1;
					_mp3sound.close();
					return true;
				}
			}
			else if ( _prognum == 1 )	// extract 中
			{
				_prognum = -1;
				removeEventListener( Event.ENTER_FRAME, _onEnterFrame );
				return true;
			}
			return false;
			
		}
		
		private function _onProgress ( evt :ProgressEvent ) :void
		{
			_progLoaded = evt.bytesLoaded;
			_progTotal  = evt.bytesTotal;
			dispatchEvent( new Event( MP3Samples.PROGRESS ) );
		}
		private function _onComplete ( evt :* ) :void
		{	
			_prognum = 1;
			
			if ( evt is MP3SoundEvent )
			{
				_mp3sound = evt.sound;
				_fr.removeEventListener( ProgressEvent.PROGRESS, _onProgress );
				_mp3FRL.removeEventListener( MP3SoundEvent.COMPLETE, _onComplete );
			}
			else
			{
				_mp3sound.removeEventListener( ProgressEvent.PROGRESS, _onProgress );
				_mp3sound.removeEventListener( Event.COMPLETE, _onComplete );
			}
			
			addEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}
		
		private function _onEnterFrame ( evt :Event ) :void {
			
			var len  :Number  = new Number();
			var time :Number  = getTimer();
			var flag :Boolean = true;
			
			do {
				len = _mp3sound.extract( _samples, BUFFER_LENGTH );	// BUFFER_LENGTH でなくともよい
				if ( _interval < getTimer() - time ) {
					flag = false;
					break;
				}
			} while ( BUFFER_LENGTH <= len );
			
			
			_progLoaded = _samples.position;
			_progTotal  = Math.round( _mp3sound.length * 352.8 );
			dispatchEvent( new Event( MP3Samples.PROGRESS ) );
			
			if ( flag )
			{	
				_prognum = -1;
				
				_totalTime = _mp3sound.length;
				_total = _samples.length / 8;
				
				removeEventListener( Event.ENTER_FRAME, _onEnterFrame );
				
				dispatchEvent( new Event( MP3Samples.COMPLETE ) );
			}
		}
		
		/* ----- PLAY, PAUSE, RESUME, STOP ----- */
		/**
		 * サウンドを再生します。
		 * @param startTime 再生開始時間(sec)。
		 */
		public function play ( startTime :Number = 0 ) :void
		{
			 startTime = fromSecToPosition( startTime );	// Y (position) = X (ms) × 352.8
			_position = startTime;
			
			if ( !_lock )
			{
				if ( ! _dsound.hasEventListener( SampleDataEvent.SAMPLE_DATA ) )
					_dsound.addEventListener( SampleDataEvent.SAMPLE_DATA, _sampleData );
				
				_channel.stop();
				_channel = _dsound.play();
			}
			else _playerPlay = true;
		}
		/** サウンドを一時停止します。 */
		public function pause ( ) :void
		{
			if ( !_lock )
			{
				_pauseTime = _position;
				_dsound.removeEventListener( SampleDataEvent.SAMPLE_DATA, _sampleData );
				
				_channel.stop();
			}
			else _playerPlay = false;
		}
		/** 一時停止したサウンドを再開します。 */
		public function resume ( ) :void
		{
			if ( !_lock )
			{
				_position = _pauseTime;
				if ( ! _dsound.hasEventListener( SampleDataEvent.SAMPLE_DATA ) )
					_dsound.addEventListener( SampleDataEvent.SAMPLE_DATA, _sampleData );
				
				_channel.stop();
				_channel = _dsound.play( );
			}
			else _playerPlay = true;
		}
		/** サウンドを停止します（再生位置は 0 に戻ります）。 */
		public function stop ( ) :void
		{
			_position = 0;
			
			if ( !_lock )
			{
				_pauseTime = 0;
				_dsound.removeEventListener( SampleDataEvent.SAMPLE_DATA, _sampleData );
				
				_channel.stop();
			}
			else _playerPlay = true;
		}
		
		
		/* SampleDataEvent */
		private function _sampleData ( evt :SampleDataEvent ) :void
		{	
			var left  :Number;
			var right :Number;
			
			for ( var c :int = 0; c < BUFFER_LENGTH; c ++ )
			{	
				_position += _speed;
					if      ( _position < 0 )			_position = _total-1;
					else if ( _total-1 < _position )	_position = 0;
				
				_samples.position = Math.floor( _position ) * 8;
				
				if ( 0 < _pan )	left  = _samples.readFloat() * _vol * (1-_pan);
				else			left  = _samples.readFloat() * _vol;
				
				if ( _pan < 0 )	right = _samples.readFloat() * _vol * (1+_pan);
				else			right = _samples.readFloat() * _vol;
				
				evt.data.writeFloat( left );
				evt.data.writeFloat( right );
			}
			
			dispatchEvent( new Event( MP3Samples.SAMPLE_DATA ) );
		}
		
		/** 
		 * 秒 を ポジション値 に変換します。
		 * @param sec 秒(sec)。
		 * @return ポジション値。
		 */
		public function fromSecToPosition ( sec :Number ) :int
		{
			return (sec * 44100);
		}
		/** ポジション値 を 秒 に変換します。
		 * @param position ポジション値。
		 * @return 秒(sec)。
		 */
		public function fromPositionToSec ( position :int ) :Number
		{
			return (position * 0.0441);
		}
		
		/* ----- Getter ----- */
		/** 0 = 読み込み中, 1 = 解析中, -1 = なし  */
		public function get progressNumber():int    { return _prognum; }
		/** 読み込み又は解析済みの量。 */
		public function get progressNow   ():Number { return _progLoaded; }
		/** 読み込み又は解析における全体量。 */
		public function get progressTotal ():Number { return _progTotal; }
		
		public function get fps        ():int       { return _fps; }
		/** 現在のサウンドファイルの全体の長さを示します。 */
		public function get totalTime  ():Number    { return _totalTime; }
		/** 現在のサウンドファイルでの時間を示します。 */
		public function get position   ():Number    { return (_position * 0.0441); }
		/** 再生スピードです。 1 が等速になります。 */
		public function get speed      ():Number    { return _speed; }
		
		/** @private */
		public function get total_hide    ():Number { return _total; }
		/** @private */
		public function get position_hide ():Number { return _position; }
		
		/** @private */
		public function get samples    ():ByteArray { return _samples; }
		
		
		
		/* ----- Setter ----- */
		public function set fps ( value :int ) :void 
		{
			_fps = value;
			_interval = 1000/_fps;
		}
		public function set position ( value :Number )    :void { _position = value * 44100; }
		public function set speed    ( value :Number )    :void { _speed = value; }
		
		/** @private */
		public function set position_hide ( value :Number ) :void { _position = value; }
		/** @private */
		public function set samples  ( value :ByteArray ) :void
		{ 
			_samples = value;
			_total = _samples.length / 8;
		}
		
		
		/** ボリュームです。範囲は 0 (無音) ～ 1 (フルボリューム) です。 */
		public function get volume ():Number { return _vol; }
		public function set volume ( value :Number ) :void 
		{
			_vol = value;
			if ( _vol < 0 )			_vol = 0;
			else if ( 10 < _vol )	_vol = 10;
		}
		
		/** サウンドの左から右へのパンです。範囲は -1 (完全に左へパン) ～ 1 (完全に右へパン) です。 */
		public function get pan ():Number { return _pan; }
		public function set pan ( value :Number ) :void 
		{
			_pan = value;
			if ( _pan < -1 )		_pan = -1;
			else if ( 1 < _pan )	_pan =  1;
		}
		
		/** @private */
		public function get lock():Boolean { return _lock; }
		/** @private */
		public function set lock(value:Boolean):void 
		{
			_lock = value;
		}
		/** @private */
		public function get playerPlay():Boolean { return _playerPlay; }
		/** @private */
		public function set playerPlay(value:Boolean):void 
		{
			_playerPlay = value;
		}
		
	}
}