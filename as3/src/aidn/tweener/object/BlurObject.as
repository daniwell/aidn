package aidn.tweener.object 
{
	public dynamic class BlurObject extends Object
	{
		
		
		public function BlurObject(_Blur_blurX :Number = -1, _Blur_blurY :Number = -1, _Blur_quality: Number = -1) 
		{
			if (0 <= _Blur_blurX)   this._Blur_blurX   = _Blur_blurX;
			if (0 <= _Blur_blurY)   this._Blur_blurY   = _Blur_blurY;
			if (0 <= _Blur_quality) this._Blur_quality = _Blur_quality;
		}
		
	}

}