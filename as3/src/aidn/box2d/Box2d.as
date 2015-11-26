package aidn.box2d 
{
	import aidn.box2d.dynamics.ContactListener;
	import aidn.box2d.shapes.Shape;
	import aidn.main.util.Hide;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.Joints.b2MouseJointDef;
	import flash.display.Stage;
	import flash.events.Event;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	
	
	
	/** @eventType ContactEvent.ADD */
	[Event(name="contactAdd", type="aidn.box2d.events.ContactEvent")]
	/** @eventType ContactEvent.RESULT */
	[Event(name="contactResult", type="aidn.box2d.events.ContactEvent")]
	/** @eventType ContactEvent.PERSIST */
	[Event(name="contactPersist", type="aidn.box2d.events.ContactEvent")]
	/** @eventType ContactEvent.REMOVE */
	[Event(name="contactRemove", type="aidn.box2d.events.ContactEvent")]
	
	
	/**
	 * Box2DFlasAS3 2.0.2
	 * @require http://sourceforge.net/projects/box2dflash/files/box2dflash/
	 */
	
	public class Box2d extends EventDispatcher
	{
		private var _world      :b2World;
		private var _iterations :int    = 10;
		private var _timeStep   :Number = 1 / 30;
		
		private var _scale :Number = 30;
		
		private var _viewRect :Rectangle;
		
		private var _stage  :Stage;
		private var _margin :int;
		
		private var _autoDestroy :Boolean;
		private var _shapes      :/*Shape*/Array = [];
		
		public function Box2d() 
		{
			
		}
		
		/**
		 * 初期化します。
		 * @param	gravityX
		 * @param	gravityY
		 * @param	scale
		 * @param	sleep
		 */
		public function init ( gravityX :Number = 0.0, gravityY :Number = 10.0, scale :Number = 30, sleep :Boolean = true, autoDestroy :Boolean = true ) :void
		{
			var worldAABB :b2AABB = new b2AABB();
			worldAABB.lowerBound.Set(-100.0, -100.0);
			worldAABB.upperBound.Set(100.0, 100.0);
			
			var gravity :b2Vec2  = new b2Vec2(gravityX, gravityY);
			var doSleep :Boolean = sleep;
			
			_scale = scale;
			
			_autoDestroy = autoDestroy;
			
			_viewRect = new Rectangle(0, 0, 640, 480);
			
			_world = new b2World(worldAABB, gravity, doSleep);
		}
		
		
		/**
		 * デバッグ用の描画を行います。
		 * @param	target	描画を行う対象
		 */
		public function setDebugDraw ( target :DisplayObjectContainer ) :void
		{
			var dbgSprite:Sprite = new Sprite();
			target.addChild(dbgSprite);
			
			var dbgDraw:b2DebugDraw = new b2DebugDraw();
			dbgDraw.m_sprite        = dbgSprite;
			dbgDraw.m_drawScale     = _scale;
			dbgDraw.m_fillAlpha     =  0.0;
			dbgDraw.m_lineThickness =  1.0;
			dbgDraw.m_drawFlags     = 0xFFFFFFFF;
			
			_world.SetDebugDraw(dbgDraw);
		}
		
		/**
		 * 表示領域の矩形を設定します。
		 * @param	rect
		 */
		public function setViewRect ( rect :Rectangle ) :void
		{
			_viewRect = rect;
		}
		
		/**
		 * アップデート用のパラメータを設定します。
		 * @param	timeStep
		 * @param	iterations
		 */
		public function setUpdateParam ( timeStep :Number = 1/30, iterations :int = 10 ) :void
		{
			_timeStep   = timeStep;
			_iterations = iterations;
		}
		
		
		/**
		 * 衝突に関するイベントを発行するように初期化します。
		 */
		public function initContactListener ( ) :void
		{
			_world.SetContactListener(new ContactListener(this));
		}
		
		/**
		 * 表示領域を自動でアップデートします
		 */
		public function viewrectAutoUpdate ( stage :Stage, margin :int = 0 ) :void
		{
			_stage  = stage;
			_margin = margin;
			
			stage.removeEventListener(Event.RESIZE, _resize);
			stage.addEventListener(Event.RESIZE, _resize);
			
			_resize(null);
		}
		
		/**
		 * Shape を追加します。
		 * @param	obj
		 */
		public function addObject ( shape :Shape ) :Boolean
		{
			var body :b2Body = _world.CreateBody(shape.bodyDef);
			
			if (body)
			{
				body.CreateShape(shape.shapeDef);
				body.SetMassFromShapes();
				shape.body = body;
				
				_shapes.push(shape);
				
				return true;
			}
			
			return false;
		}
		
		/**
		 * 
		 * @param	shape
		 * @return
		 */
		public function destroyObject ( shape :Shape ) :void
		{
			var l :int = _shapes.length;
			for (var i :int = 0; i < l; i ++) {
				if (_shapes[i] == shape) {
					_shapes.splice(i, 1);
					break;
				}
			}
			
			shape.destroy();
			
			var body :b2Body = shape.body;
			if (body) _destroy(body);
		}
		private function _destroy ( body :b2Body ) :void
		{
			if (_b2MouseJoint && _b2MouseJoint.m_body2 == body)	mouseUp();
			
			if (body.m_userData is DisplayObjectContainer)
			{
				var obj :DisplayObjectContainer = body.m_userData as DisplayObjectContainer;
				Hide.start(obj, false);
				if (obj.parent) obj.parent.removeChild(obj);
			}
			
			_world.DestroyBody(body);
		}
		
		/**
		 * 
		 * @param	shape
		 */
		public function updateShape ( shape :Shape ) :void
		{
			var bb :b2Body = shape.body;
			
			if (bb.m_userData is DisplayObjectContainer)
			{
				var obj :DisplayObjectContainer = bb.m_userData as DisplayObjectContainer;
				
				obj.x        = bb.GetPosition().x * _scale;
				obj.y        = bb.GetPosition().y * _scale;
				obj.rotation = bb.GetAngle() * (180 / Math.PI);
			}
		}
		
		
		/**
		 * ENTER FRAME
		 */
		public function update ( ) :void
		{
			_world.Step(_timeStep, _iterations);
			
			
			var l :int = _shapes.length;
			for (var i :int = 0; i < l; i ++)
			{
				var shape :Shape  = _shapes[i];
				var bb    :b2Body = shape.body;
				
				if (bb.m_userData is DisplayObjectContainer)
				{
					var obj :DisplayObjectContainer = bb.m_userData as DisplayObjectContainer;
					
					obj.x        = bb.GetPosition().x * _scale;
					obj.y        = bb.GetPosition().y * _scale;
					obj.rotation = bb.GetAngle() * (180 / Math.PI);
					
					// 表示領域外
					if (! _viewRect.contains(obj.x, obj.y))
					{
						if (_b2MouseJoint && _b2MouseJoint.m_body2 == bb)	mouseUp();
						
						if (_autoDestroy)
						{
							this.destroyObject(shape);
							
							l --; i --;
						}
					}
				}
			}
			
			/*
			for (var bb:b2Body = _world.m_bodyList; bb; bb = bb.m_next)
			{
				if (bb.m_userData is DisplayObjectContainer)
				{
					var obj :DisplayObjectContainer = bb.m_userData as DisplayObjectContainer;
					
					obj.x        = bb.GetPosition().x * _scale;
					obj.y        = bb.GetPosition().y * _scale;
					obj.rotation = bb.GetAngle() * (180 / Math.PI);
					
					// 表示領域外
					if (! _viewRect.contains(obj.x, obj.y))
					{
						if (_b2MouseJoint && _b2MouseJoint.m_body2 == bb)	mouseUp();
						
						Hide.start(obj);
						if (obj.parent) obj.parent.removeChild(obj);
						_world.DestroyBody(bb);
					}
				}
			}
			//*/
		}
		
		
		/* 倍率 */
		public function get scale ( ) :Number { return _scale; }
		
		
		
		
		private function _resize ( evt :Event ) :void 
		{
			_viewRect.x      = - _margin;
			_viewRect.y      = - _margin;
			_viewRect.width  = _stage.stageWidth  + _margin * 2;
			_viewRect.height = _stage.stageHeight + _margin * 2;
		}
		
		
		// -------------------------------------------------------------------------------------
		// -------------------------------------------------------------------------------------
		
		/**
		 * 
		 * MouseDown -> MouseMove -> MouseUp
		 * 
		 */
		
		private var _mousePVec       :b2Vec2 = new b2Vec2();
		private var _mouseXWorldPhys :Number;
		private var _mouseYWorldPhys :Number;
		
		private var _b2MouseJoint :b2MouseJoint;
		private var _isJoint      :Boolean;
		
		
		/* Mouse Down */
		public function mouseDown ( mX :Number, mY :Number, dampingRatio :Number = 0.7, frequencyHz :Number = 5 ) :void
		{
			_updateMouseWorld( mX, mY );
			var body :b2Body = _getBodyAtMouse();	// マウス下の物体取得
			
			if (body)
			{
				_isJoint = true;
				
				var md :b2MouseJointDef = new b2MouseJointDef();
				md.body1 = _world.GetGroundBody();
				md.body2 = body;
				md.target.Set(_mouseXWorldPhys, _mouseYWorldPhys);
				
				md.dampingRatio = dampingRatio;
				md.frequencyHz  = frequencyHz;
				md.maxForce   = 300000.0 * body.GetMass();
				md.timeStep   = _timeStep;
				
				_b2MouseJoint = _world.CreateJoint(md) as b2MouseJoint;
				
				body.WakeUp();
			}
		}
		/* Mouse Move */
		public function mouseMove ( mX :Number, mY :Number ) :void
		{
			if (_isJoint)
			{
				_updateMouseWorld( mX, mY );
				
				var p2 :b2Vec2 = new b2Vec2(_mouseXWorldPhys, _mouseYWorldPhys);
				_b2MouseJoint.SetTarget(p2);
			}
		}
		/* Mouse Up */
		public function mouseUp ( ) :void
		{
			if (_isJoint)
			{
				_isJoint = false;
				
				_world.DestroyJoint(_b2MouseJoint);
				_b2MouseJoint = null;
			}
		}
		
		/* マウス座標を変換 */
		private function _updateMouseWorld ( mouseX :Number, mouseY :Number ) :void
		{
			_mouseXWorldPhys = mouseX / _scale;
			_mouseYWorldPhys = mouseY / _scale;
		}
		/* マウス下の物体取得 */
		private function _getBodyAtMouse(includeStatic:Boolean = false):b2Body
		{
			_mousePVec.Set(_mouseXWorldPhys, _mouseYWorldPhys);
			
			var aabb:b2AABB = new b2AABB();
			aabb.lowerBound.Set(_mouseXWorldPhys - 0.001, _mouseYWorldPhys - 0.001);
			aabb.upperBound.Set(_mouseXWorldPhys + 0.001, _mouseYWorldPhys + 0.001);
		   
			var shapes    :/*b2Shape*/Array = new Array();
			var maxCoount :int   = 10;
			var count     :int   = _world.Query(aabb, shapes, maxCoount);
			
			var body:b2Body = null;
			
			for (var i:int = 0; i <count; ++i)
			{
				if (shapes[i].GetBody().IsStatic() == false || includeStatic)
				{
					var tShape :b2Shape = shapes[i] as b2Shape;
					var inside :Boolean = tShape.TestPoint(tShape.GetBody().GetXForm(), _mousePVec);
					if (inside)
					{
						body = tShape.GetBody();
						break;
					}
				}
			}
			return body;
		}
		
	}
}