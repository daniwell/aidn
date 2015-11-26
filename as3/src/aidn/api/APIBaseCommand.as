package aidn.api 
{
	import aidn.main.commands.URLLoaderCommand;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	public class APIBaseCommand extends URLLoaderCommand
	{
		public function APIBaseCommand ( url :String, param :Object = null, method :String = "POST", encode :Boolean = false ) 
		{
			var vari :URLVariables = new URLVariables();
			for (var key :String in param)
			{
				if (encode) vari[key] = encodeURIComponent(param[key]);
				else		vari[key] = param[key];
			}
			
			var req :URLRequest = new URLRequest();
			req.method = method;
			req.data   = vari;
			req.url    = url;
			
			super(req);
		}
		
		override protected function _complete ( evt :Event ) :void 
		{
			if (! _parseData())
			{
				evt.stopImmediatePropagation();
				super._dispatchFailed();
				return;
			}
			
			super._complete(evt);
		}
		
		protected function _parseData ( ) :Boolean
		{
			return false;
		}
		
	}

}