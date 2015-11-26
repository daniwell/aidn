package aidn.main.util
{
	import flash.display.*;
	
	/**
	 * 破棄します。
	 */
	public class Hide 
	{
		/**
		 * obj 以下を破棄します(obj自体は破棄されません)。
		 * @param	obj
		 */
		public static function start ( obj :DisplayObjectContainer, clearBitmap :Boolean = true, clearGraphics :Boolean = true ) :void
		{
			while ( 0 < obj.numChildren )
			{
				var m :* = obj.getChildAt(0);
				if ( m == null ) break;
				
				// いろいろ消去
				if ( m is Sprite || m is MovieClip || m is Shape )
				{
					if (clearGraphics) m.graphics.clear();
				}
				else if ( m is Bitmap )
				{
					if (m.bitmapData && clearBitmap)
					{
						m.bitmapData.dispose();
						m.bitmapData = null;
					}
				}
				else if ( m is Loader )
				{
					try { m.close();  } catch ( e :* ) { }
					try { m.unload(); } catch ( e :* ) { }
				}
				
				// 再帰
				if ( m is DisplayObjectContainer ) start(m, clearBitmap, clearGraphics);
				
				m.parent.removeChild(m);
				m = null;
			}
			
		}
	}
}