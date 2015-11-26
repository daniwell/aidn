package aidn.box2d.model 
{
	
	public class PhysicalData 
	{
		/** 密度(0にすると固定) */
		public var density     :Number;
		/** 摩擦(大きいと滑りにくい) */
		public var friction    :Number;
		/** 跳ね返り(大きいと反発しやすい) */
		public var restitution :Number;
		
		/**
		 * 
		 * @param	density			密度(0にすると固定)
		 * @param	friction		摩擦(大きいと滑りにくい)
		 * @param	restitution		跳ね返り(大きいと反発しやすい)
		 */
		public function PhysicalData( density :Number = 0.2, friction :Number = 0.0, restitution :Number = 0.0 ) 
		{
			this.density     = density;
			this.friction    = friction;
			this.restitution = restitution;
		}
	}
}