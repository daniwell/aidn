package com.papiness.api.tumblr.model 
{
	
	
	public class TumblrPhotoData 
	{
		/*
			id="1480558023" url="http://daniwell.tumblr.com/post/1480558023"
			url-with-slug="http://daniwell.tumblr.com/post/1480558023/amelie-the-little-rescued-kitten-love-meow-for"
			type="photo"
			date-gmt="2010-11-04 17:35:49 GMT"
			date="Fri, 05 Nov 2010 02:35:49"
			unix-timestamp="1288892149"
			format="html"
			reblog-key="vLfrzvmT"
			slug="amelie-the-little-rescued-kitten-love-meow-for"
			bookmarklet="true"
			width="639"
			height="473">
		*/
		
		
		public var id        :String;
		public var width     :int;
		public var height    :int;
		public var date      :Date;
		public var timeStamp :Number;
		
		public var url       :String;
		public var slug      :String;
		public var format    :String;
		
		
		public var caption   :String;
		public var linkUrl   :String;
		
		public var photoUrl6 :String;
		public var photoUrl5 :String;
		public var photoUrl4 :String;
		public var photoUrl3 :String;
		public var photoUrl2 :String;
		public var photoUrl1 :String;
		
		public function TumblrPhotoData ( xml :XML ) 
		{
			caption = xml["photo-caption"][0];
			linkUrl = xml["photo-link-url"][0];
			
			for each (var tmp :XML in xml["photo-url"])
			{
				var s :String = String(tmp.attribute("max-width"));
				
				switch ( s )
				{
				case "1280":	photoUrl6 = tmp;	break;
				case  "500":	photoUrl5 = tmp;	break;
				case  "400":	photoUrl4 = tmp;	break;
				case  "250":	photoUrl3 = tmp;	break;
				case  "100":	photoUrl2 = tmp;	break;
				case   "75":	photoUrl1 = tmp;	break;
				}
			}
			
			id        = xml.attribute("id");
			width     = int(xml.attribute("width"));
			height    = int(xml.attribute("height"));
			timeStamp = Number(xml.attribute("unix-timestamp"));
			
			date      = new Date();
			var gmt :String = xml.attribute("date-gmt");
			var arr :/*String*/Array = gmt.split(" ");
			date.fullYear = int(arr[0].substr(0, 4));
			date.month    = int(arr[0].substr(5, 2)) - 1;
			date.date     = int(arr[0].substr(8, 2));
			date.hours    = int(arr[1].substr(0, 2)) + 9;
			date.minutes  = int(arr[1].substr(3, 2));
			date.seconds  = int(arr[1].substr(6, 2));
			
			url    = xml.attribute("url");
			slug   = xml.attribute("slug");
			format = xml.attribute("format");
		}
		
		/* trace */
		public function toString():String 
		{
			var s :String = "------------------------\n";
			
			s += "[id ] "       + id              + "\n";
			s += "[width] "     + width           + "\n";
			s += "[height] "    + height          + "\n";
			s += "[date] "      + date.toString() + "\n";
			s += "[timeStamp] " + timeStamp       + "\n";
			s += "[url] "       + url             + "\n";
			s += "[slug] "      + slug            + "\n";
			s += "[format] "    + format          + "\n\n";
			
			s += "[caption] "   + caption         + "\n";
			s += "[linkUrl] "   + linkUrl         + "\n";
			s += "[photoUrl1] " + photoUrl1       + "\n";
			s += "[photoUrl2] " + photoUrl2       + "\n";
			s += "[photoUrl3] " + photoUrl3       + "\n";
			s += "[photoUrl4] " + photoUrl4       + "\n";
			s += "[photoUrl5] " + photoUrl5       + "\n";
			s += "[photoUrl6] " + photoUrl6       + "\n";
			
			return s;
		}
		
		
	}
}