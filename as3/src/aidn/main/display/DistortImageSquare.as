package aidn.main.display 
{
	import caurina.transitions.Tweener;
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	public class DistortImageSquare extends DistortImage
	{
		private var _x1 :Number;
		private var _y1 :Number;
		
		private var _x2 :Number;
		private var _y2 :Number;
		
		private var _x3 :Number;
		private var _y3 :Number;
		
		private var _x4 :Number;
		private var _y4 :Number;
		
		
		
		public function DistortImageSquare ( ) 
		{
			
		}
		
		override public function init ( bmd :BitmapData, division :int = 2 ) :void 
		{
			division = 2;
			super.init(bmd, division);
		}
		
		override public function draw ( vertices :Vector.<Number> ) :void 
		{
			super.draw(vertices);
		}
		
		public function setVertices ( vertices :Vector.<Number> ) :void
		{
			if (vertices.length < 8) return;
			
			_x1 = vertices[0];
			_y1 = vertices[1];
			_x2 = vertices[2];
			_y2 = vertices[3];
			_x3 = vertices[4];
			_y3 = vertices[5];
			_x4 = vertices[6];
			_y4 = vertices[7];
		}
		
		public function updateDraw ( ) :void
		{
			_vertices[0] = _x1;
			_vertices[1] = _y1;
			_vertices[2] = _x2;
			_vertices[3] = _y2;
			_vertices[4] = _x3;
			_vertices[5] = _y3;
			_vertices[6] = _x4;
			_vertices[7] = _y4;
			
			this.draw(_vertices);
		}
		
		public function tween ( param :Object, time :Number = 0.0, transition :String = "easeOutExpo", delay :Number = 0.0, complete :Function = null, isUpdate :Boolean = true ) :void
		{
			var fix :Boolean = (time <= 0 && delay <= 0);
			
			for (var i :int = 1; i <= 4; i ++)
			{
				if (param["p"+i] is Point)
				{
					param["x"+i] = param["p"+i].x;
					param["y"+i] = param["p"+i].y;
					
					delete param["p"+i];
				}
			}
			
			if (fix)
			{
				for (i = 1; i <= 4; i ++)
				{
					if (param["x"+i] != null)	this["x"+i] = param["x"+i];
					if (param["y"+i] != null)	this["y"+i] = param["y"+i];
				}
				
				updateDraw();
				if (complete is Function) complete();
				return;
			}
			
			param.time       = time;
			param.transition = transition;
			param.delay      = delay;
			
			if (complete is Function) param.onComplete = complete;
			if (isUpdate)             param.onUpdate   = updateDraw;
			
			Tweener.addTween(this, param);
		}
		
		/// 左上 xp
		public function get x1 ( ) :Number { return _x1; }
		/// 左上 y
		public function get y1 ( ) :Number { return _y1; }
		/// 左下 x
		public function get x2 ( ) :Number { return _x2; }
		/// 左下 y
		public function get y2 ( ) :Number { return _y2; }
		/// 右上 x
		public function get x3 ( ) :Number { return _x3; }
		/// 右上 y
		public function get y3 ( ) :Number { return _y3; }
		/// 右下 x
		public function get x4 ( ) :Number { return _x4; }
		/// 右下 x
		public function get y4 ( ) :Number { return _y4; }
		
		
		public function set x1 ( value :Number ) :void { _x1 = value; }
		public function set y1 ( value :Number ) :void { _y1 = value; }
		public function set x2 ( value :Number ) :void { _x2 = value; }
		public function set y2 ( value :Number ) :void { _y2 = value; }
		public function set x3 ( value :Number ) :void { _x3 = value; }
		public function set y3 ( value :Number ) :void { _y3 = value; }
		public function set x4 ( value :Number ) :void { _x4 = value; }
		public function set y4 ( value :Number ) :void { _y4 = value; }
	}
}