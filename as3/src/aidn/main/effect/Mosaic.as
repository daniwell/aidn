package aidn.main.effect 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	public class Mosaic 
	{
		private var _target :MovieClip;
		private var _bitmap :Bitmap;
		
		private var _blankBmd :BitmapData;
		
		private var _tmp :BitmapData;
		private var _bmd :BitmapData;
		
		private var _mat :Matrix = new Matrix();
		private var _pt  :Point  = new Point();
		
		private var _n     :int;
		private var _speed :int;
		
		public function Mosaic ( ) 
		{
			
		}
		
		// ------------------------------------------------------------------- public
		
		public function init ( target :MovieClip, n :int, speed :int ) :void
		{
			_target = target;
			
			_n     = n;
			_speed = speed;
			
			_kill();
			
			_blankBmd = new BitmapData(_target.width, _target.height, true, 0x0);
			_tmp      = new BitmapData(_target.width, _target.height, true, 0x0);
			_bmd      = new BitmapData(_target.width, _target.height, true, 0x0);
			
			_bitmap = new Bitmap(_bmd);
			
			_target.parent.addChild(_bitmap);
			_bitmap.x = _target.x;
			_bitmap.y = _target.y;
		}
		
		public function update ( ) :Boolean 
		{
			if (_target.visible) _target.visible = false;
			
			_tmp.copyPixels(_blankBmd, _blankBmd.rect, _pt);
			// _bmd.copyPixels(_blankBmd, _blankBmd.rect, _pt);
			
			_mat.identity();
			_mat.scale(1 / _n, 1 / _n);
			
			_tmp.draw(_target, _mat);
			
			_mat.identity();
			_mat.scale(_n, _n);
			
			_bmd.draw(_tmp, _mat);
			
			
			_n -= _speed;
			if (_n < 1)
			{
				_n = 1;
				_target.visible = true;
				_kill();
				
				return true;
			}
			return false;
		}	
		
		// ------------------------------------------------------------------- private
		
		private function _kill ( ) :void
		{
			if (_blankBmd) { _blankBmd.dispose(); _blankBmd = null; }
			if (_tmp) { _tmp.dispose(); _tmp = null; }
			if (_bmd) { _bmd.dispose(); _bmd = null; }
			
			if (_bitmap)
			{
				_bitmap.parent.removeChild(_bitmap);
				_bitmap = null;
			}
		}
		
	}
}