package com.papiness.effects
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.filters.ConvolutionFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class RippleEffectBitmap
	{
		private var _target  :Bitmap;
		private var _tmpBmd  :BitmapData;
		private var _tmpRect :Rectangle;
		
		
		private var _bmd1 :BitmapData;
		private var _bmd2 :BitmapData;
		
		private var _bmdDef :BitmapData;
		
		
		private var _drawRect :Rectangle;
		private var _rect     :Rectangle;
		private var _point    :Point;
		
		
		private var _dispFilter :DisplacementMapFilter;
		private var _convFilter :ConvolutionFilter;
		
		private var _colourTransform :ColorTransform;
		
		private var _matrix   :Matrix;
		private var _scaleInv :Number;
		
		private var _isStarting :Boolean;
		
		public function RippleEffectBitmap ( )
		{
			_init();
		}
		
		// ------------------------------------------------------------------- private methods
		
		public function init ( source :Bitmap, strength :Number, scale :Number = 16 ) :void
		{
			kill();
			
			
			var tmpScaleX :Number = source.scaleX;
			var tmpScaleY :Number = source.scaleY;
			source.scaleX = source.scaleY = 1;
			
			var correctedScaleX :Number;
			var correctedScaleY :Number;
			
			_target   = source;
			_scaleInv = 1/scale;
			
			_bmd1   = new BitmapData( source.width * _scaleInv, source.height * _scaleInv, false, 0x000000);
			_bmd2   = _bmd1.clone();
			_bmdDef = new BitmapData( source.width,             source.height,             false, 0x7f7f7f);
			
			correctedScaleX = _bmdDef.width  / _bmd1.width;
			correctedScaleY = _bmdDef.height / _bmd1.height;
			
			_rect     = new Rectangle(0, 0, _bmd1.width, _bmd1.height);
			_drawRect = new Rectangle();
			
			_dispFilter = new DisplacementMapFilter(_bmdDef, _point, BitmapDataChannel.BLUE, BitmapDataChannel.BLUE, strength, strength, "wrap");
			
			_convFilter      = new ConvolutionFilter(3, 3, [0.5, 1, 0.5, 1, 0, 1, 0.5, 1, 0.5], 3);
			_colourTransform = new ColorTransform(1, 1, 1, 1, 128, 128, 128);
			_matrix          = new Matrix(correctedScaleX, 0, 0, correctedScaleY);
			
			
			//
			source.smoothing = true;
			_tmpBmd  = source.bitmapData.clone();
			_tmpRect = new Rectangle(0, 0, _tmpBmd.width, _tmpBmd.height);
			
			source.scaleX = tmpScaleX;
			source.scaleY = tmpScaleY;
		}
		
		public function start ( ) :void
		{
			_isStarting = true;
			
			_target.removeEventListener(Event.ENTER_FRAME, _enterFrame);
			_target.addEventListener(Event.ENTER_FRAME, _enterFrame);
		}
		public function stop ( ) :void
		{
			_isStarting = false;
			_target.removeEventListener(Event.ENTER_FRAME, _enterFrame);
		}
		
		public function addRipple ( x :int, y :int, size :int ) :void
		{
			var h :int = size >> 1;
			
			_drawRect.x = ( - h + x) * _scaleInv;	
			_drawRect.y = ( - h + y) * _scaleInv;
			_drawRect.width = _drawRect.height = size * _scaleInv;
			_bmd1.fillRect(_drawRect, 255);
		}
		
		public function kill ( ) :void
		{
			_isStarting = false;
			
			if (_target)
			{
				_target.bitmapData = _tmpBmd.clone();
				_target.removeEventListener(Event.ENTER_FRAME, _enterFrame);
			}
			if (_bmd1)     _bmd1.dispose();
			if (_bmd2)     _bmd2.dispose();
			if (_bmdDef) _bmdDef.dispose();
		}
		
		public function getDefBmd ( ) :BitmapData
		{
			return _bmdDef;
		}
		
		// ------------------------------------------------------------------- private methods
		
		private function _init ( ) :void
		{
			_point = new Point();
		}
		
		private function _switchBitmapData ( ) :void
		{
			var tmp :BitmapData;
			
			 tmp  = _bmd1;
			_bmd1 = _bmd2;
			_bmd2 =  tmp;
		}
		
		// ------------------------------------------------------------------- Event
		
		private function _enterFrame ( event :Event) :void
		{
			var tmp :BitmapData = _bmd2.clone();
			
			_bmd2.applyFilter(_bmd1, _rect, _point, _convFilter);
			_bmd2.draw(tmp, null, null, BlendMode.SUBTRACT, null, false);
			_bmdDef.draw(_bmd2, _matrix, _colourTransform, null, null, true);
			
			
			_target.bitmapData = _tmpBmd.clone();
			_target.bitmapData.applyFilter(_target.bitmapData, _tmpRect, _point, _dispFilter);
			
			
			tmp.dispose();
			
			_switchBitmapData();
		}
		
		// ------------------------------------------------------------------- getter
		
		public function get isStarting ( ) :Boolean { return _isStarting; }
	}
}