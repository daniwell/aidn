package aidn.main.util 
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.media.Sound;
	import flash.system.ApplicationDomain;
	
	public class Linkage 
	{
		public static function getSprite ( name :String ) :Sprite
		{
			var Asset :Class = ApplicationDomain.currentDomain.getDefinition(name) as Class;
			return new Asset() as Sprite;
		}
		public static function getMovieClip ( name :String ) :MovieClip
		{
			var Asset :Class = ApplicationDomain.currentDomain.getDefinition(name) as Class;
			return new Asset() as MovieClip;
		}
		public static function getSound ( name :String ) :Sound
		{
			var Asset :Class = ApplicationDomain.currentDomain.getDefinition(name) as Class;
			return new Asset() as Sound;
		}
		public static function getBitmapData ( name :String ) :BitmapData
		{
			var Asset :Class = ApplicationDomain.currentDomain.getDefinition(name) as Class;
			return new Asset(0,0) as BitmapData;
		}
		
		public static function hasDefinition ( name :String ) :Boolean
		{
			return ApplicationDomain.currentDomain.hasDefinition(name);
		}
		
	}
}