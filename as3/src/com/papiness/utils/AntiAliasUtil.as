package com.papiness.utils 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.text.TextField;
	
	/**
	 * ディスプレイオブジェクトにアンチエイリアスを適用するクラス。
	 * @author daniwell
	 */
	public class AntiAliasUtil 
	{
		private static const SCALE    :uint = 4;
		private static const MARGIN_W :int = 10;
		private static const MARGIN_H :int =  0;
		
		/**
		 * 対象となるディスプレイオブジェクトにアンチエイリアスを適用したビットマップを生成します。
		 * @param	obj			アンチを掛ける対象オブジェクト。
		 * @param	range		レンジ。
		 * @param	quality		ブラーフィルターのクオリティ。
		 * @return
		 */
		public static function getAABitmap ( obj :DisplayObject, range :Number = 0.6, quality :int = 3 ) :Bitmap
		{
			var w :int = obj.width  + MARGIN_W;
			var h :int = obj.height + MARGIN_H;
			
			var mat1 :Matrix = new Matrix(); mat1.scale(  SCALE,   SCALE);
			var mat2 :Matrix = new Matrix(); mat2.scale(1/SCALE, 1/SCALE);
			
			var blur :Number = SCALE * range - 1;
			
			obj.filters = [ new BlurFilter( blur, blur, quality) ];
			
			var bmd1 :BitmapData = new BitmapData( w * SCALE, h * SCALE, true, 0x00ffffff );
			bmd1.draw( obj, mat1, null, null, null, true );
			
			var bmd2 :BitmapData = new BitmapData( w, h, true, 0x00ffffff );
			bmd2.draw( bmd1, mat2, null, null, null, true );
			
			bmd1.dispose();
			obj.filters = [];
			
			return new Bitmap( bmd2 );
		}
	}
}