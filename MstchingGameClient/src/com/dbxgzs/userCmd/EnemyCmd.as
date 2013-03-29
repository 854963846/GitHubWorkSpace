package com.dbxgzs.userCmd
{
	import com.dbxgzs.scene.GameScene;
	
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	
	public class EnemyCmd extends UserCmd
	{
		public function EnemyCmd(_gameScene:GameScene)
		{
			super(_gameScene);
		}
		
		/**
		 * 删除图片
		 */
		public function delPic(event:TimerEvent):void
		{
			delGameObj();
		}
		
		/**
		 * 删除对象
		 */
		public function delGameObj():void
		{
			var delLent:int = delPointArr.length, l:int, v:int;
			for (var i:int = 0; i < delLent; i++) 
			{
				l = delPointArr[i][0];
				v = delPointArr[i][1];
				totalGameArr[l][v] = 0;
			}
			
			gameScene.count.changeEnemyCount(delPicArr.length);
			for each (var obj:MovieClip in delPicArr)
			{
				gameScene.removeObject(obj);
				super.delSpeEff(obj.x, obj.y);
			}
			delPicArr = new Array(), delPointArr = new Array();	 //清空装载器	
		}
	}
}