package com.papiness.controller 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	
	/** @eventType Event.CHANGE */
	[Event(name="change", type="flash.events.Event")]
	
	/**
	 * 垂直スクロールバー
	 */
	public class ScrollManager extends EventDispatcher
	{
		private var _stage :Stage;
		
		private var _scrollBar :DisplayObjectContainer;
		private var _scrollBg  :DisplayObjectContainer;
		
		private var _barH :int;		// bar 高さ
		private var _bgH  :int;		// bg  高さ
		
		private var _moveH :int;	// 稼動範囲
		
		private var _isMouseDown :Boolean;
		
		
		private var _baseY      :int;	// 基準高さ(bg.y)
		private var _mouseDownY :int;	// bar のクリックした位置
		
		private var _position :Number;
		
		/**
		 * 
		 * @param	stage
		 */
		public function ScrollManager ( stage :Stage ) 
		{
			_stage = stage;
		}
		
		/**
		 * bar & bg は 同階層 & 上揃え
		 * @param	bar
		 * @param	bg
		 */
		public function init ( bar :DisplayObjectContainer, bg :DisplayObjectContainer ) :void
		{
			if (_scrollBar)
			{
				_scrollBg.removeEventListener(MouseEvent.MOUSE_DOWN, _mouseDownBg);
				
				_scrollBar.removeEventListener(MouseEvent.MOUSE_DOWN, _mouseDown);
					_stage.removeEventListener(MouseEvent.MOUSE_MOVE, _mouseMove);
					_stage.removeEventListener(MouseEvent.MOUSE_UP,   _mouseUp);
			}
			
			if (bar is Sprite) Sprite(bar).buttonMode = true;
			if (bg  is Sprite) Sprite(bg ).buttonMode = true;
			if (bar is MovieClip) MovieClip(bar).buttonMode = true;
			if (bg  is MovieClip) MovieClip(bg ).buttonMode = true;
			
			_scrollBar = bar;
			_scrollBg  = bg;
			
			_barH = bar.height;
			_bgH  = bg.height;
			
			_baseY = bg.y;
			
			_moveH = _bgH - _barH;
			
			_scrollBg.addEventListener(MouseEvent.MOUSE_DOWN, _mouseDownBg);
			
			_scrollBar.addEventListener(MouseEvent.MOUSE_DOWN, _mouseDown);
			    _stage.addEventListener(MouseEvent.MOUSE_MOVE, _mouseMove);
			    _stage.addEventListener(MouseEvent.MOUSE_UP,   _mouseUp);
		}
		
		
		
		private function _mouseDownBg ( evt :MouseEvent ) :void 
		{
			_isMouseDown = true;
			
			_mouseDownY = _barH / 2;
			_mouseMove();
		}
		
		/* MOUSE DOWN */
		private function _mouseDown ( evt :MouseEvent ) :void 
		{
			_isMouseDown = true;
			
			_mouseDownY = _scrollBar.mouseY;
			_mouseMove();
		}
		/* MOUSE MOVE */
		private function _mouseMove ( evt :MouseEvent = null ) :void 
		{
			if (! _isMouseDown) return;
			
			
			var mY :Number = _scrollBg.mouseY - _baseY - _mouseDownY;
			if (mY < 0)      mY = 0;
			if (_moveH < mY) mY = _moveH;
			
			_scrollBar.y = mY + _baseY;
			
			_position = mY / _moveH;
			dispatchEvent(new Event(Event.CHANGE));
		}
		/* MOUSE UP */
		private function _mouseUp ( evt :MouseEvent ) :void 
		{
			_isMouseDown = false;
		}
		
		
		/** 現在位置 (0-1) */
		public function get position ( ) :Number { return _position; }
	}
}