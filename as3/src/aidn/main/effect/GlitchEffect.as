package aidn.main.effect 
{
	import aidn.main.core.StageReference;
	import aidn.main.util.MathUtil;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class GlitchEffect 
	{
		private var _target :DisplayObject;
		
		private var _bmd :BitmapData;
		private var _bmp :Bitmap;
		
		private var _glitch :Number = 0.5;
		
		private var _matrix :Matrix;
		
		private var _fixCount :int = 0;
		
		private var _width   :int;
		private var _height  :int;
		
		
		public function GlitchEffect ( target :DisplayObject, w :int = -1, h :int = -1 ) 
		{
			_target = target;
			
			_width  = w;
			_height = h;
			if (_width  <= 0) _width  = _target.width;
			if (_height <= 0) _height = _target.height;
			
			_init();
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
		private function _init ( ) :void
		{
			_matrix = new Matrix();
			
			_bmd = new BitmapData(_width, _height, true, 0x0);
			_bmp = new Bitmap(_bmd);
		}
		
		/// ENTER FRAME
		private function _enterFrame ( ) :void
		{
			if (_fixCount -- < 0)
			{
				_matrix.a = _matrix.d = 1.0;
				_matrix.tx = _matrix.ty = 0;
				
				if (Math.random() < 0.35 * _glitch)
				{
					_fixCount = MathUtil.randInt(0, 8 + 3 * _glitch);
					
					_matrix.a = MathUtil.rand(0.5, 2.5);
					_matrix.d = MathUtil.rand(0.5, 2.5);
					_matrix.tx = - Math.random() * 200;
					_matrix.ty = - Math.random() * 200;
				}
			}
			
			_bmd.draw(_target, _matrix);
			
			var rect :Rectangle = _bmd.rect;
			var i :int, l :int;
			
			l = Math.round(_glitch * 5);
			for (i = 0; i < l; i ++)
			{
				rect.height = MathUtil.rand(0, 0.32 * _height);
				rect.width = _bmd.width;
				if (Math.random() < 0.2) rect.width *= Math.random();
				_bmd.copyPixels(_bmd, rect, new Point(0, Math.random() * _bmd.height));
			}
			
			
			l = Math.round(_glitch * 4);
			for (i = 0; i < l; i ++)
			{
				rect.height = MathUtil.rand(0, 0.16 * _height);
				rect.width = _bmd.width;
				if (Math.random() < 0.2) rect.width *= Math.random();
				_bmd.copyChannel(_bmd, rect, new Point(0, Math.random() * _bmd.height), MathUtil.randInt(1, 15), MathUtil.randInt(1, 15));
			}
		}
		
		public function get bitmap ( ) :Bitmap { return _bmp; }
		
		public function get glitch ( ) :Number 
		{
			return _glitch;
		}
		
		public function set glitch ( value :Number ) :void 
		{
			_glitch = value;
		}
	}
}