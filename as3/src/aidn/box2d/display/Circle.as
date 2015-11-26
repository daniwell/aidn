package aidn.box2d.display
{
	import flash.display.Sprite;
	
	public class Circle extends Sprite
	{
		public function Circle( col :uint = 0x0 ) 
		{
			graphics.beginFill(col);
			graphics.drawCircle(0, 0, 10);
		}
	}
}