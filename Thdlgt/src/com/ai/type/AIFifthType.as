package com.ai.type
{
	import com.plane.PlaneEnemy;
	import com.plane.enemy.FiveTypeEnemy;
	import com.scene.StageObjects;
	import com.utils.Utils;
	
	import flash.display.Bitmap;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	
	
	public class AIFifthType
	{
		private var planeArr:Array = new Array(1);
		private var distTimer:Timer, timer:Timer;
		
		public function AIFifthType()
		{
			loadPlane();
		}
		
		private function loadPlane():void
		{
			for (var i:int = 0; i < planeArr.length; i++) 
			{
				planeArr[i] = new FiveTypeEnemy();
			}
		}		
		
		public function ai():void
		{
			var stageObjs:StageObjects = Global._stageObjs;
			var enemyPlanes:Vector.<PlaneEnemy> = stageObjs.enemyPlanes;
			var flag:Boolean = false;
			for (var i:int = 0; i < planeArr.length; i++) 
			{
				if( enemyPlanes.indexOf( planeArr[i] ) == -1 )
				{
					planeArr[i].health = 50000;
					
					if( planeArr.length-1==i )
					{
						flag = true;
						if( null != distTimer )
						{
							distTimer.stop();
							timer.stop();
						}
						distTimer = new Timer(10, 270) ;
						timer = new Timer(3000, 0);
					}
				}
				else
				{
					break;
				}
			}
			
			if(flag){
				for (var i:int = 1; i <= planeArr.length; i++) 
				{
					var cur:PlaneEnemy = planeArr[i-1];
					var px:Number = cur.bitMap.x, py:Number = cur.bitMap.y,
						width:Number = cur.bitMap.width;
					cur.bitMap.y = -width, cur.bitMap.x = 85;
					cur.bitMap.smoothing = true;
					stageObjs.addEnemyPlanes( cur );
				}
				distTimer.addEventListener( TimerEvent.TIMER, planeMove );
				distTimer.start();
				
				timer.addEventListener(TimerEvent.TIMER, shoot);
				timer.start();
			}
		}

		protected function planeMove(event:TimerEvent):void
		{
			var t:Timer = event.currentTarget as Timer;
			for (var i:int = 1; i <= planeArr.length; i++) 
			{
				var cur:PlaneEnemy = planeArr[i-1];
				cur.bitMap.y = cur.bitMap.y + 1;
			}
		}

		public function shoot(e:TimerEvent):void
		{
			for (var i:int = 1; i <= planeArr.length; i++) 
			{
				var cur:PlaneEnemy = planeArr[i-1];
				for (var j:int = 0; j < 5; j++) 
				{
					var bm:Bitmap=Utils.cloneBitMap(cur.bullet.bitMap);
					bm.name=cur.bullet.bitMap.name;
					//if(Global._stageObjs.enemyPlanes.indexOf(cur)!=-1) //&& !Global._stageObjs.bulletSpeed.hasOwnProperty(bm.name)
					//{
					bm.width=10, bm.height=10;
					bm.x=cur.bitMap.x + cur.bitMap.width * 0.5 - bm.width * 0.5 - 20 * (j - 2), bm.y=cur.bitMap.y + cur.bitMap.height * 0.5;

					Global._stageObjs.addEnemyBullets(bm);
					//}
				}
			}
		}
	}
}