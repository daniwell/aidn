package aidn.api.flickr.model 
{
	
	public class FlickrSearchList 
	{
		/// ページ番号
		public var page    :int;
		/// ページ総数
		public var pages   :int;
		/// 取得数
		public var perpage :int;
		/// 総数
		public var total   :int;
		
		/// 写真データ
		public var datas :/*FlickrSearchData*/Array;
		/// 写真総数
		public var dataTotal :int;
		
		public function FlickrSearchList ( photos :Object ) 
		{
			if (! photos) return;
			
			page    = int(photos.page);
			pages   = int(photos.pages);
			perpage = int(photos.perpage);
			total   = int(photos.total);
			
			datas = [];
			
			for each (var photo :Object in photos.photo)
			{
				datas.push(new FlickrSearchData(photo));
			}
			dataTotal = datas.length;
		}
	}
}