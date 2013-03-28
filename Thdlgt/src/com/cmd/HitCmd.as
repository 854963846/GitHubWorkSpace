package com.cmd
{
	import com.bullet.BulletFood;
	import com.bullet.food.BlueBulletFood;
	import com.bullet.food.RedBulletFood;
	import com.controller.KeyBoardController;
	import com.loader.InfoLoader;
	import com.plane.PlaneCmd;
	import com.plane.PlaneEnemy;
	import com.scene.StageObjects;
	import com.startGame.GameStart;
	import com.utils.Utils;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setTimeout;
	

	public class HitCmd
	{
		private var brokenOne:Bitmap, brokenTwo:Bitmap, brokenThree:Bitmap, brokenFour:Bitmap;
		private var loaderOne:Loader, loaderTwo:Loader, loaderThree:Loader, loaderFour:Loader;
		private var _bulletFoodBmps:Vector.<Bitmap>, bulletFoods:Vector.<BulletFood>, bulletFood:BulletFood;
		
		public function HitCmd()
		{
			loadBulletFoods();
			loadBrokenBmp();	
		}
		
		private function loadBulletFoods():void
		{
			bulletFoodBmps = Global._scene.bulletFoodBmps;
			bulletFoods = Global._stageObjs.bulletFoods;
			
			var len:int = bulletFoods.length;
			for (var i:int = 0; i < len; i++) 
			{
				switch(i)
				{
					case 0:bulletFoods[i] = new RedBulletFood();break;
					case 1:bulletFoods[i] = new BlueBulletFood();break;
					default:break;
				}
			}
		}
		
		/**
		 * 加载爆炸图片
		 */
		private function loadBrokenBmp():void
		{
			loaderOne = InfoLoader.loadInfo( "../pic/brokenOne.png" );
			loaderOne.contentLoaderInfo.addEventListener( Event.COMPLETE, loadOneCmp );
			loaderTwo = InfoLoader.loadInfo( "../pic/brokenTwo.png" );
			loaderTwo.contentLoaderInfo.addEventListener( Event.COMPLETE, loadTwoCmp );
			loaderThree = InfoLoader.loadInfo( "../pic/brokenThree.png" );
			loaderThree.contentLoaderInfo.addEventListener( Event.COMPLETE, loadThreeCmp );
			loaderFour = InfoLoader.loadInfo( "../pic/brokenFour.png" );
			loaderFour.contentLoaderInfo.addEventListener( Event.COMPLETE, loadFourCmp );
		}		
		
		protected function loadFourCmp(event:Event):void
		{
			brokenFour = Bitmap(loaderFour.content);	
		}
		
		protected function loadThreeCmp(event:Event):void
		{
			brokenThree = Bitmap(loaderThree.content);	
		}
		
		protected function loadTwoCmp(event:Event):void
		{
			brokenTwo = Bitmap(loaderTwo.content);	
		}
		
		protected function loadOneCmp(event:Event):void
		{
			brokenOne = Bitmap(loaderOne.content);			
		}		
		
		/**
		 * 子弹射中己机
		 * @param bmp:敌方子弹
		 * @param bm:己方飞机
		 */
		public function killMe(bmp:Bitmap, bm:Bitmap):void
		{
			var stageObj:StageObjects =  Global._stageObjs;
			var planes:Vector.<PlaneCmd> = stageObj.planes;
			var bulletKill:Dictionary = stageObj.enemyBulletKill;
			var kill:int= bulletKill[bmp.name];
			for each (var plane:PlaneCmd in planes)
			{
				if (bm.name == plane.getBitMap.name)
				{
					plane.health-=kill;
					stageObj.removeEnemyBullets(bmp);
					//stageObj.removeEnemyBulletSpeed( bmp.name );
					//stageObj.removeEnemyBulletKill( bmp.name );
					hits(bm);
					if (0 >= plane.health)
					{
						var ctrl:KeyBoardController = plane.ctrl as KeyBoardController;
						ctrl.directionArr = new Vector.<int>(6) ;
						Global._stage.removeEventListener( KeyboardEvent.KEY_DOWN, ctrl.appendKeyCode );
						Global._stage.removeEventListener( KeyboardEvent.KEY_UP, ctrl.removeKeyCode );
						Global._stageObjs.removePlanes(plane);
						kills(bm.width, bm.height, bm.x, bm.y);
					}
				}
			}
		}
		
		/**
		 * 子弹射中敌机
		 * @param bmp:己方子弹
		 * @param bm:敌方飞机
		 */
		public function killEnemy(bmp:Bitmap, bm:Bitmap):void
		{
			var stageObj:StageObjects =  Global._stageObjs;
			var enemyPlanes:Vector.<PlaneEnemy> = stageObj.enemyPlanes;
			var bulletKill:Dictionary = stageObj.bulletKill;
			var kill:int= bulletKill[bmp.name];
			for each (var ep:PlaneEnemy in enemyPlanes)
			{
				if (bm.name == ep.bitMap.name)
				{
					ep.health-=kill;
					stageObj.removeBullets(bmp);
					//stageObj.removeBulletSpeed( bmp.name );
					//stageObj.removeBulletKill( bmp.name );
					hits(bm);
					if (0 >= ep.health)
					{
						Global._stageObjs.removeEnemyPlanes(ep);
						kills(bm.width, bm.height, bm.x, bm.y);
					}
				}
			}
		}
		
		/**
		 * 击中敌机特效
		 */
		private function hits(bm:Bitmap):void
		{
			bm.alpha = 0.8;
			
			setTimeout( function():void{
				bm.alpha = 1;
			},200);
		}
		
		/**
		 * 飞机爆炸特效
		 */
		public function kills(width:Number, height:Number, px:Number, py:Number):void
		{
			var coreX:Number = px + width*0.5, coreY:Number = py + height*0.5;
			var curBrokenOne:Bitmap = Utils.cloneBitMap( brokenOne );
			var curBrokenTwo:Bitmap = Utils.cloneBitMap( brokenTwo );
			var curBrokenThree:Bitmap = Utils.cloneBitMap( brokenThree );
			var curBrokenFour:Bitmap = Utils.cloneBitMap( brokenFour );
			
			curBrokenOne.width=10, curBrokenOne.height=10, curBrokenOne.x = coreX - curBrokenOne.width*0.5, curBrokenOne.y = coreY - curBrokenOne.height*0.5;
			curBrokenTwo.width=35, curBrokenTwo.height=40,curBrokenTwo.x = coreX - curBrokenTwo.width*0.5, curBrokenTwo.y = coreY - curBrokenTwo.height*0.5;
			curBrokenThree.width=48, curBrokenThree.height=50,curBrokenThree.x = coreX - curBrokenThree.width*0.5, curBrokenThree.y = coreY - curBrokenThree.height*0.5;
			curBrokenFour.width=60, curBrokenFour.height=60,curBrokenFour.x = coreX - curBrokenFour.width*0.5, curBrokenFour.y = coreY - curBrokenFour.height*0.5;
			
			Global._scene.addBrokenBmps( curBrokenOne );
			setTimeout( function():void{
				Global._scene.removeBrokenBmps( curBrokenOne );
				Global._scene.addBrokenBmps( curBrokenTwo );
			},100 );
			
			setTimeout( function():void{
				Global._scene.removeBrokenBmps( curBrokenTwo );
				Global._scene.addBrokenBmps( curBrokenThree );
			},200 );
			
			setTimeout( function():void{
				Global._scene.removeBrokenBmps( curBrokenThree );
				Global._scene.addBrokenBmps( curBrokenFour );
			},300 );
			
			setTimeout( function():void{
				Global._scene.removeBrokenBmps( curBrokenFour );
			},300 );
			
			randomToCreateBulletFood(coreX, coreY);
			GameStart.count.changeCount( 1 );
		}
		
		/**
		 * 飞机飞机碰撞
		 * @param bmp:己方飞机
		 * @param bm:敌方飞机
		 */
		public function hitPlane(bmp:Bitmap, bm:Bitmap):void
		{
			var enemyPlanes:Vector.<PlaneEnemy> = Global._stageObjs.enemyPlanes;
			var planes:Vector.<PlaneCmd> = Global._stageObjs.planes;
			for each (var plane:PlaneCmd in planes) 
			{
				if( bmp.name == plane.getBitMap.name )
				{
					for each (var ep:PlaneEnemy in enemyPlanes) 
					{
						if( bm.name == ep.bitMap.name )
						{
							ep.health -= 50, plane.health -= 50;
							if( 0 >= ep.health )
							{
								Global._stageObjs.removeEnemyPlanes( ep );
								kills(bm.width, bm.height, bm.x, bm.y);
							}
							if( 0 >= plane.health )
							{
								var ctrl:KeyBoardController = plane.ctrl as KeyBoardController;
								ctrl.directionArr = new Vector.<int>(6) ;
								Global._stage.removeEventListener( KeyboardEvent.KEY_DOWN, ctrl.appendKeyCode );
								Global._stage.removeEventListener( KeyboardEvent.KEY_UP, ctrl.removeKeyCode );

								Global._stageObjs.removePlanes( plane );
								kills(bm.width, bm.height, bm.x, bm.y);
							}
						}
					}
				}
			}			
		}
		
		/**
		 * 创建子弹食物
		 */
		private var time:int = 0;
		private function randomToCreateBulletFood(coreX:Number, coreY:Number):void
		{
			bulletFoods = Global._stageObjs.bulletFoods;
			switch(time)
			{
				case 0: bulletFood =  bulletFoods[0]; break;	
				case 1: bulletFood =  bulletFoods[1]; break;	
				default:break;
			}
			
			if( 0 == bulletFoodBmps.length )
			{ 
				var bmp:Bitmap = Utils.cloneBitMap(bulletFood.bitMap);
				bmp.name = bulletFood.bitMap.name;
				
				time++;
				bmp.x = coreX - bmp.width*0.5, bmp.y = coreY - bmp.height*0.5;
				Global._scene.addBulletFoodBmps( bmp );
			}
		}	
		
		/**
		 * 吃子弹
		 */
		public function eatBulletFood(bmp:Bitmap, bm:Bitmap):void
		{
			var stageObj:StageObjects =  Global._stageObjs;
			var planes:Vector.<PlaneCmd> = stageObj.planes;
			for each (var plane:PlaneCmd in planes)
			{
				if (bmp.name == plane.getBitMap.name)
				{
					for each (var bf:BulletFood in bulletFoods) 
					{
						if (bm.name == bf.bitMap.name)
						{
							var bulletArr:Array.<String> = getQualifiedClassName(plane.bullet).split("::");
							var type:String = bulletArr[1].substring(0, 3);
							var bulletFoodArr:Array.<String> = getQualifiedClassName(bf).split("::");
							var foodType:String = bulletFoodArr[1].substring(0, 3);
							if(type==foodType)
							{
								if( plane.bulletType < 3 )
								{
									plane.bulletType += 1;
								}
							}
							else
							{
								//转化飞机类型
								plane.changePlaneStyle(foodType);
								plane.bulletType = plane.bulletType;
							}
							Global._scene.removeBulletFoodBmps( bm );
						}
					}
				}
			}
		}

		public function get bulletFoodBmps():Vector.<Bitmap>
		{
			return _bulletFoodBmps;
		}

		public function set bulletFoodBmps(value:Vector.<Bitmap>):void
		{
			_bulletFoodBmps = value;
		}

	}
}