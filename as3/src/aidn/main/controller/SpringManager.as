package aidn.main.controller 
{
	
	public class SpringManager
	{
    	private var _nowValue :Number;
		private var _endValue :Number;
		
		private var _v        :Number = 0;
		private var _spring   :Number = 0.2;
		private var _friction :Number = 0.8;
		
		public function SpringManager ( startValue :Number, endValue :Number )
		{
			_nowValue = startValue;
			_endValue = endValue;
		}
		
		public function setParam ( spring :Number = 0.2, friction :Number = 0.8 ) :void { _spring = spring; _friction = friction; }
		
		public function setEndValue ( value :Number ) :void { _endValue = value; }
		
		public function update ( ) :Number
		{
			_v += (_endValue - _nowValue) * _spring;
			_v *= _friction;
			_nowValue += _v;
			
			return _nowValue;
		}
		
		public function get nowValue ( ) :Number { return _nowValue; }
		public function get endValue ( ) :Number { return _endValue; }
	}

}