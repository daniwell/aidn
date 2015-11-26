package aidn.main.display.base 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.text.TextField;
	
	public class DisplayBase extends EventDispatcher
	{
		protected var _dobj :DisplayObjectContainer;
		
		
		public function DisplayBase ( dobj :DisplayObjectContainer, parent :DisplayObjectContainer = null ) 
		{
			_dobj = dobj;
			if (parent) parent.addChild(_dobj);
		}
		
		// ------------------------------------------------------------------- override
		
		/*
		override public function addEventListener ( type :String, listener :Function, useCapture :Boolean = false, priority :int = 0, useWeakReference :Boolean = false ) :void 
		{
			_dobj.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		override public function removeEventListener ( type :String, listener :Function, useCapture :Boolean = false ) :void 
		{
			_dobj.removeEventListener(type, listener, useCapture);
		}
		*/
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
		
		public function get x        ( ) :Number  { return _dobj.x; }
		public function get y        ( ) :Number  { return _dobj.y; }
		public function get scaleX   ( ) :Number  { return _dobj.scaleX; }
		public function get scaleY   ( ) :Number  { return _dobj.scaleY; }
		public function get rotation ( ) :Number  { return _dobj.rotation; }
		public function get alpha    ( ) :Number  { return _dobj.alpha; }
		public function get visible  ( ) :Boolean { return _dobj.visible; }
		
		public function get width  ( ) :Number { return _dobj.width; }
		public function get height ( ) :Number { return _dobj.height; }
		
		public function get scale  ( ) :Number { return _dobj.scaleX; }
		
		public function get mouseEnabled  ( ) :Boolean { return _dobj.mouseEnabled; }
		public function get mouseChildren ( ) :Boolean { return _dobj.mouseChildren; }
		
		// ------------------------------------------------------------------- setter
		
		public function set x        ( value :Number ) :void { _dobj.x        = value; }
		public function set y        ( value :Number ) :void { _dobj.y        = value; }
		public function set scaleX   ( value :Number ) :void { _dobj.scaleX   = value; }
		public function set scaleY   ( value :Number ) :void { _dobj.scaleY   = value; }
		public function set rotation ( value :Number ) :void { _dobj.rotation = value; }
		public function set alpha    ( value :Number ) :void { _dobj.alpha    = value; }
		public function set visible  ( value :Boolean) :void { _dobj.visible  = value; }
		public function set scale    ( value :Number ) :void { _dobj.scaleX   = _dobj.scaleY = value; }
		
		public function set width  ( value :Number ) :void { _dobj.width  = value; }
		public function set height ( value :Number ) :void { _dobj.height = value; }
		
		public function set mouseEnabled  ( value :Boolean ) :void { _dobj.mouseEnabled  = value; }
		public function set mouseChildren ( value :Boolean ) :void { _dobj.mouseChildren = value; }
		
	}
}