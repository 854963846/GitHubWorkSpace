package com.ai.type
{
	import com.plane.PlaneEnemy;
	import com.plane.enemy.ThirdTypeEnemy;
	import com.scene.StageObjects;
	
	import flash.display.Bitmap;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	
	
	public class AIThirdType
	{
		private var thirdTypePlaneArr:Array = new Array(200);
		private var distTimer:Timer;
		private var goTimer:Timer;
		
		public function AIThirdType()
		{
			loadPlane();
		}
		
		private function loadPlane():void
		{
			for (var i:int = 0; i < thirdTypePlaneArr.length; i++) 
			{
				thirdTypePlaneArr[i] = new ThirdTypeEnemy();
			}
		}		
		
		public function ai():void
		{
			var stageObjs:StageObjects = Global._stageObjs;
			var enemyPlanes:Vector.<PlaneEnemy> = stageObjs.enemyPlanes;
			var flag:Boolean = false;
			for (var i:int = 0; i < thirdTypePlaneArr.length; i++) 
			{
				if( enemyPlanes.indexOf( thirdTypePlaneArr[i] ) == -1 )
				{
					thirdTypePlaneArr[i].health = 3000;
					
					if( thirdTypePlaneArr.length-1==i )
					{
						flag = true;
						if( null != distTimer  )
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
				for (var i:int = 1; i <= thirdTypePlaneArr.length; i++) 
				{
					var cur:PlaneEnemy = thirdTypePlaneArr[i-1];
					var	width:Number = cur.bitMap.width, height:Number = cur.bitMap.height;
					var lineNum:int = Math.floor(390/width);
					cur.bitMap.x=width * (i % lineNum);
					cur.bitMap.y=-height * Math.floor(i / lineNum);
					stageObjs.addEnemyPlanes( cur );
				}
				distTimer.addEventListener( TimerEvent.TIMER, planeMove );
				distTimer.start();
				
				var timer:Timer = new Timer(5000, 0);
				timer.addEventListener(TimerEvent.TIMER, shoot);
				timer.start();
			}
		}
		
		protected function planeMove(event:TimerEvent):void
		{
			var t:Timer = event.currentTarget as Timer;
			for (var i:int = 1; i <= thirdTypePlaneArr.length; i++) 
			{
				var cur:PlaneEnemy = thirdTypePlaneArr[i-1];
				cur.bitMap.y = cur.bitMap.y + 0.1;//0.5
				
				if( (cur.bitMap.y > Global._stage.stageHeight+ cur.bitMap.height) &&  Global._stageObjs.enemyPlanes.indexOf(cur)!=-1  )
				{
					Global._stageObjs.removeEnemyPlanes(cur);
				}
			}
		}

		public function shoot(e:TimerEvent):void
		{
			for (var i:int = 1; i <= thirdTypePlaneArr.length; i++) 
			{
				var cur:PlaneEnemy = thirdTypePlaneArr[i-1];
				var bm:Bitmap= cur.bullet.bitMap;
				if( !Global._stage.contains( bm ) )
				{
					if(Global._stageObjs.enemyPlanes.indexOf(cur)!=-1&& !Global._stageObjs.bulletSpeed.hasOwnProperty(bm.name))
					{
						bm.width=7, bm.height=7;
						bm.x=cur.bitMap.x+cur.bitMap.width*0.5-bm.width*0.5, bm.y=cur.bitMap.y + cur.bitMap.height;
						Global._stageObjs.addEnemyBullets(bm);
					}
				}
				
			}
		}
	}
}