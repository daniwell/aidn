package mmd.vmd.commands 
{
	import aidn.main.commands.URLLoaderCommand;
	import flash.events.Event;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	import mmd.vmd.model.VmdData;
	
	public class VmdLoadCommand extends URLLoaderCommand
	{
		private var _vmdData :VmdData;
		
		public function VmdLoadCommand ( url :* ) 
		{
			super(url, URLLoaderDataFormat.BINARY);
		}
		
		override protected function _complete ( evt :Event ) :void 
		{
			_vmdData = new VmdData(data as ByteArray);
			
			super._complete(evt);
		}
		
		/// VMD DATA
		public function get vmdData ( ) :VmdData { return _vmdData; }
	}
}