package com.papiness.utils 
{
	import caurina.transitions.properties.ColorShortcuts;
	import caurina.transitions.Tweener;
	import flash.display.DisplayObject;
	
	/**
	 * @author daniwell
	 */
	public class ColorShortcutsUtil
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
		public static function changeColor ( target :DisplayObject, value :int = -1, time :Number = 0 ) :void
		{
			if (0 <= value)
				Tweener.addTween( target, { _color: value, time: time, transition: "linear" } );
			else
				Tweener.addTween( target, { _color: null, time: time, transition: "linear" } );
		}
		
		/**
		 * ブライトネス。
		 * @param	target		対象となるDisplayObject。
		 * @param	value		[-1 ~ 1] (default:0)
		 * @param	time		変化に掛ける時間。
		 */
		public static function changeBrightness ( target :DisplayObject, value :Number, time :Number = 0 ) :void
		{
			Tweener.addTween( target, { _brightness: value, time: time, transition: "linear" } );
		}
		
		/**
		 * コントラスト。
		 * @param	target		対象となるDisplayObject。
		 * @param	value		[-1 ~ 1] (default:0)
		 * @param	time		変化に掛ける時間。
		 */
		public static function changeContrast ( target :DisplayObject, value :Number, time :Number = 0 ) :void
		{
			Tweener.addTween( target, { _contrast: value, time: time, transition: "linear" } );
		}
		
		/**
		 * 色相。
		 * @param	target		対象となるDisplayObject。
		 * @param	value		[-180 ~ 180] (default:0)
		 * @param	time		変化に掛ける時間。
		 */
		public static function changeHue ( target :DisplayObject, value :Number, time :Number = 0 ) :void
		{
			Tweener.addTween( target, { _hue: value, time: time, transition: "linear" } );
		}
		
		/**
		 * 彩度。
		 * @param	target		対象となるDisplayObject。
		 * @param	value		[0 ~ 2] (default:1)
		 * @param	time		変化に掛ける時間。
		 */
		public static function changeSaturation ( target :DisplayObject, value :Number, time :Number = 0 ) :void
		{
			Tweener.addTween( target, { _saturation: value, time: time, transition: "linear" } );
		}
		
	}

}