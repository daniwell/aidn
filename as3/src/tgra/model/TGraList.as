package tgra.model 
{
	import flash.utils.Dictionary;
	public class TGraList 
	{
		public var datas :Dictionary
		
		public function TGraList (data :*) 
		{
			var json :Object;
			if (data is String) json = JSON.parse(data);
			else				json = data;
			
			datas = new Dictionary();
			
			for (var k :String in json)
			{
				datas[k] = new TGraData(json[k]);
			}
		}
		
		public function getData (t :String) :TGraData
		{
			return datas[t];
		}
		
		public function calcMaxHeight () :Number
		{
			var maxH :Number = 0;
			for each (var t :TGraData in datas)
			{
				var h :Number = t.marginTop + t.height;
				if (maxH < h) maxH = h;
			}
			return maxH;
		}
		
		/** 文字列の横幅計算 */
		public function calcWidth (text :String, margin :Number = 0) :Number
		{
			var l :int = text.length;
			var w :Number = 0;
			
			for (var i :int = 0; i < l; i ++)
			{
				var t :String = text.charAt(i);
				var data :TGraData = getData(t);
				if (data)
				{
					w += data.width + margin;
				}
			}
			w -= margin;
			return w;
		}
		
	}
}