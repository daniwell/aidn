package com.papiness.effects
{	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	
	/**
	 * ドットフィルターです。
	 * @author daniwell
	 */
	public class DotFilter
	{
		
		private var bmd :BitmapData;
		
		/** 新しい DotFilter オブジェクトを作成します。 */
		public function DotFilter () 
		{
			
		}
		
		/**
		 * タイルの元となる、色を格納した二次元配列をセットします。
		 * @param ar 二次元配列。
		 */
		public function setArray ( ar :Array ) :void
		{
			var yoko :int = ar[0].length;
			var tate :int = ar.length;
			
			bmd = new BitmapData( yoko, tate, true, 0xffffff );
			
			for ( var k :int = 0; k < tate; k ++ ) {
				for ( var i :int = 0; i < yoko; i ++ ) {
					
					if ( ar[k][i] == null )	continue;
					
					if ( 0 <= ar[k][i] && ar[k][i] < 16777216 )				ar[k][i] += 4278190080;
					if ( 16777216 <= ar[k][i] && ar[k][i] <= 4294967295 )	bmd.setPixel32( i, k, ar[k][i] );
				}
			}
		}
		/**
		 * タイルの元となる、DisplayObject をセットします。
		 * @param obj DisplayObject。
		 * @param rect 範囲。
		 */
		public function setObj ( obj :*, rect :Rectangle = null  ) :void
		{
			if ( ! rect ) rect = new Rectangle();
			
			if ( rect.width  <= 0 ) rect.width  = obj.width  - rect.x;
			if ( rect.height <= 0 ) rect.height = obj.height - rect.y;
			
			bmd = new BitmapData( rect.width, rect.height, true, 0xffffff );
			bmd.draw( obj, new Matrix( 1, 0, 0, 1, -rect.x, - rect.y ) );
		}
		
		/**
		 * 描画します。
		 * @param obj 対象となる DisplayObject。
		 * @param rect 範囲。
		 */
		public function draw ( obj :*, rect :Rectangle = null ) :void
		{
			if ( ! rect ) rect = new Rectangle();
			
			if ( rect.width  <= 0 ) rect.width  = obj.stage.stageWidth;
			if ( rect.height <= 0 ) rect.height = obj.stage.stageHeight;
			
			var g :Graphics = obj.graphics;
			
			g.clear();
			g.beginBitmapFill( bmd, null, true, false );
			g.drawRect(rect.x, rect.y, rect.width, rect.height);
		}		
	}
}