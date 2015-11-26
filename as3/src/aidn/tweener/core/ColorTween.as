package aidn.tweener.core 
{
	import aidn.tweener.util.ObjectUtil;
	import caurina.transitions.properties.ColorShortcuts;
	import caurina.transitions.Tweener;
	import flash.display.DisplayObject;
	
	
	public class ColorTween
	{
		
		public static function init ( ) :void
		{
			ColorShortcuts.init();
		}
		
		/**
		 * 色。
		 * @param	target		対象となるDisplayObject。
		 * @param	value		[0x000000 ~ 0xffffff] (default:-1)
		 * @param	time		変化に掛ける時間。
		 */
		public static function changeColor ( target :DisplayObject, value :int = -1, time :Number = 0.0, delay :Number = 0.0, func :Function = null ) :void
		{
			var baseObj :Object = {};
			if (0 <= value)	baseObj._color = value;
			else			baseObj._color = null;
			
			Tweener.addTween( target, ObjectUtil.getParam(baseObj, time, delay, "linear", func) );
		}
		
		/**
		 * ブライトネス。
		 * @param	target		対象となるDisplayObject。
		 * @param	value		[-1 ~ 1] (default:0)
		 * @param	time		変化に掛ける時間。
		 */
		public static function changeBrightness ( target :DisplayObject, value :Number, time :Number = 0.0, delay :Number = 0.0, func :Function = null ) :void
		{
			Tweener.addTween( target, ObjectUtil.getParam( { _brightness: value }, time, delay, "linear", func) );
		}
		
		/**
		 * コントラスト。
		 * @param	target		対象となるDisplayObject。
		 * @param	value		[-1 ~ 1] (default:0)
		 * @param	time		変化に掛ける時間。
		 */
		public static function changeContrast ( target :DisplayObject, value :Number, time :Number = 0.0, delay :Number = 0.0, func :Function = null ) :void
		{
			Tweener.addTween( target, ObjectUtil.getParam( { _contrast: value }, time, delay, "linear", func) );
		}
		
		/**
		 * 色相。
		 * @param	target		対象となるDisplayObject。
		 * @param	value		[-180 ~ 180] (default:0)
		 * @param	time		変化に掛ける時間。
		 */
		public static function changeHue ( target :DisplayObject, value :Number, time :Number = 0.0, delay :Number = 0.0, func :Function = null ) :void
		{
			Tweener.addTween( target, ObjectUtil.getParam( { _hue: value }, time, delay, "linear", func) );
		}
		
		/**
		 * 彩度。
		 * @param	target		対象となるDisplayObject。
		 * @param	value		[0 ~ 2] (default:1)
		 * @param	time		変化に掛ける時間。
		 */
		public static function changeSaturation ( target :DisplayObject, value :Number, time :Number = 0.0, delay :Number = 0.0, func :Function = null ) :void
		{
			Tweener.addTween( target, ObjectUtil.getParam( { _saturation: value }, time, delay, "linear", func) );
		}
		
	}
}