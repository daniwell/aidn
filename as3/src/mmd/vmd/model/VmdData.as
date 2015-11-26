package mmd.vmd.model 
{
	import aidn.main.util.Debug;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class VmdData 
	{
		/// データ名 
		public var dataName     :String = "Vocaloid Motion Data 0002";
		/// モデル名
		public var modelName    :String = "初音ミク";
		///　キーフレームの数
		public var frameDataNum :int;
		
		/// VMD KEY DATAS
		public var datas :/*VmdKeyData*/Array;
		
		private const CHAR_SET :String = "shift-jis";
		
		public function VmdData ( ba :ByteArray = null ) 
		{
			if (ba) _parse(ba);
		}
		
		public function add ( data :VmdKeyData ) :void
		{
			if (datas == null) datas = [];
			
			var l :int = datas.length;
			for (var i :int; i < l; i ++)
			{
				if (data.frame < datas[i].frame) datas.splice(i, 0, data);
			}
			if (i == l) datas.push(data);
			frameDataNum = datas.length;
		}
		
		public function getByteArray ( headerOnly :Boolean = false ) :ByteArray
		{
			var ba :ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;
			
			// \0
			ba.writeMultiByte(dataName, CHAR_SET);
			ba.position = 30;
			ba.writeMultiByte(modelName, CHAR_SET);
			ba.position = 30 + 20;
			ba.writeUnsignedInt(frameDataNum);
			
			if (! headerOnly)
			{
				var l :int = datas.length;
				for (var i :int = 0; i < l; i ++)
				{
					var tmp :ByteArray = datas[i].getByteArray();
					ba.writeBytes(tmp, 0, tmp.length);
				}
			
				/*
				// 末尾
				trace(ba.writeUnsignedInt(0));
				trace(ba.writeUnsignedInt(0));
				trace(ba.writeUnsignedInt(0));
				trace(ba.writeUnsignedInt(0));
				*/
			}
			
			return ba;
		}
		
		private function _parse ( ba :ByteArray ) :void
		{
			var len :uint = ba.length;
			
			ba.position = 0;
			ba.endian = Endian.LITTLE_ENDIAN;
			
			/// bytes: 0 ~ 54
			dataName     = ba.readMultiByte(30, CHAR_SET);
			modelName    = ba.readMultiByte(20, CHAR_SET);
			frameDataNum = ba.readUnsignedInt();
			
			datas = [];
			
			/// bytes: 54 ~
			while (1)
			{
				datas.push(new VmdKeyData(ba));
				if (len - ba.position < 111) break;
			}
		}
		
		public function toString ( ) :String
		{
			var s :String = "--------------------------------------------------- [VMD DATA]";
			s += "\ndataName: "     + dataName;
			s += "\nmodelName: "    + modelName;
			s += "\nframeDataNum: " + frameDataNum;
			
			for (var i :int = 0; i < datas.length; i ++) s += "\n" + datas[i];
			return s;
		}
	}
}