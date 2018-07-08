package mmd.vmd.util 
{
	import flash.geom.Matrix3D;
	import flash.geom.Orientation3D;
	import flash.geom.Vector3D;
	
	public class VmdUtil 
	{
		/**
		 * BPM に合ったフレーム番号のリストを返す。
		 * @param	bpm			BPM
		 * @param	seconds		秒数
		 * @param	offset		フレームのオフセット
		 * @return
		 */
		public static function getFrameNumList ( bpm :Number = 120, seconds :Number = 60, offset :uint = 0 ) :Array
		{
			var list :Array = [];
			var s :Number = 60 / bpm;
			
			for (var i :int = 0; ; i++)
			{
				var tmp   :Number = s * i;
				var frame :int    = 30 * tmp;
				
				if (seconds < tmp) break;
				list[i] = frame + offset;
			}
			return list;
		}
		
		/// 補間パラメータ取得
		public static function getInterpolation (ax :int = 20, ay :int = 20, bx :int = 107, by :int = 107 ) :/*int*/Array
		{
			var X :Array = [ax, ay, bx, by];
			var Y :Array = [ax, ay, bx, by];
			var Z :Array = [ax, ay, bx, by];
			var R :Array = [ax, ay, bx, by];
			
			var ar :Array = 
			[
				X[0], Y[0], Z[0], R[0], X[1], Y[1], Z[1], R[1], X[2], Y[2], Z[2], R[2], X[3], Y[3], Z[3], R[3], 
				Y[0], Z[0], R[0], X[1], Y[1], Z[1], R[1], X[2], Y[2], Z[2], R[2], X[3], Y[3], Z[3], R[3],    1, 
				Z[0], R[0], X[1], Y[1], Z[1], R[1], X[2], Y[2], Z[2], R[2], X[3], Y[3], Z[3], R[3],    1,    0, 
				R[0], X[1], Y[1], Z[1], R[1], X[2], Y[2], Z[2], R[2], X[3], Y[3], Z[3], R[3],    1,    0,    0
			];
			
			return ar;
		}
		
		
		/// クォータニオンを取得
		public static function getQuaternion ( rx :Number = 0, ry :Number = 0, rz :Number = 0 ) :Vector3D
		{
			var mat3d :Matrix3D = new Matrix3D();
			if (rx != 0) mat3d.prependRotation( rx, Vector3D.X_AXIS);
			if (ry != 0) mat3d.prependRotation(-ry, Vector3D.Y_AXIS);
			if (rz != 0) mat3d.prependRotation(-rz, Vector3D.Z_AXIS);
			
			return mat3d.decompose(Orientation3D.QUATERNION)[1];
		}
		
		public static function getQuaternionX (pitch :Number, yaw :Number, roll :Number) :Vector3D
		{
			/// 座標系
			yaw  = -  yaw;
			roll = - roll;
			
			var cosY :Number = Math.cos(yaw / 2);
			var sinY :Number = Math.sin(yaw / 2);
			var cosP :Number = Math.cos(pitch / 2);
			var sinP :Number = Math.sin(pitch / 2);
			var cosR :Number = Math.cos(roll / 2);
			var sinR :Number = Math.sin(roll / 2);
			
			return new Vector3D(
				cosR * sinP * cosY + sinR * cosP * sinY,
				cosR * cosP * sinY - sinR * sinP * cosY,
				sinR * cosP * cosY - cosR * sinP * sinY,
				cosR * cosP * cosY + sinR * sinP * sinY
			);
		}
		
		/// クォータニオンを取得
		/*
		public static function getQuaternionSub ( rx :Number = 0, ry :Number = 0, rz :Number = 0 ) :Vector3D
		{
			var axisX :Vector3D = new Vector3D(1, 0, 0);
			var axisY :Vector3D = new Vector3D(0, 1, 0);
			var axisZ :Vector3D = new Vector3D(0, 0, 1);
			
			var list :Array = [];
			
			if (rx != 0) list.push(_quatRotate(axisX,  rx));
			if (ry != 0) list.push(_quatRotate(axisY, -ry));
			if (rz != 0) list.push(_quatRotate(axisZ, -rz));
			
			if (list.length == 0) return new Vector3D();
			
			var tmp :Vector3D = list[0];
			
			for (var i :int = 1; i < list.length; i ++)
			{
				tmp = _multiQuatRotate(list[i], tmp);
			}
			return tmp;
		}
		private static function _quatRotate ( v :Vector3D, r :Number ) :Vector3D
		{
			var rad :Number = r * (Math.PI / 180.0) / 2.0;
			var s :Number = Math.sin(rad);
			
			return new Vector3D(v.x * s, v.y * s, v.z * s, Math.cos(rad));
		}
		private static function _multiQuatRotate ( q1 :Vector3D, q2 :Vector3D ) :Vector3D
		{
			return new Vector3D(
				q1.y * q2.z - q1.z * q2.y + q1.w * q2.x + q1.x * q2.w,
				q1.z * q2.x - q1.x * q2.z + q1.w * q2.y + q1.y * q2.w,
				q1.x * q2.y - q1.y * q2.x + q1.w * q2.z + q1.z * q2.w,
				q1.w * q2.w - q1.x * q2.x - q1.y * q2.y - q1.z * q2.z
			);
		}
		//*/
	}
}