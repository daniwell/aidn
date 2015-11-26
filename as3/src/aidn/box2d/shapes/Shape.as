package aidn.box2d.shapes 
{
	import aidn.box2d.model.PhysicalData;
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class Shape 
	{
		private var _bodyDef   :b2BodyDef;
		
		private var _boxDef    :b2PolygonDef;
		private var _circleDef :b2CircleDef;
		
		private var _w :Number;
		private var _h :Number;
		
		public var body :b2Body;
		
		
		public function Shape () 
		{
			
		}
		
		/**
		 * 初期化(矩形)。
		 * @param	x
		 * @param	y
		 * @param	w
		 * @param	h
		 * @param	rotation
		 * @param	pdata
		 */
		public function initBox ( x :Number, y :Number, w :Number, h :Number, rotation :Number = 0, pdata :PhysicalData = null ) :void
		{
			_init(x, y, rotation * Math.PI / 180);
			
			_boxDef = new b2PolygonDef();
			_boxDef.SetAsBox(w / 2, h / 2);
			
			_w = w;
			_h = h;
			
			if (pdata)
			{
				_boxDef.friction    = pdata.friction;
				_boxDef.density     = pdata.density;
				_boxDef.restitution = pdata.restitution;
			}
		}
		
		/**
		 * 初期化(円)。
		 * @param	x
		 * @param	y
		 * @param	r
		 * @param	rotation
		 * @param	pdata
		 */
		public function initCircle ( x :Number, y :Number, r :Number, rotation :Number = 0, pdata :PhysicalData = null ) :void
		{
			_init(x, y, rotation * Math.PI / 180);
			
			_circleDef = new b2CircleDef();
			_circleDef.radius = r;
			
			_w = _h = r * 2;
			
			if (pdata)
			{
				_circleDef.friction    = pdata.friction;
				_circleDef.density     = pdata.density;
				_circleDef.restitution = pdata.restitution;
			}
		}
		
		private function _init ( x :Number, y :Number, angle :Number = 0 ) :void
		{
			_bodyDef = new b2BodyDef();
			_bodyDef.position.Set(x, y);
			_bodyDef.angle = angle;
		}
		
		/**
		 * UserData をセットします。
		 * @param	userData
		 * @param	scale		box2d scale
		 */
		public function setUserData ( userData :DisplayObject, scale :Number ) :DisplayObject
		{
			if (! _bodyDef) trace("error: execute 'initXXX' before 'setUserData'");
			
			_bodyDef.userData = userData;
			_bodyDef.userData.width    = scale * _w;
			_bodyDef.userData.height   = scale * _h;
			_bodyDef.userData.x        = scale * _bodyDef.position.x;
			_bodyDef.userData.y        = scale * _bodyDef.position.y;
			_bodyDef.userData.rotation = _bodyDef.angle * 180 / Math.PI;
			
			return userData;
		}
		
		/// override 用
		public function destroy ( ) :void
		{
			
		}
		
		/** b2BodyDef */
		public function get bodyDef  ( ) :b2BodyDef { return _bodyDef; }
		/** b2ShapeDef */
		public function get shapeDef ( ) :b2ShapeDef
		{
			if (_boxDef) return _boxDef;
			return _circleDef;
		}
	}
}