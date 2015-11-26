package aidn.main.display 
{
	import aidn.main.core.StageReference;
	import aidn.main.effect.PatternFilter;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	public class Loop extends Sprite
	{
		private var _width  :int;
		private var _height :int;
		private var _bmd    :BitmapData;
		
		private var _w :int;
		private var _h :int;
		
		private var _source :*;
		
		private var _scrollX :Boolean;
		private var _scrollY :Boolean;
		
		public function Loop ( source :*, w :int = -1, h :int = -1, sourceW :int = -1, sourceH :int = -1, scrollX :Boolean = true, scrollY :Boolean = true ) 
		{
			if (source is PatternFilter) source = source.bmd
			_source = source;
			
			_scrollX = scrollX;
			_scrollY = scrollY;
			
			_w = w;
			_h = h;
			_width  = source.width;
			_height = source.height;
			if (0 < sourceW) _width  = sourceW;
			if (0 < sourceH) _height = sourceH;
			
			_bmd = new BitmapData(_width, _height, true, 0x0);
			_bmd.draw(source);
			
			_resize();
			StageReference.addResizeFunction(_resize);
		}
		
		public function kill ( ) :void
		{
			StageReference.removeResizeFunction(_resize);
			
			if (_bmd)
			{
				_bmd.dispose();
				_bmd = null;
			}
		}
		
		public function updateBitmapData ( reset :Boolean  = false ) :void
		{
			if (reset) _bmd.fillRect(_bmd.rect, 0x0);
			_bmd.draw(_source);
		}
		
		public function setPosition ( x :int, y :int ) :void
		{
			super.x = x;
			super.y = y;
		}
		
		public function setSize ( w :int = -1, h :int = -1 ) :void { _w = w; _h = h; _resize(); }
		
		private function _resize ( ) :void
		{
			var g :Graphics = graphics;
			g.clear();
			g.beginBitmapFill(_bmd);
			
			var w :int = _w;
			var h :int = _h;
			if (w <= 0) w = StageReference.stageWidth;
			if (h <= 0) h = StageReference.stageHeight;
			
			if (_scrollX) w += _width;
			if (_scrollY) h += _height;
			
			g.drawRect(0, 0, w, h);
		}
		
		private var _x  :Number = 0;
		private var _y  :Number = 0;
		private var _xx :Number = 0;
		private var _yy :Number = 0;
		
		override public function get x ( ) :Number { return _x; }
		override public function get y ( ) :Number { return _y; }
		
		override public function set x ( value :Number ) :void 
		{
			_xx += value - _x;
			_x = value;
			while (1) { if (_xx < - _width) { _xx += _width; } else { break; } }
			while (1) { if (  0 <      _xx) { _xx -= _width; } else { break; } }
			super.x = _xx;
		}
		override public function set y ( value :Number ) :void 
		{
			_yy += value - _y;
			_y = value;
			while (1) { if (_yy < - _height) { _yy += _height; } else { break; } }
			while (1) { if (  0 <       _yy) { _yy -= _height; } else { break; } }
			super.y = _yy;
		}
		
	}
}