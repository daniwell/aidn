package com.papiness.motion
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import com.papiness.motion.MotionEvent;
	
	/**
	* @eventType Motion.COMPLETE 
	*/
	[Event(name="complete", type="flash.events.Event")]
	/**
	* @eventType Motion.PROGRESS
	*/
	[Event(name="progress", type="flash.events.Event")]
	
	
	/**
	 * 連続したインスタンス名や配列中の DisplayObject に対して、モーションを適用します。
	 * @author daniwell
	 * @see MotionEvent
	 */
	public class Motion extends EventDispatcher
	{
		
		private var ad   :Array;	// ディスプレイオブジェクトの配列
		private var pos  :Array;	// 各ディスプレイオブジェクトの位置
		private var prm  :Object;	// パラメータ
		private var prm2 :Object;	// フェイドイン & アウトパラメータ
		
		private var nn :Number;		// Now Number
		private var sn :int;		// Start Number
		private var sn2 :int;		// Start Number ( fade )
		
		private var _dispObj :DisplayObject;
		
		/** 新しい Motion オブジェクトを作成します。 */
		public function Motion ( ) { }
		
		/*
			param.amount   param.amountX   param.amountY
			param.speed    param.speedX    param.speedY
			param.interval
			
			fade.start
			fade.end
			fade.type
		*/
		
		/* d 中の連番インスタンス(d[s+0] ~ d[s+X])に対して、モーションを実行  */
		public function motion ( d :DisplayObject, s :String, param :Object = null, fade :Object = null ) :void
		{
			_dispObj = d;
			
			var i :int;
			
			if ( d[s + "0"] != undefined )
			{
				d.alpha = 1.0;
				
				_deleteInit( d );
				_paramInit( param, fade );
				
				for ( i = 0; d[s+i] != undefined; i ++ )
				{
					ad.push( d[s+i] );
					d[s+i].visible = true;
					d[s+i].alpha = prm2.start;
					pos[i] = new Point( d[s+i].x, d[s+i].y );
				}
				
				_typeInit( d, param );
			}
		}
		/* a 内の DisplayObject に対して、モーションを実行 */
		public function motionArray ( a :Array, param :Object = null, fade :Object = null ) :void
		{
			var i :int;
			var d :DisplayObject;
			
			if ( 0 < a.length )
			{
				d = a[0];
				
				_deleteInit( d );
				_paramInit( param, fade );
				
				for ( i = 0; i < a.length; i ++ )
				{
					ad.push( a[i] );
					a[i].visible = true;
					a[i].alpha = prm2.start;
					pos[i] = new Point( a[i].x, a[i].y );
				}
				
				_typeInit( d, param );
			}
		}
		/* c 内の DisplayObject に対して、モーションを実行 */
		public function motionContainer ( c :DisplayObjectContainer, param :Object = null, fade :Object = null ) :void
		{
			_dispObj = d;
			
			var i :int;
			var d :DisplayObject;
			var num :int = c.numChildren;
			
			if ( 0 < num )
			{
				d = c.getChildAt(0);
				
				_deleteInit( d );
				_paramInit( param, fade );
				
				for ( i = 0; i < num; i ++ )
				{
					d = c.getChildAt( i );
					ad.push( d );
					d.visible = true;
					d.alpha = prm2.start;
					pos[i] = new Point( d.x, d.y );
				}
				
				_typeInit( d, param );
			}
		}
		
		
		private function _deleteInit ( d :DisplayObject ) :void
		{	
			if ( ad != null )
			{
				for ( var i :int = 0; i < ad.length; i ++ )
				{
					ad[i].x = pos[i].x;
					ad[i].y = pos[i].y;
					ad[i].alpha = prm2.end;	
				}
				if ( d.hasEventListener(Event.ENTER_FRAME) )
					d.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		private function _paramInit ( param :Object, fade :Object ) :void
		{
			sn = 0;
			sn2 = 0;
			
			ad   = new Array();
			pos  = new Array();
			prm  = new Object();
			prm2 = new Object();
			
			// -----------------------------------------
			if ( param == null ) param = new Object();
			if ( fade  == null ) fade  = new Object();
			
			if ( 0 <= fade.start && fade.start <= 1.0 )	prm2.start = fade.start;
			else 										prm2.start = 0.0;
			
			if ( 0 <= fade.end && fade.end <= 1.0 )		prm2.end = fade.end;
			else 										prm2.end = 1.0;
			
			if ( fade.type )	prm2.type = fade.type.toUpperCase();
			else 				prm2.type = "NONE";
		}
		private function _typeInit ( d :DisplayObject, param :Object ) :void
		{
			
			if ( ! param.type ) param.type = "BURE";
				
			switch ( param.type.toUpperCase() )
			{
				case "BURE" :	bure ( d,param );		break;
				default		:	bure ( d,param );		break;
			}
			
			/*
			if ( param.amount != 0 )
			{
				d.addEventListener( Event.ENTER_FRAME, onEnterFrame );
			}
			else
			{
				d.addEventListener( Event.ENTER_FRAME, onEnterFrameFade );
			}
			*/
		}
		
		private function bure ( d :DisplayObject, param :Object ) :void
		{
			var i :int;
			var len :int = ad.length;
			
			// 量
			var amount :Number;
			if ( 0 <= param.amount )	amount = param.amount;
			else 						amount = 20;
			
			prm.amountX = new Array();
			prm.amountY = new Array();
			for ( i = 0; i < len; i ++ ) { prm.amountX[i] = amount; prm.amountY[i] = amount; }
			
			if ( 0 <= param.amountX ) for ( i = 0; i < len; i ++ ) prm.amountX[i] = param.amountX;
			if ( 0 <= param.amountY ) for ( i = 0; i < len; i ++ ) prm.amountY[i] = param.amountY;
			
			// 速度
			if ( 0 < param.speed ) { prm.speedX = prm.speedY = param.speed;	}
			else 				   { prm.speedX = prm.speedY = 3;			}
			
			if ( 0 < param.speedX )		prm.speedX = param.speedX;
			if ( 0 < param.speedY )		prm.speedY = param.speedY;
			
			// 間隔
			if ( 0 < param.interval )	prm.interval = param.interval;
			else 						prm.interval = 100;
			
			
			
			// prm2
			var s :Number = prm.amountX[0] / prm.speedX;
			if ( s < prm.amountY[0] / prm.speedY ) s = prm.amountY[0] / prm.speedY;
			
			if ( prm.amountY[0] == 0 && prm.amountX[0] == 0 )
			{
				s = 7;
			}
			
			prm2.s = Math.floor( s );
			prm2.n = new Array();
			for ( i = 0; i < len; i ++ )	prm2.n[i] = 0;
			
			/*
			// 初回の実行
			nn = 1;
			var me :MotionEvent = new MotionEvent( MotionEvent.PROGRESS );
			me.count = nn;
			dispatchEvent( me );
			
			if ( 1 < len )
			{
				// タイマーイベント
				var t :Timer = new Timer( prm.interval, len-1 );
				t.addEventListener( TimerEvent.TIMER, onMotionTimerProgress );
				t.start();
			}
			*/
			
			nn = 0;
			d.addEventListener( Event.ENTER_FRAME, onEnterFrame );
			
		}
		
		private function onMotionTimerProgress ( evt :TimerEvent ) :void
		{
			//nn = evt.target.currentCount + 3;
			nn = evt.target.currentCount + Math.floor(10/prm.interval) + 1;
			
			if ( ad.length < nn )
			{
				nn = ad.length;
				evt.target.removeEventListener( TimerEvent.TIMER, onMotionTimerProgress );
			}
			
			// MotionEvent.PROGRESS
			var me :MotionEvent = new MotionEvent( MotionEvent.PROGRESS );
			me.count = nn;
			dispatchEvent( me );
			
		}
		private function ProgressCount ( ) :void
		{
			nn = nn + Math.floor(10/prm.interval) + 1;
			
			if ( ad.length < nn )
				nn = ad.length;
			
			var me :MotionEvent = new MotionEvent( MotionEvent.PROGRESS );
			me.count = nn;
			dispatchEvent( me );
		}
		
		private function onEnterFrame ( evt :Event ) :void
		{
			
			ProgressCount();	// ----- 09 teru
			
			var i :int;
			
			// bure
			for ( i = sn; i < nn; i ++ )
			{
				ad[i].x = pos[i].x + Math.random() * prm.amountX[i] - prm.amountX[i]/2;
				ad[i].y = pos[i].y + Math.random() * prm.amountY[i] - prm.amountY[i]/2;
				
				prm.amountX[i] -= prm.speedX;	if ( prm.amountX[i] < 0 ) prm.amountX[i] = 0;
				prm.amountY[i] -= prm.speedY;	if ( prm.amountY[i] < 0 ) prm.amountY[i] = 0;
				
				
				// ブレの量が両軸 0 になったら
				if ( prm.amountX[i] == 0 && prm.amountY[i] == 0 )
				{
					ad[i].x = pos[i].x;
					ad[i].y = pos[i].y;
					//
					sn = i + 1;
				}
				
			}
			
			// fade
			for ( i = sn2; i < nn; i ++ )
			{
				var d :Number;
				
				switch ( prm2.type )
				{
					case "LINEAR" :
						
						d = ( prm2.end - prm2.start ) / prm2.s;
						ad[i].alpha += d;
						if ( prm2.start < prm2.end ) {
							if ( prm2.end < ad[i].alpha )	ad[i].alpha = prm2.end;
						} else {
							if ( ad[i].alpha < prm2.end )	ad[i].alpha = prm2.end;
						}
					break;
					case "EASEIN" :
						
						if ( prm2.n[i] < prm2.s )
						{
							d = ( prm2.end - prm2.start ) * Math.pow( prm2.n[i] / prm2.s, 2.0 );
							ad[i].alpha = prm2.start + d;
							prm2.n[i] ++;
						}
						else	ad[i].alpha = prm2.end;
						
					break;
					case "EASEOUT" :
						
						if ( prm2.n[i] < prm2.s )
						{
							d = ( prm2.end - prm2.start ) * Math.pow( prm2.n[i] / prm2.s, 0.5 );
							ad[i].alpha = prm2.start + d;
							prm2.n[i] ++;
						}
						else	ad[i].alpha = prm2.end;
						
					break;
					default :
						ad[i].alpha = prm2.end;
					break;
				}
				if ( ad[i].alpha == prm2.end )	sn2 = i + 1;
			}
			
			if ( sn == ad.length && sn2 == ad.length )
			{
				evt.target.removeEventListener( Event.ENTER_FRAME, onEnterFrame );
				
				// MotionEvent.Complete
				var me :MotionEvent = new MotionEvent( MotionEvent.COMPLETE );
				dispatchEvent( me );
			}
		}
		
		
		public function get dispObj():DisplayObject { return _dispObj; }
	}
}