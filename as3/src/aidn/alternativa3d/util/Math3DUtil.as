package aidn.alternativa3d.util 
{
	import flash.geom.Point;
	
	public class Math3DUtil 
	{
		private static var _pt :Point = new Point();
		
		/**
		 * 位置 (x,y),角度 radZ から距離 distance の正面の座標を得る
		 * @param	x
		 * @param	y
		 * @param	radZ
		 * @param	distance
		 * @return
		 */
		public static function getFrontPoint ( x :Number, y :Number, radZ :Number, distance :Number ) :Point
		{
			_pt.x = x + distance * Math.sin(radZ);
			_pt.y = y - distance * Math.cos(radZ);
			return _pt;
		}
		
		/**
		 * 位置 (x,y),角度 radZ から距離 distance の背面の座標を得る
		 * @param	x
		 * @param	y
		 * @param	radZ
		 * @param	distance
		 * @return
		 */
		public static function getBackPoint ( x :Number, y :Number, radZ :Number, distance :Number ) :Point
		{
			_pt.x = x - distance * Math.sin(radZ);
			_pt.y = y + distance * Math.cos(radZ);
			return _pt;
		}
		
		
		/**
		 * 左移動。
		 */
		public static function getLeftPoint ( x :Number, y :Number, radZ :Number, distance :Number ) :Point
		{
			_pt.x = x + distance * Math.cos(radZ);
			_pt.y = y - distance * Math.sin(radZ);
			return _pt;
		}
		/**
		 * 右移動。
		 */
		public static function getRightPoint ( x :Number, y :Number, radZ :Number, distance :Number ) :Point
		{
			_pt.x = x - distance * Math.cos(radZ);
			_pt.y = y + distance * Math.sin(radZ);
			return _pt;
		}
		
		public static function distance ( x0 :Number, y0 :Number, z0 :Number, x1 :Number, y1 :Number, z1 :Number ) :Number
		{
			var dx :Number = x1 - x0;
			var dy :Number = y1 - y0;
			var dz :Number = z1 - z0;
			return Math.sqrt(dx * dx + dy * dy + dz * dz);
		}
	}
}