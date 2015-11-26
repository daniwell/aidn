package aidn.main.display.base 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.text.TextField;
	
	public class DisplayBase3D extends EventDispatcher
	{
		protected var _dobj :DisplayObjectContainer;
		
		
		public function DisplayBase3D ( dobj :DisplayObjectContainer, parent :DisplayObjectContainer = null ) 
		{
			_dobj = dobj;
			if (parent) parent.addChild(_dobj);
		}
		
		// ------------------------------------------------------------------- override
		
		public function addTargetEventListener ( type :String, listener :Function, useCapture :Boolean = false, priority :int = 0, useWeakReference :Boolean = false ) :void 
		{
			_dobj.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		public function removeTargetEventListener ( type :String, listener :Function, useCapture :Boolean = false ) :void 
		{
			_dobj.removeEventListener(type, listener, useCapture);
		}
		
		
		// ------------------------------------------------------------------- public
		/**
		 * 子として addChild します。
		 * @param	parent	親
		 */
		public function add ( parent :DisplayObjectContainer ) :void
		{
			parent.addChild(_dobj);
		}
		/**
		 * 親から removeChild します。
		 */
		public function remove ( ) :void
		{
			if (_dobj.parent) _dobj.parent.removeChild(_dobj);
		}
		
		public function addChild ( child :DisplayObject ) :DisplayObject
		{
			return _dobj.addChild(child);
		}
		public function removeChild ( child :DisplayObject ) :DisplayObject
		{
			return _dobj.removeChild(child);
		}
		
		public function setChildIndex ( chlid :DisplayObject, index :int ) :void
		{
			_dobj.setChildIndex(chlid, index);
		}
		
		public function getClip ( name :String ) :MovieClip { return _getClip(name); }
		public function getText ( name :String ) :TextField { return _getText(name); }
		
		protected function _getClip ( name :String ) :MovieClip
		{
			return _dobj.getChildByName(name) as MovieClip;
		}
		protected function _getText ( name :String ) :TextField
		{
			return _dobj.getChildByName(name) as TextField;
		}
		
		// ------------------------------------------------------------------- getter
		
		public function get numChildren ( ) :int { return _dobj.numChildren; }
		
		public function get x         ( ) :Number  { return _dobj.x; }
		public function get y         ( ) :Number  { return _dobj.y; }
		public function get z         ( ) :Number  { return _dobj.z; }
		public function get scaleX    ( ) :Number  { return _dobj.scaleX; }
		public function get scaleY    ( ) :Number  { return _dobj.scaleY; }
		public function get scaleZ    ( ) :Number  { return _dobj.scaleZ; }
		public function get rotationX ( ) :Number  { return _dobj.rotationX; }
		public function get rotationY ( ) :Number  { return _dobj.rotationY; }
		public function get rotationZ ( ) :Number  { return _dobj.rotationZ; }
		public function get alpha     ( ) :Number  { return _dobj.alpha; }
		public function get visible   ( ) :Boolean { return _dobj.visible; }
		
		public function get width  ( ) :Number { return _dobj.width; }
		public function get height ( ) :Number { return _dobj.height; }
		
		public function get mouseEnabled  ( ) :Boolean { return _dobj.mouseEnabled; }
		public function get mouseChildren ( ) :Boolean { return _dobj.mouseChildren; }
		
		public function get dobj ( ) :DisplayObjectContainer { return _dobj; }
		
		// ------------------------------------------------------------------- setter
		
		public function set x         ( value :Number ) :void { _dobj.x         = value; }
		public function set y         ( value :Number ) :void { _dobj.y         = value; }
		public function set z         ( value :Number ) :void { _dobj.z         = value; }
		public function set scaleX    ( value :Number ) :void { _dobj.scaleX    = value; }
		public function set scaleY    ( value :Number ) :void { _dobj.scaleY    = value; }
		public function set scaleZ    ( value :Number ) :void { _dobj.scaleZ    = value; }
		public function set rotationX ( value :Number ) :void { _dobj.rotationX = value; }
		public function set rotationY ( value :Number ) :void { _dobj.rotationY = value; }
		public function set rotationZ ( value :Number ) :void { _dobj.rotationZ = value; }
		public function set alpha     ( value :Number ) :void { _dobj.alpha     = value; }
		public function set visible   ( value :Boolean) :void { _dobj.visible   = value; }
		
		public function set width  ( value :Number ) :void { _dobj.width  = value; }
		public function set height ( value :Number ) :void { _dobj.height = value; }
		
		public function set mouseEnabled  ( value :Boolean ) :void { _dobj.mouseEnabled  = value; }
		public function set mouseChildren ( value :Boolean ) :void { _dobj.mouseChildren = value; }
	}
}