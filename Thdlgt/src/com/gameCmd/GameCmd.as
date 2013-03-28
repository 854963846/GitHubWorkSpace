package com.gameCmd
{
	import com.bullet.BulletFood;
	import com.plane.PlaneCmd;
	import com.plane.PlaneEnemy;
	import com.scene.StageObjects;
	import com.startGame.GameStart;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	public class GameCmd
	{
		private var oneLoader:Loader, twoLoader:Loader; 
		private var gameStartOver:GameStartOver, gameStartUp:GameStartUp;
		private var gs:GameStart;
		public function GameCmd()
		{
			initVar();
			loadButton();
		}
		
		private function initVar():void
		{
			var stageObjects:StageObjects = Global._stageObjs;
			stageObjects.planes = new Vector.<PlaneCmd>(); //初始化飞机容器
			stageObjects.enemyPlanes = new Vector.<PlaneEnemy>(); //初始化敌机容器
			stageObjects.bullets = new Vector.<Bitmap>();
			stageObjects.enemyBullets = new Vector.<Bitmap>();
			stageObjects.bulletFoods = new Vector.<BulletFood>(2);
			
			stageObjects.enemyBulletSpeed = new Dictionary();
			stageObjects.bulletSpeed = new Dictionary();
			stageObjects.enemyBulletKill = new Dictionary();
			stageObjects.bulletKill = new Dictionary();
		}

		protected function loadButton():void
		{
			gameStartOver = new GameStartOver(), gameStartUp = new GameStartUp();
			var bmp:MovieClip = gameStartOver;
			bmp.x = (Global._stage.stageWidth-bmp.width)*0.5, bmp.y = (Global._stage.stageHeight-bmp.height)*0.5;
			Global._scene.addGameCmdBmps( bmp );
			bmp.addEventListener( MouseEvent.MOUSE_OVER, gameStartMouseOver );
			bmp.addEventListener( MouseEvent.CLICK, gameStartUpClick );
		}
		
		/**
		 * 鼠标一移开
		 */
		protected function gameStartMouseOut(event:MouseEvent):void
		{
			Global._scene.removeGameCmdBmps( event.currentTarget as MovieClip);
			Global._scene.addGameCmdBmps( gameStartOver );
		}
		
		/**
		 * 鼠标进入
		 */
		protected function gameStartMouseOver(event:MouseEvent):void
		{
			Global._scene.removeGameCmdBmps( gameStartOver );
			gameStartUp.x=gameStartOver.x + (gameStartOver.width - gameStartUp.width) * 0.5;
			gameStartUp.y=gameStartOver.y + (gameStartOver.height - gameStartUp.height) * 0.5;
			gameStartUp.addEventListener(MouseEvent.CLICK, gameStartUpClick);
			gameStartUp.addEventListener(MouseEvent.MOUSE_OUT, gameStartMouseOut);
			Global._scene.addGameCmdBmps( gameStartUp );
		}
		
		/**
		 * 鼠标点击
		 */
		protected function gameStartUpClick(event:MouseEvent):void
		{
			Global._scene.removeGameCmdBmps( event.currentTarget as MovieClip );
			gameStartOver.removeEventListener( MouseEvent.MOUSE_OVER, gameStartMouseOver );
			gameStartOver = null;
			gameStartUp.removeEventListener( MouseEvent.CLICK, gameStartUpClick );
			gameStartUp.removeEventListener( MouseEvent.MOUSE_OUT, gameStartMouseOut );
			gameStartUp = null;
			
			if(null==gs)
			{
				gs = new GameStart();
			}
		}
		
	}
}