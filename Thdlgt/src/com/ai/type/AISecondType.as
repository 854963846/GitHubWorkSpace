package com.ai.type
{
	import com.plane.PlaneEnemy;
	import com.plane.enemy.SecondTypeEnemy;
	import com.scene.StageObjects;
	
	import flash.display.Bitmap;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	
	
	public class AISecondType
	{
		private var secondTypePlaneArr:Array = new Array(30);
		private var distTimer:Timer;
		
		public function AISecondType()
		{
			loadPlane();
		}
		
		private function loadPlane():void
		{
			for (var i:int = 0; i < secondTypePlaneArr.length; i++) 
			{
				secondTypePlaneArr[i] = new SecondTypeEnemy();
			}
		}		
		
		public function ai():void
		{
			var stageObjs:StageObjects = Global._stageObjs;
			var enemyPlanes:Vector.<PlaneEnemy> = stageObjs.enemyPlanes;
			var flag:Boolean = false;
			for (var i:int = 1; i <= secondTypePlaneArr.length; i++) 
			{
				if( enemyPlanes.indexOf( secondTypePlaneArr[i-1] ) == -1 )
				{
					if( secondTypePlaneArr.length-1==i )
					{
						flag = true;
						if( null != distTimer )
						{
							distTimer.stop();
						}
						distTimer = new Timer(10, 0) ;
					}
				}
				else
				{
					break;
				}
			}
			
			if(flag){
				for (var i:int = 1; i <= secondTypePlaneArr.length; i++) 
				{
					var cur:PlaneEnemy = secondTypePlaneArr[i-1];
					var px:Number = cur.bitMap.x, py:Number = cur.bitMap.y,
						width:Number = cur.bitMap.width;
					cur.bitMap.smoothing = true;
					cur.bitMap.y = 100-width*i, cur.bitMap.x = -width*i;
					stageObjs.addEnemyPlanes( cur );
				}
				distTimer.addEventListener( TimerEvent.TIMER, planeMove );
				distTimer.start();
				
				var timer:Timer = new Timer(5000, 0);
				timer.addEventListener(TimerEvent.TIMER, shoot);
				timer.start();
			}
		}
		
		/**
		 * 
		 * @param event
		 */
		/**
		 * 
		 * @param event
		 */
		protected function planeMove(event:TimerEvent):void
		{
			var t:Timer = event.currentTarget as Timer;
			for (var i:int = 1; i <= secondTypePlaneArr.length; i++) 
			{
				var cur:PlaneEnemy = secondTypePlaneArr[i-1];
				cur.bitMap.x = cur.bitMap.x + 1;
				if( cur.bitMap.x < 180 )
				{
					cur.bitMap.y = cur.bitMap.y + 1;
				}
				else
				{
					cur.bitMap.y = cur.bitMap.y - 1;
				}
				
				if( (cur.bitMap.x > Global._stage.stageWidth+ cur.bitMap.width)&&  Global._stageObjs.enemyPlanes.indexOf(cur)!=-1  )
				{
					Global._stageObjs.removeEnemyPlanes(cur);
				}
			}
		}

		public function shoot(e:TimerEvent):void
		{
			
			
			for (var i:int = 1; i <= secondTypePlaneArr.length; i++) 
			{
				var cur:PlaneEnemy = secondTypePlaneArr[i-1];
				var bm:Bitmap= cur.bullet.bitMap;
				
				if(Global._stageObjs.enemyPlanes.indexOf(cur)!=-1 && (cur.bitMap.x >=50) 
					&& (cur.bitMap.x<=340) && !Global._stageObjs.bulletSpeed.hasOwnProperty(bm.name))
				{
					bm.width=7, bm.height=7;
					bm.x=cur.bitMap.x+cur.bitMap.width*0.5-bm.width*0.5, bm.y=cur.bitMap.y + cur.bitMap.height;
					Global._stageObjs.addEnemyBullets(bm);
				}
			}
		}
	}
}