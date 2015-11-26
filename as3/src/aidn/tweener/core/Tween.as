package aidn.tweener.core 
{
	import aidn.tweener.util.ObjectUtil;
	import caurina.transitions.properties.ColorShortcuts;
	import caurina.transitions.properties.DisplayShortcuts;
	import caurina.transitions.properties.FilterShortcuts;
	import caurina.transitions.Tweener;
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	
	
	public class Tween
	{
		/* SHOW */
		public static function show ( target :*, time :Number, delay :Number = 0, func :Function = null, params :Array = null ) :void
		{
			if (! target is Bitmap) target.mouseEnabled = true;
			target.alpha   = 0;
			target.visible = true;
			
			Tweener.addTween( target, ObjectUtil.getParam( { alpha: 1.0 }, time, delay, "linear", func, params ) )
		}
		/* HIDE */
		public static function hide ( target :*, time :Number, delay :Number = 0, func :Function = null, params :Array = null ) :void
		{
			if (! target is Bitmap) target.mouseEnabled = false;
			
			Tweener.addTween( target, ObjectUtil.getParam( { alpha: 0.0 }, time, delay, "linear", func, params ) );
		}
		
		/* FADE */
		public static function fade ( target :*, alpha : Number, time :Number, delay :Number = 0, func :Function = null, params :Array = null ) :void
		{
			Tweener.addTween( target, ObjectUtil.getParam( { alpha: alpha }, time, delay, "linear", func, params ) );
		}
		
		
		/* MOVE */
		public static function move ( target :*, x :int, y :int, time :Number, transition :String, delay :Number = 0, func :Function = null, params :Array = null ) :void
		{
			Tweener.addTween( target, ObjectUtil.getParam( { x: x, y: y }, time, delay, transition, func, params ) );
		}
		
		/* MOVE X */
		public static function moveX ( target :*, x :int, time :Number, transition :String, delay :Number = 0, func :Function = null, params :Array = null ) :void
		{
			Tweener.addTween( target, ObjectUtil.getParam( { x: x }, time, delay, transition, func, params ) );
		}
		/* MOVE Y */
		public static function moveY ( target :*, y :int, time :Number, transition :String, delay :Number = 0, func :Function = null, params :Array = null ) :void
		{
			Tweener.addTween( target, ObjectUtil.getParam( { y: y }, time, delay, transition, func, params ) );
		}
		
		
		/* SCALE */
		public static function scale ( target :*, scale :Number, time :Number, transition :String, delay :Number = 0, func :Function = null, params :Array = null ) :void
		{
			Tweener.addTween( target, ObjectUtil.getParam( { scaleX: scale, scaleY: scale }, time, delay, transition, func, params ) );
		}
		
		/* ADD TWEEN */
		public static function add ( target :*, param :Object, time :Number, transition :String, delay :Number = 0, func :Function = null, params :Array = null ) :void
		{
			Tweener.addTween( target, ObjectUtil.getParam( param, time, delay, transition, func, params ) );
		}
		
		/* DELAY TWEEN */
		public static function delay ( target :*, delay :Number = 0, func :Function = null, params :Array = null ) :void
		{
			var obj :Object = { delay: delay, onComplete: func }; if (params) obj.onCompleteParams = params;
			Tweener.addTween( target, obj );
		}
		
		/* REMOVE TWEENS */
		public static function remove ( target :* ) :void
		{
			Tweener.removeTweens( target );
		}
		
		
		
		public static function initColorShortcuts ( ) :void
		{
			ColorShortcuts.init();
		}
		public static function initDisplayShortcuts ( ) :void
		{
			DisplayShortcuts.init();
		}
		public static function initFilterShortcuts ( ) :void
		{
			FilterShortcuts.init();
		}
		
	}
}