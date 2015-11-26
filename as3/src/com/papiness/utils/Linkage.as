package com.papiness.utils 
{
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	
	public class Linkage
	{
		
		public function getSprite ( name :String ) :Sprite
		{
			var Asset :Class =  ApplicationDomain.currentDomain.getDefinition(name) as Class;
			return new Asset() as Sprite;
		}
		
		
	}

}