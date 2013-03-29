package com.dbxgzs.specialEfficient
{
	import com.dbxgzs.scene.GameScene;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class SpeEff
	{
		private static const CHANGE_SIZE = 0; // 特效中改变的大小，位置
		private var gameScene:GameScene;
		private var targetObjs:Array = new Array();
		private var coverObjs:Array = new Array();
		private var curCover:MovieClip;
		private var curObj:MovieClip;
		private var errTips:TextField;
		
		
		public function SpeEff(_gameScene:GameScene)
		{
			this.gameScene = _gameScene;
			appendEventToObj(_gameScene);
		}
		
		/**
		 * 监听图片
		 */
		private function appendEventToObj(_gameScene:GameScene):void
		{
			var displayList:Vector.<DisplayObject> = _gameScene.getDisplayList;
			for each (var obj:MovieClip in displayList)
			{
				obj.addEventListener( MouseEvent.MOUSE_OVER, mouseOver );
			}
		}
		
		/**
		 * 鼠标点击一张图片，给图片增加特效
		 */
		public function mouseClick(e:MouseEvent):void 
		{
			var key:String = e.currentTarget.name + "";  
			if( "undefined" == typeof(targetObjs[key]) ){  //判断是单击还是双击  
				targetObjs[key] = curObj;
				coverObjs[key] = curCover;
			}
			else
			{
				curCover = coverObjs[key];
				curObj = targetObjs[key];
			}
			
			if( curCover.hasEventListener( MouseEvent.MOUSE_OUT ) ){
				curCover.removeEventListener( MouseEvent.MOUSE_OUT, mouseOut );
				var flag:Boolean = gameScene.setTargetGameObjs( curObj );
				if( flag )
				{
					//gameScene.startGame();
				}
			}
			else
			{
				mouseOut(e);
			}
			
		}
		
		/**
		 * 鼠标移出
		 */
		public function mouseOut(e:MouseEvent):void
		{
			var key:String = e.currentTarget.name + "";  
			if( "undefined" != typeof(targetObjs[key]) ){  //判断是单击还是双击  
				trace(key);
				coverObjs[key] = null;
				targetObjs[key] = null;
				
				for(var str:String in targetObjs)
				{
					trace(str);
					trace( targetObjs[str].name);
					
				}
			}
			
			curCover = e.currentTarget as MovieClip;
			curCover.x = curCover.x + CHANGE_SIZE;
			curCover.y = curCover.y + CHANGE_SIZE;
			curCover.width = curCover.width - CHANGE_SIZE;
			curCover.height = curCover.height - CHANGE_SIZE;
			curCover.removeEventListener( MouseEvent.MOUSE_OUT, mouseOut );
			Global.stage.removeChild( curCover );
			curCover = null;
			
			curObj.x = curObj.x + CHANGE_SIZE;
			curObj.y = curObj.y + CHANGE_SIZE;
			curObj.width = curObj.width - CHANGE_SIZE;
			curObj.height = curObj.height - CHANGE_SIZE;
		}
		
		
		/**
		 * 鼠标移入
		 */
		public function mouseOver(e:MouseEvent):void
		{
			curObj = e.currentTarget as MovieClip;
			curObj.x = curObj.x - CHANGE_SIZE;
			curObj.y = curObj.y - CHANGE_SIZE;
			curObj.width = curObj.width + CHANGE_SIZE;
			curObj.height = curObj.height + CHANGE_SIZE;
			
			curCover = new Cover();
			curCover.x = curObj.x;
			curCover.y = curObj.y;
			curCover.width = curObj.width;
			curCover.height = curObj.height;
			Global.stage.addChild( curCover );
			curCover.addEventListener( MouseEvent.MOUSE_OUT, mouseOut );
			curCover.addEventListener( MouseEvent.CLICK, mouseClick );
		}
		
	}
}