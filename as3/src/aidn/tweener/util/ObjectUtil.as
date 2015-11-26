package aidn.tweener.util 
{
	
	public class ObjectUtil 
	{
		public static function getParam ( baseObj :Object, time :Number = 0.0, delay :Number = 0.0, transition :String = "linear", onComplete :Function = null, onCompleteParams :Array = null ) :Object
		{
			baseObj.time       = time;
			if (0 < delay) baseObj.delay      = delay;
			baseObj.transition = transition;
			
			if (onComplete != null)
			{
				baseObj.onComplete = onComplete;
				if (onCompleteParams) baseObj.onCompleteParams = onCompleteParams;
			}
			
			return baseObj;
		}
	}
}