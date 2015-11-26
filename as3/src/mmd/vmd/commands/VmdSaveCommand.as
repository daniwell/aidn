package mmd.vmd.commands 
{
	import aidn.main.commands.base.CommandBase;
	import aidn.main.core.StageReference;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import mmd.vmd.model.VmdData;
	
	public class VmdSaveCommand extends CommandBase
	{
		private var _vmdData :VmdData;
		
		private var _now   :int;
		private var _total :int;
		
		private var _ba  :ByteArray;
		
		private var _interval :Number;
		
		public function VmdSaveCommand ( vmdData :VmdData, interval :Number = 30 ) 
		{
			_vmdData  = vmdData;
			_interval = interval;
		}
		
		override public function execute ( ) :void 
		{
			_ba = _vmdData.getByteArray(true);
			
			_now   = 0;
			_total = _vmdData.datas.length;
			
			StageReference.addEnterFrameFunction(_enterFrame);
		}
		
		
		private function _enterFrame ( ) :void
		{
			var t :Number = getTimer();
			
			while (1)
			{
				if (_total <= _now || _interval <= getTimer() - t) break;
				
				var tmp :ByteArray = _vmdData.datas[_now++].getByteArray();
				_ba.writeBytes(tmp, 0, tmp.length);
			}
			
			_dispatchProgress(_now / _total);
			
			if (_total <= _now)
			{
				StageReference.removeEnterFrameFunction(_enterFrame);
				_dispatchComplete();
			}
		}
		
		public function get byteArray ( ) :ByteArray { return _ba; }
	}
}