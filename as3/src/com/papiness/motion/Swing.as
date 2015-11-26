package com.papiness.motion
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	
	/**
	 * 不規則にゆらゆら揺れるアニメーションを DisplayObject に適用します。
	 * @author daniwell
	 */
	public class Swing extends Sprite
	{
		private var _n1 :Number = 0;
		private var _n2 :Number = 0;
		private var _r1 :Number = 0;
		
		private var _dn1 :Number;
		private var _dn2 :Number;
		private var _dr1 :Number;
		
		private var _dy :Number;
		private var _dx :Number;
		private var _dr :Number;
		
		private var _do :Sprite;
		private var _dobj :DisplayObject;
		private var _pos :Point;
		
		/** 新しい Yurayura オブジェクトを作成します。 */
		public function Swing( ) :void { }
		
		/**
		 * 初期設定を行います。
		 * @param dobj アニメーションを適用する DisplayObject。
		 * @param align 中心位置。値は StageAlign と同じ考え方。
		 * @param speed 揺れる速度。
		 * @param amount 揺れる量。
		 */
		public function init( dobj :DisplayObject, align :String = "", speed :int = 10, amount :int = 10 ) :void
		{
			_do = new Sprite();
			_dobj = dobj;
			
			this.addChild( _do );
			_do.addChild( _dobj );
			
			var s :String = align.toLocaleUpperCase();
			
			if ( 0 <= s.indexOf( "B" ) )		_dobj.y = - _dobj.height;
			else if ( s.indexOf( "T" ) == -1 )	_dobj.y = - _dobj.height / 2;
			if ( 0 <= s.indexOf( "R" ) )		_dobj.x = - _dobj.width;
			else if ( s.indexOf( "L" ) == -1 )	_dobj.x = - _dobj.width / 2;
			
			_pos = new Point( _do.x, _do.y );
			
			_dn1 = speed * 0.009;
			_dn2 = speed * 0.005;
			_dr1 = speed * 0.006;
			
			_dy = amount * 1.9;
			_dx = amount * 1.5;
			_dr = amount * 0.8;
		}
		/**
		 * アニメーションを開始します。
		 */
		public function start ( ) :void
		{
			addEventListener( Event.ENTER_FRAME, _onEnterFrameHandler );
		}
		/**
		 * アニメーションを停止します。
		 */
		public function stop ( ) :void
		{
			removeEventListener( Event.ENTER_FRAME, _onEnterFrameHandler );
		}
		/**
		 * クリア（メモリ解放時）。
		 */
		public function clear ( ) :void
		{
			if ( _dobj is Bitmap )
			{
				var _b :Bitmap = _dobj as Bitmap;
				_b.bitmapData.dispose();
			}
			
			removeEventListener( Event.ENTER_FRAME, _onEnterFrameHandler );
			_do.removeChild( _dobj );
			removeChild( _do );
		}
		
		private function _onEnterFrameHandler ( evt :Event ) :void
		{
			_do.y = _pos.y + Math.sin( _n1 ) * _dy;
			_do.x = _pos.x + Math.sin( _n2 ) * _dx;
			_do.rotation   = Math.sin( _r1 ) * _dr;
			
			_n1 += _dn1;
			_n2 += _dn2;
			_r1 += _dr1;
		}
	}
	
}