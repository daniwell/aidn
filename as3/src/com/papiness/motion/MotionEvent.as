package com.papiness.motion
{
	import flash.events.Event;
	
	/**
	 * MotionEvent クラスは、Motion クラスによってブロードキャストされるイベントを表します。
	 * @author daniwell
	 * @see Motion
	 */
	public class MotionEvent extends Event
	{
		/** 現在何番目（の DisplayObject のモーション中）かのカウント。 */
		public var count:int;
		
		public static const PROGRESS:String = "progress";
		public static const COMPLETE:String = "complete";
		
		public function MotionEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) 
		{
			count = 0;
			super(type, bubbles, cancelable);
        }
        
		/** @private */
		public override function clone():Event {
			return new MotionEvent( type, bubbles, cancelable );
		}
		
	}
}