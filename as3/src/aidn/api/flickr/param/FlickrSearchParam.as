package aidn.api.flickr.param 
{
	
	public dynamic class FlickrSearchParam extends Object
	{
		
		public function FlickrSearchParam ( apiKey :String, text :String = null, tags :String = null, perPage :int = 100, page :int = 1, sort :String = "relevance", isJson :Boolean = true ) 
		{
			this.api_key = apiKey;
			
			if (text != null) this.text = encodeURIComponent(text);
			if (tags != null) this.tags = encodeURIComponent(tags);
			
			this.per_page = perPage;
			this.page     = page;
			this.sort     = sort;
			
			if (isJson)
			{
				this.format = "json";
				this.nojsoncallback = 1;
			}
			else
			{
				this.format = "rest";
			}
		}
	}
}