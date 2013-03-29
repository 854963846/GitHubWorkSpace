package com.startGame
{
	import com.ai.AI;
	import com.controller.BasicController;
	import com.controller.KeyBoardController;
	import com.count.Count;
	import com.greensock.TweenLite;
	import com.grid.DistGrid;
	import com.plane.PlaneCmd;
	import com.plane.cmd.PlaneRed;
	import com.scene.StageObjects;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	public class GameStart
	{
		
		private var stageObjs:StageObjects;
		private var enemyBulletsObjs:Vector.<Bitmap>, enemyBulletSpeed:Dictionary;
		private var bulletsObjs:Vector.<Bitmap>, bulletSpeed:Dictionary;
		private var bulletFoods:Vector.<Bitmap>;
		private var directionX:Number = 1, directionY:Number = 1;
		public static var count:Count;
		private var ctrl:BasicController;
		private var plane:PlaneCmd;
		
		public function GameStart()
		{
			var enemyPlaneAI:AI = new AI();
			count = new Count();
			
			loadCommonInfo();
			
			var timer:Timer = new Timer(1000, 1);
			timer.addEventListener( TimerEvent.TIMER, addPlane );
			timer.start();
			
			//性能分析
//			var s:Stats = new Stats();
//			Global._stage.addChild(s);
			
			//添加敌机
			var testTimer:Timer = new Timer(3000, 1);
			testTimer.addEventListener( TimerEvent.TIMER, enemyPlaneAI.startAI );
			testTimer.start();
			
			//格子算法，碰撞检测
			var distGrid:DistGrid = new DistGrid();
			Global._stage.addEventListener( Event.ENTER_FRAME, distGrid.chkHits );
		}
		
		private function loadCommonInfo():void
		{
			stageObjs = Global._stageObjs;
			enemyBulletsObjs = stageObjs.enemyBullets;
			enemyBulletSpeed = stageObjs.enemyBulletSpeed;
			bulletsObjs = stageObjs.bullets;
			bulletSpeed = stageObjs.bulletSpeed;
			
			bulletFoods = Global._scene.bulletFoodBmps;
		}		
		
		/**
		 * 创建飞机
		 */
		public function addPlane(event:TimerEvent):void
		{
			loadPlane();
		}
		
		public function loadPlane():void
		{
			if(null==ctrl)
			{
				ctrl = new KeyBoardController();
				plane = new PlaneRed(ctrl);
				setTimeout( function():void
				{
					plane.getBitMap.addEventListener( Event.REMOVED_FROM_STAGE, reAddPlane );
				},1000);
			}
			else
			{
				setTimeout( function():void 
				{
					var ctrl:KeyBoardController = plane.ctrl as KeyBoardController;
					plane.getBitMap.width = 30, plane.getBitMap.height = 30;
					plane.bitMapX = 180,  plane.bitMapY = 470, plane.getBitMap.x = 180, 
					plane.getBitMap.alpha = 0.5, plane.getBitMap.y = 470;
					plane.health = 100, plane.url = "red";
					plane.bulletType=1;
					plane.changePlaneStyle("red");
					Global._stageObjs.addPlanes( plane );
					TweenLite.to( plane.getBitMap, 0.3,{y:370, alpha:1});
					Global._stage.addEventListener( KeyboardEvent.KEY_DOWN, ctrl.appendKeyCode );
					Global._stage.addEventListener( KeyboardEvent.KEY_UP, ctrl.removeKeyCode );
				},2000);
			}
			
			listenBulletsMove(); //侦听舞台上的子弹移动
		}
		
		protected function reAddPlane(event:Event):void
		{
			loadPlane();
		}
		
		/**
		 * 监听舞台对象移动
		 */
		private function listenBulletsMove():void
		{
			Global._stage.addEventListener( Event.ENTER_FRAME, moveBullet );
			Global._stage.addEventListener( Event.ENTER_FRAME, moveEnemyBullet );
			Global._stage.addEventListener( Event.ENTER_FRAME, moveBulletFoods );
		}
		
		protected function moveBulletFoods(e:Event):void
		{
			for each (var bulletFood:Bitmap in bulletFoods) 
			{
				bulletFood.x = bulletFood.x + 1*directionX;
				bulletFood.y = bulletFood.y + 1*directionY;
				if(bulletFood.x <= 0 )
				{
					directionX = -directionX;
				}
				
				if( bulletFood.x >= Global._stage.stageWidth - bulletFood.width )
				{
					directionX = -directionX;
				}
				
				if(bulletFood.y<= 0)
				{
					directionY = -directionY;
				}
				
				if( bulletFood.y >= Global._stage.stageHeight - bulletFood.height )
				{
					directionY = -directionY;
				}
			}				
		}
		
		/**
		 * 敌人子弹移动、消除
		 */
		protected function moveEnemyBullet(event:Event):void
		{
			for each (var bullet:Bitmap in enemyBulletsObjs) 
			{
				bullet.y += enemyBulletSpeed[bullet.name];
				if(bullet.y>=Global._stage.stageHeight)
				{
					Global._stageObjs.removeEnemyBullets( bullet );
					//stageObjs.removeEnemyBulletSpeed( bullet.name );
					//stageObjs.removeEnemyBulletKill( bullet.name )
				}
			}		
		}
		
		/**
		 * 子弹移动、消除
		 */
		protected function moveBullet(event:Event):void
		{
			for each (var bulletBmp:Bitmap in bulletsObjs) 
			{
				bulletBmp.y -= bulletSpeed[bulletBmp.name];
				if(bulletBmp.y<0)
				{
					stageObjs.removeBullets( bulletBmp );
					stageObjs.removeEnemyBulletSpeed( bulletBmp.name );
					stageObjs.removeEnemyBulletKill( bulletBmp.name );
				}
			}
		}
	}
}