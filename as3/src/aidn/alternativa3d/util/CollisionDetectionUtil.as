package aidn.alternativa3d.util 
{
	import aidn.main.util.MathExtUtil;
	import aidn.main.util.MathUtil;
	import alternativa.engine3d.core.Object3D;
	import flash.geom.Point;
	
	public class CollisionDetectionUtil 
	{
		public static var _p0 :Point = new Point();
		public static var _p1 :Point = new Point();
		public static var _p2 :Point = new Point();
		
		/// チェックエリアの更新
		public static function updateArea ( target :Object3D, degree :Number, distance :Number = 1000, reverse :Boolean = false ) :void
		{
			var fov  :Number = MathUtil.toRad(degree);
			var rad1 :Number = target.rotationZ - fov / 2;
			var rad2 :Number = target.rotationZ + fov / 2;
			
			var d :int = distance;
			if (reverse) d = - d;
			
			_p0.x = target.x;
			_p0.y = target.y;
			_p1.x = target.x + d * Math.sin(rad1);
			_p1.y = target.y - d * Math.cos(rad1);
			_p2.x = target.x + d * Math.sin(rad2);
			_p2.y = target.y - d * Math.cos(rad2);
		}
		
		/// チェックエリア内に　任意の点を内包しているかどうか
		public static function checkContains ( x :Number, y :Number ) :Boolean
		{
			return MathExtUtil.triContainsPos(_p0.x, _p0.y, _p1.x, _p1.y, _p2.x, _p2.y, x, y);
		}
		
		/// 任意の線分を一部でも内包しているかどうか
		public static function checkIntersect ( x0 :Number, y0 :Number, x1 :Number, y1 :Number ) :Boolean
		{
			// 点の内包判定
			if (MathExtUtil.triContainsPos(_p0.x, _p0.y, _p1.x, _p1.y, _p2.x, _p2.y, x0, y0)) return true;
			if (MathExtUtil.triContainsPos(_p0.x, _p0.y, _p1.x, _p1.y, _p2.x, _p2.y, x1, y1)) return true;
			// 線分の交差判定
			if (MathExtUtil.intersectLineSegment(_p0.x, _p0.y, _p1.x, _p1.y, x0, y0, x1, y1)) return true;
			if (MathExtUtil.intersectLineSegment(_p0.x, _p0.y, _p2.x, _p2.y, x0, y0, x1, y1)) return true;
			
			return false;
		}
		
		
		
		/**
		 * 任意のオブジェクトが対象オブジェクトの正面側に位置しているかどうかの判定
		 * @param	target
		 * @param	front		front が target の正面にあるかどうかを判定
		 * @param	degRight	右側角度範囲
		 * @param	defLeft		左側角度範囲
		 * @return
		 */
		public static function checkFront ( target :Object3D, front :Object3D, degRight :Number = 90, defLeft :Number = 90 ) :Boolean
		{
			var rad :Number = Math.atan2(front.y - target.y, front.x - target.x) + Math.PI / 2;
			var rl :int = defLeft;
			var rr :int = degRight;
			
			var d :Number = MathUtil.toDeg(target.rotationZ) - MathUtil.toDeg(rad);
			d -= int(d / 360) * 360;
			return ((- rl < d && d < rr) || (d < - 360 + rr) || (360 - rl < d));
		}
		
	}
}