package com.papiness.transitions
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import caurina.transitions.Tweener;
	
	/**
	* @eventType TweenSequencer.COMPLETE
	*/
	[Event(name="complete", type="flash.events.Event")]
	/**
	* @eventType TweenSequencer.PROGRESS
	*/
	[Event(name="progress", type="flash.events.Event")]
	
	
	/**
	 * 連続的に Tweener を動かし、制御します。
	 * @author daniwell
	 * @see http://code.google.com/p/tweener/
	 * @see "Require: caurina.transitions.Tweener"
	 */
	public class TweenSequencer extends EventDispatcher
	{
		/** @private */
		public static const COMPLETE :String = "complete";
		/** @private */
		public static const PROGRESS :String = "progress";
		
		
		private var _num :int;
		private var _total :int;
		
		private var _objArray :Array;
		private var _paramArray :Array;
		
		/** 新しい TweenSequencer オブジェクトを作成します。 */
		public function TweenSequencer() 
		{
			clear();
		}
		
		// ----------------------------------------------------------------
		/**
		 * モーショントゥイーンを追加します。
		 * @param obj Tweener.addTween における第1引数と同様。 
		 * @param param Tweener.addTween における第2引数と同様。
		 */
		public function add ( obj :Object, param :Object ) :void
		{
			param.onComplete = _repeat;
			if ( ! param.transition )
				param.transition = "linear";
			
			_objArray.push( obj );
			_paramArray.push( param );
			
			_total = _objArray.length;
		}
		/**
		 * ウェイトトゥイーンを追加します。
		 * @param time time (sec) ウェイトします。
		 */
		public function addWait ( time :Number ) :void
		{
			var obj :Object = new Object();
			var param :Object = new Object();
			
			param.time = time;
			if ( time == 0 ) param.time = 0.001;
			
			param.onComplete = _repeat;
			
			_objArray.push( obj );
			_paramArray.push( param );
			
			_total = _objArray.length;
		}
		
		// ----------------------------------------------------------------
		/** 追加したトゥイーンをすべて消去します。 */
		public function clear ( ) :void
		{
			_num = 0;
			_objArray = new Array();
			_paramArray = new Array();
			
			_total = 0;
		}
		/** 追加したトゥイーンでひとつ前のものを消去します。 */
		public function undo () :void
		{
			_objArray.pop();
			_paramArray.pop();
			
			_total = _objArray.length;
		}
		
		// ----------------------------------------------------------------
		/** 追加した順にトゥイーンを開始します。 */
		public function start () :void
		{
			if ( _num != 0 ) _num = 0;
			
			_repeat();
		}
		/** トゥイーンを一時停止します。 */
		public function pause () :void
		{
			Tweener.pauseTweens( _objArray[_num] );
		}
		/** 一時停止したトゥイーンを再開します。 */
		public function resume () :void
		{
			Tweener.resumeTweens( _objArray[_num] );
		}
		/** トゥイーンを停止します。 */
		public function stop () :void
		{
			Tweener.removeTweens( _objArray[_num] );
			_num = 0;
		}
		
		
		private function _repeat ( ) :void
		{
			if ( _num < _objArray.length )
			{
				Tweener.addTween( _objArray[_num], _paramArray[_num] );
				_num ++;
				
				dispatchEvent( new Event(TweenSequencer.PROGRESS) );
			}
			else
			{
				dispatchEvent( new Event(TweenSequencer.COMPLETE) );
			}
		}
		
		
		/** 追加したオブジェクト。 */
		public function get objects    ():Array { return _objArray; }
		/** 追加したパラメータ。 */
		public function get parameters ():Array { return _paramArray; }
		
		/** 現在再生中のモーション番号です。 */
		public function get now   ():int { return _num; }
		/** 追加したモーションの合計数です。 */
		public function get total ():int { return _total; }
	}
}