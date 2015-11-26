package com.papiness.utils
{
	import flash.display.*;
	import flash.events.*;
	import flash.ui.Keyboard;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import com.papiness.transitions.TweenSequencer;
	
	
	/**
	 * FlashIDE のドキュメントクラスで用いる、スライド作成支援のためのクラスです。
	 * 
	 * <p>MainTimeline に MovieClip を設置（インスタンス名不要）し、
	 * その MC 内に 1 frame 毎にスライドを作成していきます。</p>
	 * <p>
	 * <table><tr><th>【スライドの操作】</th><th> </th></tr>
	 * <tr><td>←, → </td><td> : ページ送り</td></tr>
	 * <tr><td>↓, ↑ </td><td> : ページ送り(5)</td></tr>
	 * <tr><td>SPACE </td><td> : ページ番号表示</td></tr>
	 * <tr><td>Q, A, S </td><td> : Quality,Align,ScaleMode の切り替え</td></tr>
	 * <tr><td>SHIFT+MouseDrag </td><td> : ペイント</td></tr>
	 * <tr><td>DELETE </td><td> : ペイントの消去</td></tr></table>
	 * </p>
	 * @author daniwell
	 * @see com.papiness.transitions.TweenSequencer
	 */
	public class Slides extends MovieClip
	{
		private var ts :TweenSequencer;
		
		private var slides	:MovieClip;
		private var sw		:int;		// スライド横
		private var sh		:int;		// スライド縦
		
		private var total	:int;		// トータルフレーム
		private var now		:int;		// 現在フレーム
		
		private var lock :Boolean = false;	// transition のロック
		private var next :int;				// 次移動するフレーム
		
		private var maskClip :MovieClip;
		
		private var page 	:TextField;			// page 番号
		private var tformat	:TextFormat;		// 
		private var tflag	:Boolean = false;	// page 番号表示 / 非表示 フラグ
		
		private var sparr :/*Sprite*/Array;		// ペイント用 Sprite
		private var downFlag :Boolean = false;	// マウス押下時のフラグ
		private var pt :Point = new Point();	// 押下時の座標
		
		private var status :TextField;
		private var format :TextFormat;
		private var timer :Timer;
		
		/*
		[ TextField 設置 ]
		Slide 用の MC 内
			    1 frame : quality, align, scaleMode
			every frame : transition
		*/
		
		
		/** @private */
		public function Slides() :void
		{
			if ( stage ) init();
			else addEventListener( Event.ADDED_TO_STAGE, init );
		}
		private function init ( ) :void
		{
			removeEventListener( Event.ADDED_TO_STAGE, init );
			
			if ( this.numChildren - 1 == -1 )
			{
				trace("Please Set MovieClip on Stage.");
			}
			else
			{
				if ( this.getChildByName("slide") != null )
					slides = this.getChildByName("slide") as MovieClip;
				else
					slides = this.getChildAt(0) as MovieClip;
				slides.stop();
				
				sw = stage.stageWidth;  //slides.width;
				sh = stage.stageHeight; //slides.height;
				
				total = slides.totalFrames;
				
				sparr = new Array();
				for ( var i :int = 0; i < total; i ++ )
				{
					sparr[i] = new Sprite();
					sparr[i].visible = false;
					addChild(sparr[i]);
				}
				
				// quality, align, scaleMode
				if ( stage.quality is TextField )		stage.quality = slides.quality.text;
				else									stage.quality = StageQuality.HIGH
				if ( slides.align is TextField )		stage.align = slides.align.text;	
				else									stage.align = "";
				if ( slides.scaleMode is TextField )	stage.scaleMode = slides.scaleMode.text
				else									stage.scaleMode = StageScaleMode.SHOW_ALL;
				// -----------------------------------------
				initText();
				
				now = 1;
				checkPageNum( 1 );
				
				// mask
				maskClip = new MovieClip();
				maskClip.graphics.beginFill(0);
				maskClip.graphics.drawRect(0, 0, sw, sh);
				addChild( maskClip );
				slides.mask = maskClip;
				
				
				initEvent();
			}
		}
		private function initText ( ) :void
		{
			page = new TextField();
			tformat = new TextFormat();
			
			page.text = now + " / " + total;
			page.autoSize = "right";
			page.selectable = false;
			page.textColor = 0x555555;
			
			tformat.letterSpacing = 2;
			page.setTextFormat( tformat );
			
			page.x = sw - page.width - 10;
			page.y = sh - page.height - 10;
			page.visible = tflag;
			
			addChild( page );
			
			
			
			// status
			status = new TextField();
			status.autoSize = "left";
			addChild( status );
			
			format = new TextFormat();
			format.letterSpacing = 2;
			format.color = 0xff0000;
			format.font = "ＭＳ ゴシック";
			
			timer = new Timer(1000, 1);
			timer.addEventListener(TimerEvent.TIMER, timerEventHandler);
			
		}
		private function timerEventHandler ( evt :TimerEvent ) :void
		{
			status.visible = false;
		}
		
		private function initEvent ( ) :void
		{
			ts = new TweenSequencer();
			ts.addEventListener( TweenSequencer.COMPLETE, tsComplete );
			ts.addEventListener( TweenSequencer.PROGRESS, tsProgress );
			
			this.stage.addEventListener( MouseEvent.MOUSE_DOWN, mouseDown );
			this.stage.addEventListener( MouseEvent.MOUSE_UP, mouseUp );
			this.stage.addEventListener( MouseEvent.MOUSE_MOVE, mouseMove );
			
			this.stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDown );
		}
		
		private function mouseDown ( evt :MouseEvent) :void 
		{
			if ( ! evt.shiftKey )
			{
				var s :String = new String();
				if ( slides.transition is TextField )
					s = slides.transition.text;
				transition( 1, s );
			}
			else
			{ 
				pt = new Point( mouseX, mouseY );
				downFlag = true;
			}
		}
		private function mouseUp ( evt :MouseEvent) :void 
		{
			downFlag = false;
		}
		private function mouseMove ( evt :MouseEvent) :void 
		{
			if ( evt.shiftKey )
			{
				if ( downFlag )
				{
					var gr :Graphics = sparr[now-1].graphics;
					gr.lineStyle(2, 0xffff0000);
					gr.moveTo(pt.x,pt.y);
					gr.lineTo(mouseX,mouseY);
					
					pt.x = mouseX;
					pt.y = mouseY;
				}
			}
		}
		
		/* ←, →, ↑, ↓, SPACE, DELETE, Q, A, S, M */
		private function keyDown ( evt :KeyboardEvent ) :void 
		{
			var s :String = new String();
			
			switch ( evt.keyCode )
			{
			case Keyboard.LEFT:		// ←
				transition( -1, s );
				break;
			case Keyboard.RIGHT:	// ←
				if ( slides.transition is TextField )
					s = slides.transition.text;
				transition(  1, s );
				break;
			case Keyboard.DOWN:		// ↓
				transition( -5, s );
				break;
			case Keyboard.UP:		// ↑
				if ( slides.transition is TextField )
					s = slides.transition.text;
				transition(  5, s );
				break;
			case Keyboard.SPACE:
				tflag = ! tflag;
				page.visible = tflag;
				
				break;
			case Keyboard.DELETE:
				sparr[now-1].graphics.clear();
				break;
			case 83:    // S
				switch ( stage.scaleMode ) {
				case "exactFit":	stage.scaleMode = "noBorder";	break;
				case "noBorder":	stage.scaleMode = "noScale";	break;
				case "noScale":		stage.scaleMode = "showAll";	break;
				case "showAll":		stage.scaleMode = "exactFit";	break;
				}
				changeText("ScaleMode :"+stage.scaleMode);
				
				break;
			case 81:    // Q
				switch ( stage.quality ) {
				case "HIGH":	stage.quality = "MEDIUM";	break;
				case "MEDIUM":	stage.quality = "LOW";		break;
				case "LOW":		stage.quality = "HIGH";		break;
				}
				changeText("Quality :"+stage.quality);
				
				break;
			case 65:    // A
				var a :Array = [ "TL", "T", "TR", "L", "", "R", "BL", "B", "BR" ];
				var sa :String = stage.align;
				for ( var i :int = 0; i < a.length; i ++ ) {
					if ( sa == a[i] ) {
						if ( i + 1 != a.length )	stage.align = a[i + 1];
						else						stage.align = a[0];
					}
				}
				changeText("Align :" + stage.align);
				
				break;
			case 77:    // M
				if ( slides.mask )	{ maskClip.visible = false; slides.mask = null; }
				else				{ maskClip.visible = true; slides.mask = maskClip; }
				break;
			}
		}
		
		private function changeText ( str :String ) :void
		{
			status.text = str;
			status.setTextFormat( format );
			status.visible = true;
				
			timer.reset();
			timer.start();
		}
		
		private function transition ( num :int, s :String ) :Boolean
		{
			next = slides.currentFrame + num;
			
			if ( next <= 0 || total < next ) return false;
			if ( lock ) return false;
			lock = true;
			
			var a :/*String*/Array = s.split(",");
			
			switch ( a[0].toLowerCase() )
			{
			case "fade":
				var t :Number = 0.4;
				if ( a[1] )
					if ( 0 < parseFloat(a[1]) )
						t = parseFloat(a[1]);
				
				ts.clear();
				ts.add( slides, { alpha :0, time :t } );
				ts.add( slides, { alpha :1, time :t } );
				ts.start();
				break;
			default :
				slides.gotoAndStop( next );
				checkPageNum( next );
				
				ts.clear();
				ts.addWait( 0 );
				ts.start();
				break;
			}
			return true;
		}
		
		private function tsProgress ( evt :Event ) :void
		{
			if ( ts.now == 2 ) {
				slides.gotoAndStop( next );
				checkPageNum( next );
			}
		}
		private function tsComplete ( evt :Event ) :void
		{
			lock = false;
		}
		
		private function checkPageNum ( n :Number ) :void
		{
			sparr[now-1].visible = false;
			now = n;
			sparr[now-1].visible = true;
			
			page.text = now + " / " + total;
			page.setTextFormat( tformat );
		}
		
	}
}