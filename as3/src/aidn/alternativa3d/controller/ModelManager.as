package aidn.alternativa3d.controller 
{
	import aidn.main.util.MathUtil;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.materials.TextureMaterial;
	
	public class ModelManager 
	{
		protected var _model    :Object3D;
		protected var _material :TextureMaterial;
		
		public function ModelManager ( model :Object3D = null, material :TextureMaterial = null, parent :Object3D = null ) 
		{
			_model    = model;
			_material = material;
			
			if (parent && model) parent.addChild(model);
		}
		
		// ------------------------------------------------------------------- public
		
		/**
		 * 前進。
		 * @param	d	移動距離
		 */
		public function moveFront ( d :Number ) :void
		{
			var radZ :Number = _model.rotationZ;
			// rotationY, rotationZ
			
			this.x += d * Math.sin(radZ);
			this.y -= d * Math.cos(radZ);
		}
		/**
		 * 後退。
		 * @param	d	移動距離
		 */
		public function moveBack ( d :Number ) :void
		{
			var radZ :Number = _model.rotationZ;
			// rotationY, rotationZ
			
			this.x -= d * Math.sin(radZ);
			this.y += d * Math.cos(radZ);
		}
		
		
		/**
		 * 左移動。
		 * @param	d	移動距離
		 */
		public function moveLeft ( d :Number ) :void
		{
			var radZ :Number = _model.rotationZ;
			// rotationY, rotationZ
			
			this.x += d * Math.cos(radZ);
			this.y -= d * Math.sin(radZ);
		}
		/**
		 * 右移動。
		 * @param	d	移動距離
		 */
		public function moveRight ( d :Number ) :void
		{
			var radZ :Number = _model.rotationZ;
			// rotationY, rotationZ
			
			this.x -= d * Math.cos(radZ);
			this.y += d * Math.sin(radZ);
		}
		
		/**
		 * カメラから見た角度方向に移動する(コンシューマゲームなどでよるああるパッド風の移動)
		 * @param	d		移動距離
		 * @param	rad		角度(ラジアン)
		 * @param	camera	カメラ
		 */
		public function moveLikePad ( d :Number, rad :Number, camera :Camera3D ) :void
		{
			this.rotationZ = rad + camera.rotationZ;
			moveFront(d);
		}
		
		
		//// 未実装
		public function hitTest ( ) :Boolean
		{
			return false;
		}
		
		
		// ------------------------------------------------------------------- get & set
		
		public function get model ( ) :Object3D { return _model; }
		
		public function get x         ( ) :Number  { return _model.x; }
		public function get y         ( ) :Number  { return _model.y; }
		public function get z         ( ) :Number  { return _model.z; }
		public function get rotationX ( ) :Number  { return _model.rotationX; }
		public function get rotationY ( ) :Number  { return _model.rotationY; }
		public function get rotationZ ( ) :Number  { return _model.rotationZ; }
		public function get scale     ( ) :Number  { return _model.scaleX; }
		public function get visible   ( ) :Boolean { return _model.visible; }
		public function get alpha     ( ) :Number  { return _material.alpha; }
		
		public function set x         ( value :Number  ) :void { _model.x = value; }
		public function set y         ( value :Number  ) :void { _model.y = value; }
		public function set z         ( value :Number  ) :void { _model.z = value; }
		public function set rotationX ( value :Number  ) :void { _model.rotationX = value; }
		public function set rotationY ( value :Number  ) :void { _model.rotationY = value; }
		public function set rotationZ ( value :Number  ) :void { _model.rotationZ = value; }
		public function set scale     ( value :Number  ) :void { _model.scaleX = _model.scaleY = _model.scaleZ = value; }
		public function set visible   ( value :Boolean ) :void { _model.visible; }
		public function set alpha     ( value :Number  ) :void { _material.alpha = value; }
	}
}