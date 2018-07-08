package tgra.commands 
{
	import aidn.main.commands.URLLoaderCommand;
	import flash.events.Event;
	import tgra.model.TGraList;
	
	public class TextGraphicsLoadCommand extends URLLoaderCommand
	{
		public var dataList :TGraList;
		
		public function TextGraphicsLoadCommand(jsonUrl :String) 
		{
			super(jsonUrl);
		}
		
		override protected function _complete (evt :Event) :void 
		{
			var s :String = String(data);
			dataList = new TGraList(s);
			
			super._complete(evt);
		}
		
	}
}