package mmd.vmd.model 
{
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class VmdKeyData 
	{
		/// ボーン名
		public var name  :String;
		/// フレーム番号
		public var frame :uint;
		
		/// 位置
		public var pos   :Vector3D = new Vector3D();
		/// 回転(クォータニオン)
		public var rot   :Vector3D = new Vector3D(0, 0, 0, 1);
		/// 補間パラメータ
		public var inter :Array = [64,20,64,20,0,20,0,20,64,107,64,107,127,107,127,107,20,64,20,0,20,0,20,64,107,64,107,127,107,127,107,1,64,20,0,20,0,20,64,107,64,107,127,107,127,107,1,0,20,0,20,0,20,64,107,64,107,127,107,127,107,1,0,0];
		
		// IK 以外のデフォルト値
		// 20,20,20,20,20,20,20,20,107,107,107,107,107,107,107,107,20,20,20,20,20,20,20,107,107,107,107,107,107,107,107,1,20,20,20,20,20,20,107,107,107,107,107,107,107,107,1,0,20,20,20,20,20,107,107,107,107,107,107,107,107,1,0,0
		
		private const CHAR_SET :String = "shift-jis";
		
		
		public function VmdKeyData ( ba :ByteArray = null ) 
		{
			if (ba) _parse(ba);
		}
		
		/// .vmd 用 ByteArray で取得
		public function getByteArray ( ) :ByteArray
		{
			var ba :ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;
			ba.writeMultiByte(name, CHAR_SET);
			ba.position = 15;
			ba.writeUnsignedInt(frame);
			
			ba.writeFloat(pos.x);
			ba.writeFloat(pos.y);
			ba.writeFloat(pos.z);
			
			ba.writeFloat(rot.x);
			ba.writeFloat(rot.y);
			ba.writeFloat(rot.z);
			ba.writeFloat(rot.w);
			
			for (var i :int = 0; i < 64; i ++)
			{
				if (i < inter.length)	ba.writeByte(inter[i]);
				else					ba.writeByte(0);
			}
			
			return ba;
		}
		
		private function _parse ( ba :ByteArray ) :void
		{
			// ba.endian = Endian.LITTLE_ENDIAN;
			
			name  = ba.readMultiByte(15, CHAR_SET);
			frame = ba.readUnsignedInt();
			
			pos = new Vector3D(ba.readFloat(), ba.readFloat(), ba.readFloat());
			rot = new Vector3D(ba.readFloat(), ba.readFloat(), ba.readFloat(), ba.readFloat());
			
			inter = [];
			for (var i :int = 0; i < 64; i ++)
			{
				inter[i] = ba.readByte();
			}
		}
		
		/// 複製
		public function clone ( ) :VmdKeyData
		{
			var d :VmdKeyData = new VmdKeyData();
			d.name  = name;
			d.frame = frame;
			d.pos   = pos.clone();
			d.rot   = rot.clone();
			d.inter = inter.slice();
			
			return d;
		}
		
		public function toString ( ) :String
		{
			var s :String = "--------------------------------------------------- [VMD KEY DATA]";
			s += "\nname: "  + name;
			s += "\nframe: " + frame;
			s += "\npos: "   + pos;
			s += "\nrot: "   + rot;
			s += "\ninter: " + inter;
			return s;
		}
	}
}