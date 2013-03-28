package com.bullet
{
	import com.loader.InfoLoader;
	import com.plane.Plane;
	import com.plane.PlaneCmd;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;

	public class Bullet
	{
		//private var infoLoader:InfoLoader;
		private var loader:Loader;
		private var _bitMap:Bitmap;
		private var bitMapX:Number, bitMapY:Number;
		
		protected var _speed:int;
		protected var _kill:int;
		protected var _width:int;
		protected var _height:int;
		protected var _shooter:Plane;
		

		public function Bullet(plane:Plane)
		{
			_shooter = plane;
		}
		
		/**
		 * 加载飞机图片
		 */
		protected function loadBullet( url:String ):void
		{
			//infoLoader = new InfoLoader();		
			//加载飞机
			loader = InfoLoader.loadInfo( url );
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, loadCmp );
			//loader.name = Global._stageObjs.planes.length+"";
		}	
		
		protected function loadCmp(e:Event):void
		{
			
			bitMap = Bitmap(loader.content);
			bitMap.width = _width, bitMap.height = _height;
		}
		
		/**
		 * 加载子类子弹
		 */
		public function loadMyBullet():void
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

		public function get speed():int
		{
			return _speed;
		}

		public function set speed(value:int):void
		{
			_speed = value;
		}

		public function get shooter():Plane
		{
			return _shooter;
		}

		public function get kill():int
		{
			return _kill;
		}


	}
}