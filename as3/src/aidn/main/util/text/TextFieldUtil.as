package aidn.main.util.text 
{
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	public class TextFieldUtil
	{
		
		public static function setEnterEvent ( tf :TextField, func :Function ) :void
		{
			tf.multiline = false;
			tf.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void
				{
					if (e.keyCode == Keyboard.ENTER) { func(e); }
				} );
		}
		
	}

}