package aidn.tweener.core 
{
	import aidn.tweener.util.ObjectUtil;
	import caurina.transitions.properties.FilterShortcuts;
	import caurina.transitions.Tweener;
	import flash.display.DisplayObject;
	
	public class FilterTween
	{
		
		public static function init ( ) :void
		{
			FilterShortcuts.init();
		}
		
		public static function blur ( target :DisplayObject, blurX :Number, blurY :Number, time :Number = 0.0, delay :Number = 0.0, func :Function = null, quality :Number = 1 ) :void
		{
			Tweener.addTween( target, ObjectUtil.getParam( { _Blur_blurX: blurX, _Blur_blurY: blurY, _Blur_quality: quality }, time, delay, "linear", func));
		}
		
	}

}