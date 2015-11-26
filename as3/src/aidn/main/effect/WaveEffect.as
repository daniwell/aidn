package aidn.main.effect 
{
	import aidn.main.core.StageReference;
	import aidn.main.util.MathUtil;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.DisplayObject;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	public class WaveEffect 
	{
		private var _target :DisplayObject;
		
		private var _wave  :Number = 0.5;
		private var _speed :Number = 0.5;
		
		private var _bmdDmap :BitmapData;
		private var _offsets :/*Point*/Array;
		private var _speeds  :/*Point*/Array;
		private var _oct     :int;
		
		private var _width   :int;
		private var _height  :int;
		
		private var _matrixDmap  :Matrix;
		
		private var _mapBmd     :BitmapData;
		private var _dmapFilter :DisplacementMapFilter;
		
		private var _seed :int = MathUtil.randInt(0, 1000000);
		
		
		public function WaveEffect ( target :DisplayObject, w :int = -1, h :int = -1, wave :Number = 0.5, speed :Number = 0.5 ) 
		{
			_target = target;
			
			_width  = w;
			_height = h;
			if (_width  <= 0) _width  = _target.width;
			if (_height <= 0) _height = _target.height;
			
			_init(wave, speed);
		}
		/// START
		public function start ( ) :void
		{
			StageReference.addEnterFrameFunction(_enterFrame);
		}
		/// STOP
		public function stop ( ) :void
		{
			StageReference.removeEnterFrameFunction(_enterFrame);
		}
		
		
		
		/// INIT
		private function _init ( wave :Number, speed :Number ) :void
		{
			var w :int  = 64;
			var h :int  = w * (_height / _width);
			
			_bmdDmap = new BitmapData(w, h, false, 0xffffffff);
			_offsets = [];
			_speeds  = [];
			_oct     = 3;
			
			_matrixDmap = new Matrix(_width / w, 0, 0, _height / h);
			_mapBmd     = new BitmapData(_width, _height, false);
			_dmapFilter = new DisplacementMapFilter(_mapBmd, new Point(0, 0), 1, 2, 100, 100, DisplacementMapFilterMode.WRAP);
			
			_wave = wave;
			this.speed = speed;
		}
		
		/// ENTER FRAME
		private function _enterFrame ( ) :void 
		{
			_dmapFilter.scaleX = _wave * 400 * Math.sin(getTimer() / 435);
			_dmapFilter.scaleY = _wave * 400 * Math.sin(getTimer() / 390);
			
			for (var i :int = 0; i < _oct; i++)
			{
				_offsets[i].x += _speeds[i].x;
				_offsets[i].y += _speeds[i].y;
				_bmdDmap.perlinNoise(_width, _height, _oct, _seed, true, false, 3, true, _offsets);
			}
			
			_mapBmd.draw(_bmdDmap, _matrixDmap, null, null, null, true);
			
			_target.filters = [_dmapFilter]; ///
		}
		
		public function get wave ( ) :Number { return _wave; }
		public function set wave ( value :Number ) :void { _wave = value; }
		
		public function get speed ( ) :Number { return _speed; }
		
		public function set speed ( value :Number ) :void 
		{
			var sp :Number = 15 * _speed;
			
			for (var i :int = 0; i < _oct; i ++)
			{
				_offsets[i] = new Point();
				 _speeds[i] = new Point(MathUtil.rand( -sp, sp), MathUtil.rand( -sp, sp));
			}
			_speed = value;
		}
	}

}