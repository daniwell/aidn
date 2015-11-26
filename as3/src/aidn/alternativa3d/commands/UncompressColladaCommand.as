package aidn.alternativa3d.commands 
{
	import aidn.main.commands.UncompressCommand;
	import flash.events.Event;
	
	public class UncompressColladaCommand extends UncompressCommand
	{
		private var _separator :String;
		
		private var _colladaDatas :/*XML*/Array;
		
		public function UncompressColladaCommand ( url :*, separator :String = "[SEPARATOR]" ) 
		{
			_separator = separator;
			super(url);
		}
		
		override protected function _complete(evt:Event):void 
		{
			var a :Array = data.split(_separator);
			var l :int   = a.length;
			
			_colladaDatas = [];
			
			for (var i :int = 0; i < l; i ++)
			{
				_colladaDatas[i] = XML(a[i]);
			}
			
			super._complete(evt);
		}
		
		public function get colladaDatas():Array/*XML*/ { return _colladaDatas; }
	}

}