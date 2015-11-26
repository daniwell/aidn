package aidn.box2d.display 
{
	import flash.display.Sprite;
	
	public class Box extends Sprite
	{
		
		public function Box( col :uint = 0x0 ) 
		{
			graphics.beginFill(col);
			graphics.drawRect( -5, -5, 10, 10);
		}
	}
}