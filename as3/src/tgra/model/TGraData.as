package tgra.model 
{
	import flash.geom.Point;
	
	public class TGraData 
	{
		/** 座標配列 */
		public var data :/*Number*/Array;
		/** 座標配列 (data を Point に格納したもの) */
		public var points :/*Point*/Array;
		
		/** 1: moveTo, 2: lineTo, 3: curveTo */
		public var commands :/*int*/Array;
		
		/** 横幅 (マージン含まない) */
		public var width :Number;
		/** 縦幅 (マージン含まない) */
		public var height :Number;
		
		public var marginTop  :Number;
		public var marginLeft :Number;
		
		
		public function TGraData (d :Object) 
		{
			data     = d.data;
			commands =  d.commands;
			points   = [];
			
			var minX :Number = 1000, maxX :Number = 0;
			var minY :Number = 1000, maxY :Number = 0;
			
			var l :int = data.length;
			for (var i :int = 0; i < l; i += 2)
			{
				var p :Point = new Point(data[i], data[i + 1]);
				points.push(p);
				
				if (p.x < minX) minX = p.x;
				if (maxX < p.x) maxX = p.x;
				if (p.y < minY) minY = p.y;
				if (maxY < p.y) maxY = p.y;
			}
			
			marginLeft = minX;
			marginTop  = minY;
			width  = maxX - minX;
			height = maxY - minY;
		}
	}
}