package aidn.alternativa3d.commands 
{
	import aidn.main.commands.base.CommandBase;
	import aidn.main.commands.SequentialCommand;
	import aidn.main.commands.URLLoaderCommand;
	import aidn.main.util.CompressUtil;
	
	public class CompressColladaCommand extends SequentialCommand
	{
		private var _list :Array;
		private var _ct   :int;
		
		private var _nums :Array;
		
		private var _data :String;
		
		private var _separator :String;
		private var _autoSave  :Boolean;
		
		public function CompressColladaCommand ( autoSave :Boolean = false, separator :String = "[SEPARATOR]" ) 
		{
			_separator = separator;
			_autoSave  = autoSave;
			
			_list = [];
			_ct   = 0;
			
			_nums = [];
			_data = "";
		}
		
		public function addData ( data :* ) :void
		{
			_list[_ct] = String(data);
			_ct ++;
		}
		public function addPath ( path :String ) :void
		{
			add(new URLLoaderCommand(path));
			_nums.push(_ct);
			_ct ++;
		}
		
		override protected function _completeCommand(cmd:CommandBase, now:int):void 
		{
			var n :int = _nums[now];
			_list[n] = String(URLLoaderCommand(cmd).data);
		}
		
		override protected function _dispatchComplete ( ) :void 
		{
			for (var i :int = 0; i < _ct; i ++)
			{
				if (i == 0) { _data = _list[i]; continue; }
				_data += _separator + _list[i];
			}
			
			if (_autoSave) save();
			
			super._dispatchComplete();
		}
		
		public function save ( filename :String = "collada" ) :void
		{
			CompressUtil.save(CompressUtil.compress(_data), filename);
		}
		
		
	}

}