package aidn.main.effect
{	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	
	public class PatternFilter
	{
		private var _bmd :BitmapData;
		
		/** 新しい PatternFilter オブジェクトを作成します。 */
		public function PatternFilter () 
		{
			
		}
		
		/**
		 * タイルの元となる、色を格納した二次元配列をセットします。
		 * @param ar	二次元配列(32bit)。
		 */
		public function setArray ( ar :Array ) :void
		{
			var yoko :int = ar[0].length;
			var tate :int = ar.length;
			
			_bmd = new BitmapData( yoko, tate, true, 0x0 );
			_bmd.lock();
			for ( var k :int = 0; k < tate; k ++ ) {
				for ( var i :int = 0; i < yoko; i ++ ) {
					if ( ar[k][i] == null )	continue;
					_bmd.setPixel32( i, k, ar[k][i] );
				}
			}
			_bmd.unlock();
		}
		/**
		 * タイルの元となる、DisplayObject をセットします。
		 * @param obj		IBitmapDrawable
		 * @param rect		
		 */
		public function setObj ( obj :*, rect :Rectangle = null ) :void
		{
			if ( ! rect )	rect = new Rectangle(0, 0, obj.width, obj.height);
			
			if ( rect.width  <= 0 )		rect.width  = obj.width  - rect.x;
			if ( rect.height <= 0 )		rect.height = obj.height - rect.y;
			
			_bmd = new BitmapData( rect.width, rect.height, true, 0xffffff );
			_bmd.draw( obj, new Matrix( 1, 0, 0, 1, - rect.x, - rect.y ) );
		}
		
		/**
		 * フィルターを描画します。
		 * @param target	MovieClip, Sprite, Shape
		 * @param rect		
		 */
		public function draw ( target :*, rect :Rectangle = null, isClear :Boolean = true ) :void
		{
			if ( ! rect )	rect = new Rectangle(0, 0, target.width, target.height);
			
			if ( rect.width  <= 0 )	rect.width  = target.stage.stageWidth;
			if ( rect.height <= 0 )	rect.height = target.stage.stageHeight;
			
			var g :Graphics = target.graphics as Graphics;
			if (isClear) g.clear();
			g.beginBitmapFill( _bmd, null, true, false );
			g.drawRect( rect.x, rect.y, rect.width, rect.height );
			g.endFill();
		}	
		
		
		public function get bmd ( ) :BitmapData { return _bmd; }
	}
}