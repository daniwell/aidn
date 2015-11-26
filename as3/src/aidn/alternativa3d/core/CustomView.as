package aidn.alternativa3d.core 
{
	import alternativa.engine3d.core.View;
	
	public class CustomView extends View
	{
		
		public function CustomView ( width :int, height :int, renderToBitmap :Boolean = false, backgroundColor :uint = 0, backgroundAlpha :Number = 1, antiAlias :int = 0 ) 
		{
			super(width, height, renderToBitmap, backgroundColor, backgroundAlpha, antiAlias);
		}
		
	}

}