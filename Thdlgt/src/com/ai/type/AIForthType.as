package com.ai.type
{
	import com.plane.PlaneEnemy;
	import com.plane.enemy.ForthTypeEnemy;
	import com.plane.enemy.ThirdTypeEnemy;
	import com.scene.StageObjects;
	import com.utils.Utils;
	
	import flash.display.Bitmap;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	
	
	public class AIForthType
	{
		private var planeArr:Array = new Array(8);
		private var distTimer:Timer;
		private var angle:Number = 45;
		
		public function AIForthType()
		{
			loadPlane();
		}
		
		private function loadPlane():void
		{
			for (var i:int = 0; i < planeArr.length; i++) 
			{
				planeArr[i] = new ForthTypeEnemy();
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
					planeArr[i].health = 1000;
					
					if( planeArr.length-1==i )
					{
						flag = true;
						if( null != distTimer )
						{
							distTimer.stop();
						}
						distTimer = new Timer(100, 0) ;
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
					cur.bitMap.y = 150;
					if( i%2 == 0 )
					{
						cur.bitMap.x = -width*i;
					}
					else
					{
						cur.bitMap.x = Global._stage.stageWidth+width*i;
					}
					stageObjs.addEnemyPlanes( cur );
				}
				distTimer.addEventListener( TimerEvent.TIMER, planeMove );
				distTimer.start();
				
				var timer:Timer = new Timer(5000, 2);
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
				if( i%2 == 0 )
				{
					cur.bitMap.x = cur.bitMap.x + 5;
					cur.bitMap.y = cur.bitMap.y + Math.sin(angle)*10 ;
					if( (cur.bitMap.x > Global._stage.stageWidth+ cur.bitMap.width) &&  Global._stageObjs.enemyPlanes.indexOf(cur)!=-1  )
					{
						Global._stageObjs.removeEnemyPlanes(cur);
					}
				}
				else
				{
					cur.bitMap.x = cur.bitMap.x - 5;
					cur.bitMap.y = cur.bitMap.y + Math.sin(angle)*20 ;
					if( (cur.bitMap.x < -cur.bitMap.width) &&  Global._stageObjs.enemyPlanes.indexOf(cur)!=-1  )
					{
						Global._stageObjs.removeEnemyPlanes(cur);
					}
				}
				angle += 0.1;
			}
		}

		public function shoot(e:TimerEvent):void
		{
			var timer:Timer = e.currentTarget as Timer;
			for (var i:int = 1; i <= planeArr.length; i++) 
			{
				var cur:PlaneEnemy = planeArr[i-1];
//				var bm:Bitmap= Utils.cloneBitMap(cur.bullet.bitMap);
//				bm.name = cur.bullet.bitMap.name;
				var bm:Bitmap = cur.bullet.bitMap;
				
				if(Global._stageObjs.enemyPlanes.indexOf(cur)!=-1 && !Global._stageObjs.bulletSpeed.hasOwnProperty(bm.name))
				{
					bm.width=5, bm.height=5;
					bm.x=cur.bitMap.x+cur.bitMap.width*0.5-bm.width*0.5, bm.y=cur.bitMap.y + cur.bitMap.height;
					Global._stageObjs.addEnemyBullets(bm);
				}
			}
		}
	}
}