/**
 * @author daniwell
 * http://www.papiness.com/
 */

class com.papiness.effects.EffectDrag {
	
	private var mc :MovieClip;
	public var speed :Number = 5;
	public var type :Number = 0;
	public var wait :Number = 0;
	
	public function setMC ( m :MovieClip ) :Void {
		mc = m;
	}
	public function getMC (  ) :MovieClip {
		return mc;
	}
	
	public function start (  ) :Void {
		start_effect ( mc, speed, type, wait );
	}
	
	private function start_effect ( mc :MovieClip, sp :Number, ty :Number, w :Number ) :Void {
	
		var m :MovieClip = mc.createEmptyMovieClip( "m_effect"+Math.floor( Math.random()*10000 ), mc.getNextHighestDepth() );
		
		switch ( ty ) {
		case 0 :
			m.bmd = new flash.display.BitmapData( 1, mc._height );
			m.n = 1;
			m.sp = sp;
		break;
		case 1 :
			m.bmd = new flash.display.BitmapData( 1, mc._height );
			m.n = mc._width - 1;
			m.sp = -sp;
		break;
		case 2 :
			m.bmd = new flash.display.BitmapData( mc._width, 1 );
			m.n = 1;
			m.sp = sp;
		break;
		case 3 :
			m.bmd = new flash.display.BitmapData( mc._width, 1 );
			m.n = mc._height - 1;
			m.sp = -sp;
		break;
		}
		
		m.matrix = new flash.geom.Matrix( );
		m.mc = mc;
		m.t = ty;	
		
		switch ( ty ) {
		case 0 :	case 1 :	m.matrix.tx = - m.n;		break;
		case 2 :	case 3 :	m.matrix.ty = - m.n;		break;
		}
		
		mcFill( m );
		
		m.onEnterFrame = function ( ) :Void {
			
			switch ( this.t ) {
			case 0 :	case 1 :	this.matrix.tx = - this.n;	break;
			case 2 :	case 3 :	this.matrix.ty = - this.n;	break;
			}
			//*
			this.clear();
			this.bmd.draw( this.mc, this.matrix );
			
			this.beginBitmapFill( this.bmd, null, true, true );
			switch ( this.t ) {
			case 0 :
				this.moveTo( this.n, 0 );
				this.lineTo( this.n, this.mc._height );
				this.lineTo( this.mc._width, this.mc._height );
				this.lineTo( this.mc._width, 0 );
			break;
			case 1 :
				this.moveTo( 0, 0 );
				this.lineTo( 0, this.mc._height );
				this.lineTo( this.n+1, this.mc._height );
				this.lineTo( this.n+1, 0 );
			break;
			case 2 :
				this.moveTo( 0, this.n );
				this.lineTo( 0, this.mc._height );
				this.lineTo( this.mc._width, this.mc._height );
				this.lineTo( this.mc._width, this.n );
			break;
			case 3 :
				this.moveTo( 0, 0 );
				this.lineTo( 0, this.n+1 );
				this.lineTo( this.mc._width, this.n+1 );
				this.lineTo( this.mc._width, 0 );
			break;
			}
			this.endFill();
			//*/
			//mcFill( this );
			
			if ( w <= 0 ) {
				this.n += this.sp;
			} else w --;
			
			switch ( this.t ) {
			case 0 :	if ( this.mc._width <= this.n )		this.removeMovieClip();	break;
			case 1 :	if ( this.n <= 0 )						this.removeMovieClip();	break;
			case 2 :	if ( this.mc._height <= this.n )	this.removeMovieClip();	break;
			case 3 :	if ( this.n <= 0 )						this.removeMovieClip();	break;
			}
		}
	}
	
	private function mcFill ( m :MovieClip ) :Void {
		
		m.clear();
		m.bmd.draw( m.mc, m.matrix );
		
		m.beginBitmapFill( m.bmd, null, true, true );
		switch ( m.t ) {
		case 0 :
			m.moveTo( m.n, 0 );
			m.lineTo( m.n, m.mc._height );
			m.lineTo( m.mc._width, m.mc._height );
			m.lineTo( m.mc._width, 0 );
		break;
		case 1 :
			m.moveTo( 0, 0 );
			m.lineTo( 0, m.mc._height );
			m.lineTo( m.n+1, m.mc._height );
			m.lineTo( m.n+1, 0 );
		break;
		case 2 :
			m.moveTo( 0, m.n );
			m.lineTo( 0, m.mc._height );
			m.lineTo( m.mc._width, m.mc._height );
			m.lineTo( m.mc._width, m.n );
		break;
		case 3 :
			m.moveTo( 0, 0 );
			m.lineTo( 0, m.n+1 );
			m.lineTo( m.mc._width, m.n+1 );
			m.lineTo( m.mc._width, 0 );
		break;
		}
		m.endFill();		
	}
}