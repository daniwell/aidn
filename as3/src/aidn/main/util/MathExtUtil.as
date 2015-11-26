package aidn.main.util 
{
	import flash.geom.Point;
	import flash.geom.Vector3D;
	public class MathExtUtil 
	{
		/**
		 * 外積。
		 * @return
		 */
		public static function intersect ( p1x :Number, p1y :Number,
										   p2x :Number, p2y :Number,
										   p3x :Number, p3y :Number,
										   p4x :Number, p4y :Number ) :Number
		{
			var n :Number = ((p1x - p2x) * (p3y - p1y) + (p1y - p2y) * (p1x - p3x)) * 
							((p1x - p2x) * (p4y - p1y) + (p1y - p2y) * (p1x - p4x));
			return n;
		}
		
		
		/**
		 * 任意の三角形の中に任意の点が内包されているかどうか調べます。
		 * @return	内包されている時、true
		 */
		public static function triContainsPos ( p1x :Number, p1y :Number,
												p2x :Number, p2y :Number,
												p3x :Number, p3y :Number,
												psx :Number, psy :Number ) :Boolean
		{
			// 一直線上
			if ((p1x - p3x) * (p1y - p2y) == (p1x - p2x) * (p1y - p3y)) return false;
			
			if (intersect(p1x, p1y, p2x, p2y, psx, psy, p3x, p3y) < 0) return false;
			if (intersect(p1x, p1y, p3x, p3y, psx, psy, p2x, p2y) < 0) return false;
			if (intersect(p2x, p2y, p3x, p3y, psx, psy, p1x, p1y) < 0) return false;
			
			return true;
		}
		
		/**
		 * 任意の四角形の中に任意の点が内包されているかどうか調べます。
		 * @return	内包されている時、true
		 */
		public static function boxContainsPos (　p1x :Number, p1y :Number,
												p2x :Number, p2y :Number,
												p3x :Number, p3y :Number,
												p4x :Number, p4y :Number,
												psx :Number, psy :Number, bump :int = -1 ) :Boolean
		{
			if (bump < 0) bump = checkBump(p1x, p1y, p2x, p2y, p3x, p3y, p4x, p4y);
			
			if (bump == 1 || bump == 3)			// p1 凹, p3 凹
			{
				if (triContainsPos(p1x, p1y, p3x, p3y, p2x, p2y, psx, psy)) return true;
				if (triContainsPos(p1x, p1y, p3x, p3y, p4x, p4y, psx, psy)) return true;
			}
			else if (bump == 2 || bump == 4)	// p2 凹, p4 凹
			{
				if (triContainsPos(p2x, p2y, p4x, p4y, p1x, p1y, psx, psy)) return true;
				if (triContainsPos(p2x, p2y, p4x, p4y, p3x, p3y, psx, psy)) return true;
			}
			else								// 凸
			{
				if (triContainsPos(p1x, p1y, p2x, p2y, p3x, p3y, psx, psy)) return true;
				if (triContainsPos(p1x, p1y, p3x, p3y, p4x, p4y, psx, psy)) return true;
			}
			
			return false;
		}
		
		
		/**
		 * 任意の円の中に任意の点が内包されているかどうか調べます。
		 * @return	内包されている時、true
		 */
		public static function circleContainsPos ( cx :Number, cy :Number, radius :Number, px :Number, py :Number ) :Boolean
		{
			var dx :Number = px - cx;
			var dy :Number = py - cy;
			
			// 半径よりも、任意の点までの距離の方が長い
			if (radius * radius < dx * dx + dy * dy) return false;
			
			return true;
		}
		
		
		/**
		 * 三角形の面積を求めます。
		 * @return
		 */
		public static function calcTriArea (　p1x :Number, p1y :Number,
											　p2x :Number, p2y :Number,
											　p3x :Number, p3y :Number ) :Number
		{
			return MathUtil.abs((p2x - p1x) * (p3y - p1y) - (p2y - p1y) * (p3x - p1x)) * 0.5;
		}
		/**
		 * 四角形の面積を求めます。
		 * @return
		 */
		public static function calcBoxArea (　p1x :Number, p1y :Number,
											　p2x :Number, p2y :Number,
											　p3x :Number, p3y :Number,
											　p4x :Number, p4y :Number, bump :int = -1 ) :Number
		{
			var s :Number = 0;
			if (bump < 0) bump = checkBump(p1x, p1y, p2x, p2y, p3x, p3y, p4x, p4y);
			
			if (bump == 1 || bump == 3)			// p1 凹, p3 凹
			{
				s += calcTriArea(p1x, p1y, p3x, p3y, p2x, p2y);
				s += calcTriArea(p1x, p1y, p3x, p3y, p4x, p4y);
			}
			else if (bump == 2 || bump == 4)	// p2 凹, p4 凹
			{
				s += calcTriArea(p2x, p2y, p4x, p4y, p1x, p1y);
				s += calcTriArea(p2x, p2y, p4x, p4y, p3x, p3y);
			}
			else								// 凸
			{
				s += calcTriArea(p1x, p1y, p2x, p2y, p3x, p3y);
				s += calcTriArea(p1x, p1y, p3x, p3y, p4x, p4y);
			}
			
			return s;
		}
		
		/**
		 * 凹凸チェック。
		 * @return	凹の場合、凹となっている点の番号が返る(凸の時、0)
		 */
		public static function checkBump ( p1x :Number, p1y :Number,
										   p2x :Number, p2y :Number,
										   p3x :Number, p3y :Number,
										   p4x :Number, p4y :Number) :int
		{
			if (triContainsPos(p2x, p2y, p3x, p3y, p4x, p4y, p1x, p1y))			// p1 凹, p3 凹
			{
				return 1;
			}
			else if (triContainsPos(p3x, p3y, p4x, p4y, p1x, p1y, p2x, p2y))	// p2 凹
			{
				return 2;
			}
			else if (triContainsPos(p4x, p4y, p1x, p1y, p2x, p2y, p3x, p3y))	// p3 凹
			{
				return 3;
			}
			else if (triContainsPos(p1x, p1y, p2x, p2y, p3x, p3y, p4x, p4y))	// p4 凹
			{
				return 4
			}
			return 0;
		}
		
		
		
		
		/**
		 * p1-p2, p3-p4 の線分の交差判定。
		 * @return
		 */
		public static function intersectLineSegment ( p1x :Number, p1y :Number,
													  p2x :Number, p2y :Number,
													  p3x :Number, p3y :Number,
													  p4x :Number, p4y :Number) :Boolean
		{
			if (intersect(p1x, p1y, p2x, p2y, p3x, p3y, p4x, p4y) < 0)
				if (intersect(p3x, p3y, p4x, p4y, p1x, p1y, p2x, p2y) < 0) 
					return true;
			
			return false;
		}
		
		/**
		 * 点(psx,psy)から、(p1x,p1y)(p2x,p2y)を通る直線におろした垂線の交点の座標
		 */
		public static function getCrossPoint ( p1x :Number, p1y :Number,
											   p2x :Number, p2y :Number,
											   psx :Number, psy :Number ) :Point
		{
			var a :Number = p2y - p1y;
			var b :Number = p1x - p2x;
			var c :Number = (p1y - p2y) * p1x + (p2x - p1x) * p1y;
			
			var d :Number = (a * psx + b * psy + c) / (a * a + b * b);
			
			var x :Number = psx - d * a;
			var y :Number = psy - d * b;
			
			return new Point(x, y);
		}
		
		/**
		 * 線(p1,p2)と線(p3,p4)の交点の座標
		 */
		public static function getClossPoint2 ( p1 :Point, p2 :Point, p3 :Point, p4 :Point ) :Point
		{
			var s1 :Number = ((p4.x - p3.x) * (p1.y - p3.y) - (p4.y - p3.y) * (p1.x - p3.x)) * 0.5;
			var s2 :Number = ((p4.x - p3.x) * (p3.y - p2.y) - (p4.y - p3.y) * (p3.x - p2.x)) * 0.5;
			
			var pt :Point = new Point();
			pt.x = p1.x + (p2.x - p1.x) * (s1 / (s1 + s2));
			pt.y = p1.y + (p2.y - p1.y) * (s1 / (s1 + s2));
			
			return pt;
		}
		
		/** 3D Square 描画用 */
		public static function getVecter3DFromBox ( p1x :Number, p1y :Number,
													p2x :Number, p2y :Number,
													p3x :Number, p3y :Number,
													p4x :Number, p4y :Number, z :Number = 0, bump :int = -1 ) :Vector.<Vector3D>
		{
			if (bump < 0) bump = checkBump(p1x, p1y, p2x, p2y, p3x, p3y, p4x, p4y);
			
			var vec :Vector.<Vector3D> = new Vector.<Vector3D>();
			
			if (bump == 1 || bump == 3)			// p1 凹, p3 凹
			{
				// 2, 3, 4, 1
				vec[0] = new Vector3D(p2x, p2y, z);
				vec[1] = new Vector3D(p3x, p3y, z);
				vec[2] = new Vector3D(p4x, p4y, z);
				vec[3] = new Vector3D(p1x, p1y, z);
			}
			/*
			else if (bump == 2 || bump == 4)	// p2 凹, p4 凹
			{
				// 1, 2, 3, 4
			}
			*/
			else								// 凸
			{
				// 1, 2, 3, 4
				vec[0] = new Vector3D(p1x, p1y, z);
				vec[1] = new Vector3D(p2x, p2y, z);
				vec[2] = new Vector3D(p3x, p3y, z);
				vec[3] = new Vector3D(p4x, p4y, z);
			}
			
			return vec;
		}
		
	}
}