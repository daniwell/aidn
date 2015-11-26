package aidn.api.flickr.model 
{
	
	public class FlickrSearchData 
	{
		public var id     :String;
		public var owner  :String;
		public var secret :String;
		public var server :String;
		
		public var farm :int;
		
		public var title :String;
		
		public var ispublic :int;
		public var isfriend :int;
		public var isfamily :int;
		
		/// 写真のURL
		public var photoUrl :String;
		
		public var profileUrl     :String;
		public var photoStreamUrl :String;
		public var photoPageUrl   :String;
		
		private var _basePhotoUrl :String;
		
		public function FlickrSearchData ( photo :Object ) 
		{
			id       = photo.id;
			owner    = photo.owner;
			secret   = photo.secret;
			server   = photo.server;
			farm     = int(photo.farm);
			title    = photo.title;
			ispublic = int(photo.ispublic);
			isfriend = int(photo.isfriend);
			isfamily = int(photo.isfamily);
			
			profileUrl     = "http://www.flickr.com/people/" + owner + "/";
			photoStreamUrl = "http://www.flickr.com/photos/" + owner + "/";
			photoPageUrl   = photoStreamUrl + id;
			
			_basePhotoUrl = "http://farm" + farm + ".staticflickr.com/" + server + "/" + id + "_" + secret;
			photoUrl = _basePhotoUrl + ".jpg";
		}
		
		/**
		 * 
		 * @param	optionStr		m , n, -, z, c etc...
		 */
		public function getPhotoURL ( optionStr :String = "" ) :String
		{
			if (0 < optionStr.length) return _basePhotoUrl + "_" + optionStr + ".jpg";
			return photoUrl;
		}
	}
}