package vsqx.commands 
{
	import aidn.main.commands.URLLoaderCommand;
	import flash.events.Event;
	import vsqx.model.VSQXData;
	
	public class VSQXCommand extends URLLoaderCommand
	{
		public var vsqx :VSQXData;
		
		public function VSQXCommand (url :String) 
		{
			super(url);
		}
		
		override protected function _complete (evt :Event) :void 
		{
			// delete namespace
			var s :String = String(data);
			s = s.replace(new RegExp(/xmlns[^"]*"[^"]*"/gi), "");
			s = s.replace(new RegExp(/xsi[^"]*"[^"]*"/gi), "");
			
			vsqx = new VSQXData(XML(s));
			
			super._complete(evt);
		}
		
	}

}