package aidn.main.util 
{
	
	public class ColorUtil 
	{
		public static function HSV2RGB (h:Number, s:Number, v:Number) :uint
		{
			if(s == 0) return uint(v*255<<16) | uint(v*255<<8) | uint(v*255);
			else
			{
				var rgb:uint = 0xffffff;
				var hi:int = (h/60)>>0;
				var f:Number = (h/60 - hi);
				var p:Number = v*(1 - s);
				var q:Number = v*(1 - f*s);
				var t:Number = v*(1-(1-f)*s);
				if(hi==0) rgb = uint(v*255<<16) | uint(t*255<<8) | uint(p*255);
				else if(hi==1) rgb = uint(q*255<<16) | uint(v*255<<8) | uint(p*255);
				else if(hi==2) rgb = uint(p*255<<16) | uint(v*255<<8) | uint(t*255);
				else if(hi==3) rgb = uint(p*255<<16) | uint(q*255<<8) | uint(v*255);
				else if(hi==4) rgb = uint(t*255<<16) | uint(p*255<<8) | uint(v*255);
				else if(hi==5) rgb = uint(v*255<<16) | uint(p*255<<8) | uint(q*255);
				return rgb;
			}
		}
		
	}

}