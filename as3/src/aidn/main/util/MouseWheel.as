package aidn.main.util 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.utils.Dictionary;
	
	public class MouseWheel 
	{
		// [param]
		// allowScriptAccess: "always"
		// wmode: "transparent"
		//
		
		public static const MIDDLE_CLICK :String = "middleClick";
		
		private static const INIT_METHOD :String = "function(){ document.onmousedown = function(evt){ var d = document['<name>'] || window['<name>']; d.mousedown(evt.which); }; }";
		
		private static var _funcs :Dictionary;
		private static var _useJS :Boolean = false;
		
		private static var _stage :Stage;
		
		/**
		 * @param	stage
		 * @param	name	
		 */
		public static function init ( stage :Stage, name :String = "flashContent" ) :void
		{
			_stage = stage;
			
			_funcs   = new Dictionary();
			
			_useJS = (MouseEvent["MIDDLE_CLICK"] == null);
			
			if (_useJS)
			{
				try {
					var s :String = INIT_METHOD.split("<name>").join(name);
					ExternalInterface.call(s);
					ExternalInterface.addCallback("mousedown", __mousedown);
				} catch ( e: * ) { }
			}
		}
		
		public static function add ( func :Function, target :DisplayObjectContainer ) :void
		{
			_funcs[func] = target;
			
			if (! _useJS)
			{
				target.addEventListener(MIDDLE_CLICK, func);
			}
		}
		public static function remove ( func :Function ) :void
		{
			if (! _useJS)
			{
				DisplayObjectContainer(_funcs[func]).removeEventListener(MIDDLE_CLICK, func);
			}
			
			_funcs[func] = null;
			delete _funcs[func];
		}
		
		/// from JavaScript
		private static function __mousedown (n:int) :void
		{
			/// wheel down: 2
			if (n == 2)
			{
				var d :DisplayObjectContainer;
				for (var f :* in _funcs)
				{
					d = DisplayObjectContainer(_funcs[f]);
					if (d.hitTestPoint(_stage.mouseX, _stage.mouseY))
					{
						var b :Boolean = false;
						while (d) { if (! d.visible && ! d.mouseEnabled) { b = true; break; }; d = d.parent; }
						if (b) continue;
						
						f(new MouseEvent(MIDDLE_CLICK));
						break;
					}
				}
			}
		}
		
	}

}