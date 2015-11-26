package aidn.main.display 
{
	import aidn.main.display.base.ButtonBase;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	
	
	public class SaveButton extends ButtonBase
	{
		
		private var _data :*;
		private var _name :String;
		
		
		public function SaveButton ( dobj :DisplayObjectContainer, parent :DisplayObjectContainer = null ) 
		{
			super(dobj, _click, parent);
		}
		
		/**
		 * クリックした時に保存されるデータとファイル名をセット。
		 * @param	data
		 * @param	name
		 */
		public function setData ( data :*, name :String = null ) :void
		{
			_data = data;
			_name = name;
		}
		
		
		private function _click ( evt :MouseEvent ) :void
		{
			if (! _data) return;
			
			var fr :FileReference = new FileReference();
			fr.save(_data, _name);
		}
		
	}

}