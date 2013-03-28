package com.ai.type
{
	import com.greensock.TweenLite;
	import com.plane.PlaneEnemy;
	import com.plane.enemy.FirstTypeEnemy;
	import com.scene.StageObjects;
	
	import flash.display.Bitmap;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	
	public class AIFirstType
	{
		private var firtTypePlaneArr:Array = new Array(5);
		private var distTimer:Timer;
		
		public function AIFirstType()
		{
			loadPlane();
		}
		
		private function loadPlane():void
		{
			for (var i:int = 0; i < firtTypePlaneArr.length; i++) 
			{
				firtTypePlaneArr[i] = new FirstTypeEnemy();
			}
		}		
		
		public function ai():void
		{
			var stageObjs:StageObjects = Global._stageObjs;
			var enemyPlanes:Vector.<PlaneEnemy> = stageObjs.enemyPlanes;
			var flag:Boolean = false;
			for (var i:int = 1; i <= firtTypePlaneArr.length; i++) 
			{
				if( enemyPlanes.indexOf( firtTypePlaneArr[i-1] ) == -1 )
				{
					var cur:PlaneEnemy = firtTypePlaneArr[i-1];
					cur.bitMap.y = 0;
					if( firtTypePlaneArr.length-1==i )
					{
						flag = true;
						if( null != distTimer )
						{
							distTimer.stop();
						}
						distTimer = new Timer(2000, 1);
					}
				}
				else
				{
					break;
				}
			}
			
			if(flag){
				for (var i:int = 1; i <= firtTypePlaneArr.length; i++) 
				{
					var cur:PlaneEnemy = firtTypePlaneArr[i-1];
					cur.bitMap.x = 200;
					stageObjs.addEnemyPlanes( cur );
					TweenLite.to( cur.bitMap, 2, {y:50*i});
				}
				
				distTimer.addEventListener( TimerEvent.TIMER, planeMove );
				distTimer.start();
			}
		}
		
		protected function planeMove(event:TimerEvent):void
		{
			for (var i:int = 1; i <= firtTypePlaneArr.length; i++) 
			{
				var cur:PlaneEnemy = firtTypePlaneArr[i-1];
				TweenLite.to( cur.bitMap, 2, {x: cur.bitMap.x-100*Math.random()});
			}
			
			var timer:Timer = new Timer(3000, 3);
			timer.addEventListener( TimerEvent.TIMER, shoot );
			timer.addEventListener( TimerEvent.TIMER_COMPLETE, goHome );
			timer.start();
		}
		
		protected function goHome(event:TimerEvent):void
		{
			for (var i:int = 1; i <= firtTypePlaneArr.length; i++) 
			{
				var cur:PlaneEnemy = firtTypePlaneArr[i-1];
				TweenLite.to( cur.bitMap, 2, {x: 200});	
			}
			
			var timer:Timer = new Timer(2000, 1);
			timer.addEventListener( TimerEvent.TIMER, goToHome );
			timer.start();
		}
		
		protected function goToHome(event:TimerEvent):void
		{
			var timer:Timer = event.currentTarget as Timer;
			for each (var bmp:PlaneEnemy in firtTypePlaneArr) 
			{
				TweenLite.to( bmp.bitMap , 1, {y:-bmp.bitMap.height});
			}

			var t:Timer=new Timer(5000, 1);
			t.addEventListener(TimerEvent.TIMER, delPlane);
			t.start();
		}
		
		protected function delPlane(event:TimerEvent):void
		{
			for each (var ep:PlaneEnemy in firtTypePlaneArr) 
			{
				if( ep.bitMap.y <= 0 &&  Global._stageObjs.enemyPlanes.indexOf(ep)!=-1)
				{
					Global._stageObjs.removeEnemyPlanes( ep );					
				}
			}
		}
		
		public function shoot(e:TimerEvent):void
		{
			for (var i:int = 1; i <= firtTypePlaneArr.length; i++) 
			{
				var cur:PlaneEnemy = firtTypePlaneArr[i-1];
				if(Global._stageObjs.enemyPlanes.indexOf(cur)!=-1)
				{
					var bm:Bitmap= cur.bullet.bitMap;
					bm.width=7, bm.height=7;
					bm.x=cur.bitMap.x+cur.bitMap.width*0.5-bm.width*0.5, bm.y=cur.bitMap.y + cur.bitMap.height;
					Global._stageObjs.addEnemyBullets(bm);
				}
			}
		}
	}
}