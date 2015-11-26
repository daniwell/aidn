package aidn.main.controller 
{
	import aidn.main.display.base.DisplayBase3D;
	import flash.display.DisplayObjectContainer;
	import flash.geom.PerspectiveProjection;
	
	public class Display3DManager
	{
		private var _list   :/*DisplayBase3D*/Array;
		private var _total  :int;
		
		private var _parent      :DisplayObjectContainer;
		private var _perspective :PerspectiveProjection;
		
		public function Display3DManager() 
		{
			
		}
		
		// ------------------------------------------------------------------- public
		
		/** 初期化 */
		public function init ( parent :DisplayObjectContainer ) :void
		{
			_list  = [];
			_total = 0;
			_parent = parent;
			
			parent.transform.perspectiveProjection = new PerspectiveProjection();
			_perspective = parent.transform.perspectiveProjection;
		}
		
		/** 3D Object を追加 */
		public function add ( d3d :DisplayBase3D ) :void
		{
			_list[_total] = d3d;
			_total ++;
		}
		
		/** 3D Object を除外 */
		public function remove ( d3d :DisplayBase3D, kill :Boolean = false ) :void
		{
			for (var i :int = 0; i < _total; i ++)
			{
				if (_list[i] == d3d) {
					if (kill) {
						_list[i].remove();
						_list[i] = null;
					}
					_list.splice(i, 1);
					_total --;
					break;
				}
			}
		}
		
		/** 簡易 Z-sort */
		public function sort ( ) :void
		{
			_list.sortOn("z", Array.DESCENDING | Array.NUMERIC);
			
			for (var i :int = 0; i < _total; i ++)
			{
				_parent.setChildIndex(_list[i].dobj, i);
			}
		}
		
		/** PerspectiveProjection */
		public function get perspective ( ) :PerspectiveProjection { return _perspective; }
	}
}