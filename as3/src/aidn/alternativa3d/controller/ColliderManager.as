package aidn.alternativa3d.controller 
{
	import alternativa.engine3d.collisions.EllipsoidCollider;
	import alternativa.engine3d.core.Object3D;
	import flash.geom.Vector3D;
	
	public class ColliderManager 
	{
		
		private var _collider :EllipsoidCollider;
		
		private var _offsetVec :Vector3D;
		
		private var _dummy :Object3D;
		
		private var _fallSpeed :Number;
		
		private var _target          :Object3D;
		private var _collisionTarget :Object3D;
		
		private var _displacement :Vector3D;
		
		
		private var _precision :int;
		
		/**
		 * 
		 * @param	target				対象(CHARACTER)
		 * @param	collisionTarget		衝突対象(MAPなど)
		 * @param	offset				オフセット
		 * @param	radiusX				半径 X
		 * @param	radiusY				半径 Y
		 * @param	radiusZ				半径 Z
		 * @param	precision			正確性(1が最も高精度)
		 */
		public function ColliderManager ( target :Object3D, collisionTarget :Object3D, offset :Vector3D = null, radiusX :Number = 10, radiusY :Number = 10, radiusZ :Number = 10, precision :int = 1 ) 
		{
			_collider = new EllipsoidCollider(radiusX, radiusY, radiusZ);		/////
			
			_target          = target;
			_collisionTarget = collisionTarget;
			
			_precision = precision;
			
			_dummy   = new Object3D();
			_dummy.x = target.x;
			_dummy.y = target.y;
			_dummy.z = target.z;
			_dummy.rotationX = target.rotationX;
			_dummy.rotationY = target.rotationY;
			_dummy.rotationZ = target.rotationZ;
			
			if (offset)	_offsetVec = offset;
			else		_offsetVec = new Vector3D();
			
			_fallSpeed = 0;
			_displacement = new Vector3D();
		}
		
		
		// ------------------------------------------------------------------- public
		
		/**
		 * 前進。
		 * @param	d	移動距離
		 */
		public function moveFront ( d :Number ) :void
		{
			var radZ :Number = _dummy.rotationZ;
			
			_displacement.x += d * Math.sin(radZ);
			_displacement.y -= d * Math.cos(radZ);
		}
		/**
		 * 後退。
		 * @param	d	移動距離
		 */
		public function moveBack ( d :Number ) :void
		{
			var radZ :Number = _dummy.rotationZ;
			
			_displacement.x -= d * Math.sin(radZ);
			_displacement.y += d * Math.cos(radZ);
		}
		/**
		 * 左移動。
		 * @param	d	移動距離
		 */
		public function moveLeft ( d :Number ) :void
		{
			var radZ :Number = _dummy.rotationZ;
			
			_displacement.x += d * Math.cos(radZ);
			_displacement.y -= d * Math.sin(radZ);
		}
		/**
		 * 右移動。
		 * @param	d	移動距離
		 */
		public function moveRight ( d :Number ) :void
		{
			var radZ :Number = _dummy.rotationZ;
			
			_displacement.x -= d * Math.cos(radZ);
			_displacement.y += d * Math.sin(radZ);
		}
		
		public function moveX ( d :Number ) :void { _displacement.x += d; }
		public function moveY ( d :Number ) :void { _displacement.y += d; }
		public function moveZ ( d :Number ) :void { _displacement.z += d; }
		
		
		private var _count          :int = 0;
		private var _onGround       :Boolean = false;
		private var _collisionPoint :Vector3D;
		private var _collisionPlane :Vector3D;
		
		
		public function update ( fallCoef :Number = 0.5, deltaTime :Number = 0.033 ) :Boolean
		{
			// Fall speed
			_fallSpeed -= fallCoef * 9800 * (deltaTime * deltaTime);
			
			var coords   :Vector3D = new Vector3D(_dummy.x + _offsetVec.x, _dummy.y + _offsetVec.y, _dummy.z + _offsetVec.z);
			var onGround :Boolean  = false;
			
			if (0 < deltaTime)
			{
				// Checking of surface under character
				var collisionPoint :Vector3D = new Vector3D();
				var collisionPlane :Vector3D = new Vector3D();
				
				
				if (_count ++ % _precision == 0)
				{
					onGround = _collider.getCollision(coords, new Vector3D(0, 0, _fallSpeed), collisionPoint, collisionPlane, _collisionTarget);
					_onGround       = onGround;
					_collisionPoint = collisionPoint;
					_collisionPlane = collisionPlane;
				}
				else
				{
					onGround       = _onGround;
					collisionPoint = _collisionPoint;
					collisionPlane = _collisionPlane;
				}
				if (onGround && collisionPlane.z > 0.5)	_fallSpeed = 0;
				else									_displacement.z += _fallSpeed;
			}
			
			// Collision detection
			var destination :Vector3D = _collider.calculateDestination(coords, _displacement, _collisionTarget);
			_dummy.x = destination.x - _offsetVec.x;
			_dummy.y = destination.y - _offsetVec.y;
			_dummy.z = destination.z - _offsetVec.z;
			
			// 衝突を調べる
			// trace(coords, destination, coords.x == destination.x - _displacement.x, coords.y == destination.y - _displacement.y);
			//
			
			/// reset displacement
			_displacement.x = _displacement.y = _displacement.z = 0;
			
			return onGround;
		}
		
		
		public function ground ( value :Boolean ) :void
		{
			_onGround = value;
		}
		
		
		
		/// 一時用のオブジェクトからターゲットオブジェクトへコピー
		public function updateTarget ( offX :Number = 0, offY :Number = 0, offZ :Number = 0, offRotX :Number = 0, offRotY :Number = 0, offRotZ :Number = 0 ) :void
		{
			_target.x         = _dummy.x + offX;
			_target.y         = _dummy.y + offY;
			_target.z         = _dummy.z + offZ;
			_target.rotationX = _dummy.rotationX + offRotX;
			_target.rotationY = _dummy.rotationY + offRotY;
			_target.rotationZ = _dummy.rotationZ + offRotZ;
		}
		
		// ------------------------------------------------------------------- get & set
		
		public function get x         ( ) :Number  { return _dummy.x; }
		public function get y         ( ) :Number  { return _dummy.y; }
		public function get z         ( ) :Number  { return _dummy.z; }
		public function get rotationX ( ) :Number  { return _dummy.rotationX; }
		public function get rotationY ( ) :Number  { return _dummy.rotationY; }
		public function get rotationZ ( ) :Number  { return _dummy.rotationZ; }
		
		/// ダミー
		public function get obj ( ) :Object3D { return _dummy; }
		/// 対象
		public function get target ( ) :Object3D { return _target; }
		/// 衝突対象
		public function get collisionTarget ( ) :Object3D { return _collisionTarget; }
		
		
		public function set x         ( value :Number  ) :void { _dummy.x = value; }
		public function set y         ( value :Number  ) :void { _dummy.y = value; }
		public function set z         ( value :Number  ) :void { _dummy.z = value; }
		public function set rotationX ( value :Number  ) :void { _dummy.rotationX = value; }
		public function set rotationY ( value :Number  ) :void { _dummy.rotationY = value; }
		public function set rotationZ ( value :Number  ) :void { _dummy.rotationZ = value; }
		
		/// 対象
		public function set target ( value :Object3D ) :void { _target = value; }
		/// 衝突対象
		public function set collisionTarget ( value :Object3D ) :void { _collisionTarget = value; }
	}
}