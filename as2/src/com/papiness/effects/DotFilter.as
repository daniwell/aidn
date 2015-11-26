/**
 * @author daniwell
 * http://www.papiness.com/
 */

import flash.display.BitmapData;
import flash.geom.Matrix;

class com.papiness.effects.DotFilter {	
	
	private var bmd :BitmapData;
	
	public function DotFilter( ) {
	}
	public function setArray( ar :Array ) :Void {
		
		var yoko :Number = ar[0].length;
		var tate :Number = ar.length;
		
		bmd = new BitmapData( yoko, tate, true, 0xffffff );
		
		for ( var k :Number = 0; k < tate; k ++ ) {
			for ( var i :Number = 0; i < yoko; i ++ ) {
				
				if ( 0 <= ar[k][i] && ar[k][i] < 16777216 )							ar[k][i] += 4278190080;
				if ( 16777216 <= ar[k][i] && ar[k][i] <= 4294967295 )		bmd.setPixel32( i, k, ar[k][i] );
			}
		}
	}
	public function setObj( mc :MovieClip, initObj :Object  ) :Void {
		
		if ( ! initObj )	var initObj :Object = new Object();
		
		initObj._x = initObj._x || 0;
		initObj._y = initObj._y || 0;
		
		if ( isNaN( initObj._width ) || initObj._width <= 0 )		initObj._width = mc._width - initObj._x;
		if ( isNaN( initObj._height ) || initObj._height <= 0 )	initObj._height = mc._height - initObj._y;
		
		bmd = new BitmapData( initObj._width, initObj._height, true, 0xffffff );
		bmd.draw( mc, new Matrix( 1,0,0,1, -initObj._x, -initObj._y ) );
	}
	
	public function setFilter( mc :MovieClip, initObj :Object ) :Void {
		
		if ( ! initObj )	var initObj :Object = new Object();
		
		initObj._x = initObj._x || 0;
		initObj._y = initObj._y || 0;
		
		if ( isNaN( initObj._width ) || initObj._width <= 0 )		initObj._width = Stage.width;
		if ( isNaN( initObj._height ) || initObj._height <= 0 )	initObj._height = Stage.height;
		
		mc.beginBitmapFill( bmd, null, true, false );
		mc.moveTo( initObj._x, initObj._y );
		mc.lineTo( initObj._x, initObj._y+initObj._height );
		mc.lineTo( initObj._x+initObj._width, initObj._y+initObj._height );
		mc.lineTo( initObj._x+initObj._width, initObj._y );
			
		mc.endFill( );
	}
	
}