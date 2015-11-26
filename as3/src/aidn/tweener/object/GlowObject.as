package aidn.tweener.object 
{
	
	public dynamic class GlowObject extends Object
	{
		public function GlowObject(_Glow_blurX :Number = -1, _Glow_blurY :Number = -1, _Glow_color :int = -1, _Glow_alpha :Number = -1, _Glow_quality :Number = -1) 
		{
			if (0 <= _Glow_blurX)   this._Glow_blurX   = _Glow_blurX;
			if (0 <= _Glow_blurY)   this._Glow_blurY   = _Glow_blurY;
			if (0 <= _Glow_color)   this._Glow_color   = _Glow_color;
			if (0 <= _Glow_alpha)   this._Glow_alpha   = _Glow_alpha;
			if (0 <= _Glow_quality) this._Glow_quality = _Glow_quality;
		}
	}
}