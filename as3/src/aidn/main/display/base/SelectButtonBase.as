package aidn.main.display.base 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	
	public class SelectButtonBase extends ButtonBase
	{
		
		private var _isSelected :Boolean;
		
		private var _selected :MovieClip;
		
		
		public function SelectButtonBase ( dobj :DisplayObjectContainer, clickFunc :Function = null, selectedName :String = "selected" ) 
		{
			super(dobj, clickFunc);
			
			_selected = dobj.getChildByName(selectedName) as MovieClip;
			_selected.visible = false;
		}
		
		// ------------------------------------------------------------------- public
		
		// ------------------------------------------------------------------- private
		
		// ------------------------------------------------------------------- getter & setter
		
		public function get isSelected ( ) :Boolean { return _isSelected; }
		
		public function set isSelected ( value :Boolean ) :void 
		{
			_isSelected = value;
			
			if (value)
			{
				//_dobj.mouseEnabled = false;
				//_removeEvents();
				
				_selected.visible = true;
				if (_out && _over) _out.visible = _over.visible = false;
			}
			else
			{
				//_dobj.mouseEnabled = true;
				//_addEvents();
				
				if (_out && _over)
				{
					_out.visible = true;
					_over.visible = false;
				}
				_selected.visible = false;
			}
		}
	}
}