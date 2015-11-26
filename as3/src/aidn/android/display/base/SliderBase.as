package aidn.android.display.base 
{
	import aidn.android.events.SliderEvent;
	import aidn.main.display.base.DisplayBase;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Rectangle;
	import flash.ui.Multitouch;
	
	/** @eventType SliderEvent.CHANGE */
	[Event(name="sliderChange", type="aidn.android.events.SliderEvent")]
	
	
	
	public class SliderBase extends DisplayBase
	{
		
		private var _stage :Stage;
		
		private var _nob :MovieClip;
		private var _bar :MovieClip;
		
		private var _isHorizon :Boolean;
		
		private var _value     :Number;
		private var _maxLength :int;
		
		private var _rect :Rectangle;
		
		private var _bbNob :ButtonBase;
		private var _bbBar :ButtonBase;
		
		
		public function SliderBase ( dobj :DisplayObjectContainer, stage :Stage, nobName :String = "nob", barName :String = "bar" ) 
		{
			super(dobj);
			
			_stage = stage;
			
			_nob = dobj.getChildByName(nobName) as MovieClip;
			_bar = dobj.getChildByName(barName) as MovieClip;
			
			_bbNob = new ButtonBase(_nob);
			_bbBar = new ButtonBase(_bar); 
			
			_init();
		}
		
		// ------------------------------------------------------------------- public
		
		public function setLength ( length :int ) :void
		{
			if (_isHorizon)	_bar.width  = length;
			else			_bar.height = length;
			
			_updateLength();
		}
		
		// ------------------------------------------------------------------- private
		
		private function _init ( ) :void
		{
			// 水平 or 垂直 の判別
			if (_bar.width < _bar.height)	_isHorizon = false;
			else							_isHorizon = true;
			
			// 初期化
			_value = 0;
			
			if (_isHorizon)
			{
				_maxLength = _bar.width - _nob.width;
				_nob.x = 0;
				_rect = new Rectangle(0, _nob.y, _maxLength, _nob.y);
			}
			else
			{
				_maxLength = _bar.height - _nob.height;
				_nob.y = 0;
				_rect = new Rectangle(_nob.x, 0, _nob.x, _maxLength);
			}
			
			if (Multitouch.supportsTouchEvents)
			{
				_nob.addEventListener(TouchEvent.TOUCH_BEGIN, _nobTouchBegin);
				_bar.addEventListener(TouchEvent.TOUCH_BEGIN, _barTouchBegin);
			}
			else
			{
				_nob.addEventListener(MouseEvent.MOUSE_DOWN, _nobMouseDown);
				_bar.addEventListener(MouseEvent.MOUSE_DOWN, _barMouseDown);
			}
		}
		
		private function _update ( ) :void
		{
			var val :Number;
			if (_isHorizon) val = _nob.x / _maxLength;
			else			val = _nob.y / _maxLength;
			
			if (val != _value)
			{
				_value = val; 
				
				var e :SliderEvent = new SliderEvent(SliderEvent.CHANGE);
				e.value = val;
				dispatchEvent(e);
			}
		}
		
		private function _updateLength ( ) :void
		{
			if (_isHorizon)
			{
				_maxLength = _bar.width - _nob.width;
				_rect = new Rectangle(0, _nob.y, _maxLength, _nob.y);
			}
			else
			{
				_maxLength = _bar.height - _nob.height;
				_rect = new Rectangle(_nob.x, 0, _nob.x, _maxLength);
			}
			
			this.value = _value;
		}
		
		// ------------------------------------------------------------------- Event
		
		private function _nobTouchBegin ( evt :TouchEvent ) :void 
		{
			_nob.startTouchDrag(evt.touchPointID, false, _rect);
			
			__nobBegin();
			_stage.addEventListener(TouchEvent.TOUCH_END, _touchEnd);
		}
		private function _barTouchBegin ( evt :TouchEvent ) :void 
		{
			__barBegin();
			_nobTouchBegin(evt);
		}
		
		private function _nobMouseDown ( evt :MouseEvent ) :void
		{
			_nob.startDrag(false, _rect);
			
			__nobBegin();
			_stage.addEventListener(MouseEvent.MOUSE_UP, _mouseUp);
		}
		private function _barMouseDown ( evt :MouseEvent ) :void
		{
			__barBegin();
			_nobMouseDown(evt);
		}
		
		private function __nobBegin ( ) :void
		{
			_update();
			_stage.addEventListener(Event.ENTER_FRAME,   _enterFrame);
		}
		private function __barBegin ( ) :void
		{
			if (_isHorizon)
			{
				_nob.x = _bar.mouseX * _bar.scaleX - _nob.width / 2;
				if (_nob.x < 0) _nob.x = 0;
				if (_maxLength < _nob.x) _nob.x = _maxLength;
			}
			else
			{
				_nob.y = _bar.mouseY * _bar.scaleY - _nob.height / 2;
				if (_nob.y < 0) _nob.y = 0;
				if (_maxLength < _nob.y) _nob.y = _maxLength;
			}
		}
		
		private function _enterFrame ( evt :Event ) :void 
		{
			_update();
		}
		
		private function _touchEnd ( evt :TouchEvent ) :void 
		{
			__end();
			_nob.stopTouchDrag(evt.touchPointID);
		}
		private function _mouseUp ( evt :MouseEvent ) :void
		{
			__end();
			_nob.stopDrag();
		}
		private function __end (  ):void
		{
			_stage.removeEventListener(Event.ENTER_FRAME,   _enterFrame);
			_stage.removeEventListener(TouchEvent.TOUCH_END, _touchEnd);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, _mouseUp);
			_update();
		}
		
		// ------------------------------------------------------------------- getter & setter
		
		public function get value ( ) :Number { return _value; }
		
		public function set value ( value :Number ) :void 
		{
			if (value < 0) value = 0;
			if (1 < value) value = 1;
			
			_value = value;
			
			if (_isHorizon)	_nob.x = _maxLength * _value;
			else			_nob.y = _maxLength * _value;
		}
		
		public function get nob():MovieClip { return _nob; }
		public function get bar():MovieClip { return _bar; }
	}
}