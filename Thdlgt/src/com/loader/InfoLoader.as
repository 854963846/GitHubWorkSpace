package com.loader
{
	import flash.display.Loader;
	import flash.net.URLRequest;

	public class InfoLoader
	{
		public function InfoLoader()
		{
			
		}
		
		public static function loadInfo( url:String ):Loader
		{
			var loader:Loader = new Loader();
			var request:URLRequest = new URLRequest( url );
			loader.load( request );			
			return loader;
		}
	}
}