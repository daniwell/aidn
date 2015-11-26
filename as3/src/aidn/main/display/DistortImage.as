package aidn.main.display 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	public class DistortImage extends Sprite
	{
		protected var _vertices :Vector.<Number>;
		protected var _indices  :Vector.<int>;
		protected var _uvtData  :Vector.<Number>;
		
		private var _bmd      :BitmapData;
		private var _division :int;
		
		
		public function DistortImage ( ) 
		{
			
		}
		
		// ------------------------------------------------------------------- public
		
		public function init ( bmd :BitmapData, division :int = 2 ) :void
		{
			_bmd      = bmd;
			_division = division;
			
			_vertices = new Vector.<Number>();
			_indices  = new Vector.<int>();
			_uvtData  = new Vector.<Number>();
			
			var n :int = _division - 1;
			
			for (var x :int = 0; x < _division; x ++)
			{
				for (var y :int = 0; y < _division; y ++)
				{
					_uvtData.push(x / n, y / n);
				}
			}
			
			for (var i :int = 0; i < _division - 1; i ++)
			{
				for (var j :int = 0; j < _division - 1; j ++)
				{
					_indices.push(i * _division + j,      i      * _division + j + 1, (i + 1) * _division + j);
					_indices.push(i * _division + j + 1, (i + 1) * _division + 1 + j, (i + 1) * _division + j);
				}
			}
		}
		
		
		public function draw ( vertices :Vector.<Number> ) :void
		{
			if (! _bmd) return;
			
			_vertices = vertices;
			
			graphics.clear();
			graphics.beginBitmapFill(_bmd, null, false, true);
			graphics.drawTriangles(_vertices, _indices, _uvtData);
		}
		
		public function kill ( ) :void
		{
			graphics.clear();
			
			if (_bmd)
			{
				_bmd.dispose();
				_bmd = null;
			}
			
			if (parent) parent.removeChild(this);
		}
		
		// ------------------------------------------------------------------- private
		
	}
}