package com.plane.enemy
{
	import com.bullet.BulletFactory;
	import com.greensock.TweenLite;
	import com.loader.InfoLoader;
	import com.plane.PlaneEnemy;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	
	public class ThirdTypeEnemy extends PlaneEnemy
	{
		//private var infoLoader:InfoLoader;
		private var loader:Loader;
		
		protected var _width:int = 50;
		protected var _height:int = 50;
		
		public function ThirdTypeEnemy()
		{
			this.speed = 3, this.health = 3000;
			loadMyTypePlane();
		}
		
		private function loadMyTypePlane():void
		{
			loadPlane( "../pic/EnemyPlaneThree.png" );
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
			
			//根据飞机生成相应的子弹
			_bullet = BulletFactory.getDefineBullet(this, url, 0 ); 
		}	
		
		protected function loadCmp(e:Event):void
		{
			bitMap = Bitmap(loader.content);
			bitMap.width = _width, bitMap.height = _height;
//			bitMap.x = _px;
//			//Global._scene.addEnemyPlanes( bitMap );
//			Global._stageObjs.addEnemyPlanes( this );
//			TweenLite.to( bitMap, 1, {y:_py} );
		}	
		
	}
}