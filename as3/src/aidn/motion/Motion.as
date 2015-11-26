package aidn.motion 
{
	import aidn.main.core.StageReference;
	import aidn.main.util.Debug;
	import aidn.motion.core.MotionContext;
	import aidn.motion.model.MotionInitData;
	import flash.display.MovieClip;
	import flash.display.Stage;
	
	public class Motion 
	{
		
		public function Motion ( main :MovieClip, stage :Stage = null ) 
		{
			if (! StageReference.stage)
			{
				if (stage)	StageReference.init(stage);
				else		Debug.log("StageReference is not inited !");
			}
			MotionContext.main = main;
		}
		
		public function init ( data :MotionInitData ) :void
		{
			
			
		}
		
		
		public function addColorIds ( id :int, colors :Array ) :void
		{
			
		}
		public function addEasingIds ( id :int, easingType :String ) :void
		{
			
		}
		
		
		
	}
}