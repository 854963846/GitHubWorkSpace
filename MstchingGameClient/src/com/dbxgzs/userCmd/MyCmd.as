package com.dbxgzs.userCmd
{
	import com.dbxgzs.scene.GameScene;
	
	import flash.display.MovieClip;
	
	public class MyCmd extends UserCmd
	{
		public function MyCmd(_gameScene:GameScene)
		{
			super(_gameScene);
		}
		
		/**
		 * 消除符合条件的
		 */
		public function delGameObjs(drawPicFlag:Boolean):void
		{
			var delLent:int = delPointArr.length, l:int, v:int;
			for (var i:int = 0; i < delLent; i++) 
			{
				l = delPointArr[i][0];
				v = delPointArr[i][1];
				totalGameArr[l][v] = 0;
			}
			
			if( drawPicFlag )
			{
				gameScene.count.changeCount( delPicArr.length);
				for each (var obj:MovieClip in delPicArr) 
				{
					gameScene.removeObject( obj );
					delSpeEff( obj.x, obj.y );
				}
			}
			
			delPicArr = new Array(), delPointArr = new Array();	 //清空装载器		
		}
	}
}