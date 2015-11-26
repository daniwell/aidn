package com.papiness.api.tumblr.model 
{
	
	/**
	 * 
	 * @author daniwell
	 */
	public class TumblrData 
	{
		public var name     :String;
		public var timezone :String;
		public var title    :String;
		
		public var start :int;
		public var total :int;
		
		
		public function TumblrData ( xml :XML ) 
		{
			name     = xml.tumblelog.attribute("name");
			timezone = xml.tumblelog.attribute("timezone");
			title    = xml.tumblelog.attribute("title");
			start    = int(xml.posts.attribute("start"));
			total    = int(xml.posts.attribute("total"));
		}
		
		/* trace */
		public function toString():String 
		{
			var s :String = "------------------------\n";
			
			s += "[name] "     + name     + "\n";
			s += "[timezone] " + timezone + "\n";
			s += "[title] "    + title    + "\n";
			s += "[start] "    + start    + "\n";
			s += "[total] "    + total    + "\n";
			
			return s;
		}
		
	}
}