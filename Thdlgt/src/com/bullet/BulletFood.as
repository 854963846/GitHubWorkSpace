package com.bullet
{
	import com.loader.InfoLoader;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;

	public class BulletFood
	{
		private var loader:Loader;
		private var _bitMap:Bitmap;
		private var _width:int = 15, _height:int = 15;
		
		public function BulletFood()
		{
		}
		
		/**
		 * 加载飞机图片
		 */
		protected function loadPlane( url:String ):void
		{
			//infoLoader = new InfoLoader();		
			//加载飞机
			loader = InfoLoader.loadInfo( url );
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, loadCmp );
		}	
		
		protected function loadCmp(e:Event):void
		{
			bitMap = Bitmap(loader.content); 
			bitMap.width = _width, bitMap.height = _height;
		}	
		
		
		public function loadMyTypeFood():void
		{
		}

		public function get bitMap():Bitmap
		{
			return _bitMap;
		}

		public function set bitMap(value:Bitmap):void
		{
			_bitMap = value;
		}


	}
}