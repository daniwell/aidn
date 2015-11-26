package aidn.main.util 
{
	import flash.display.Stage;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class Debug 
	{
		public static var isTrace :Boolean = true;
		
		public static function log (...rest) :void
		{
			if (isTrace)
			{
				var s :String = "";
				var l :int = rest.length;
				for (var i :int = 0; i < l; i ++) s += String(rest[i]) + " ";
				
				trace(s);
			
				if (_ta)
				{
					_stage.setChildIndex(_ta, _stage.numChildren - 1);
					_ta.text = s + "\n" + _ta.text;
				}
			}
		}
		
		
		private static var _stage :Stage;
		private static var _ta    :TextField;
		
		public static function addDebugPanel ( stage :Stage, textColor :int = 0x555555, format :TextFormat = null, selectable :Boolean = false ) :void
		{
			_stage = stage;
			
			_ta = new TextField();
			if (format) _ta.defaultTextFormat = format;
			_ta.autoSize     = "left";
			_ta.textColor    = textColor;
			_ta.mouseEnabled = selectable;
			_stage.addChild(_ta);
		}
		
	}
}