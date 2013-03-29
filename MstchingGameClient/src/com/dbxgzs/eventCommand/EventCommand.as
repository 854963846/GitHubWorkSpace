package com.dbxgzs.eventCommand
{
	import com.dbxgzs.scene.GameScene;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.setTimeout;

	public class EventCommand
	{
		private static const CHANGE_SIZE:int = 0; // 特效中改变的大小，位置
		private var gameScene:GameScene;
		public var targetObjs:Array = new Array();//装载用户选定的游戏对象
		public var coverObjs:Array = new Array();//装载用户选定的游戏对象
		private var curCover:MovieClip;
		private var curObj:MovieClip;
		private var errTips:TextField;
		
		
		public function EventCommand(_gameScene:GameScene)
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
			if( 0 == _gameScene.getTargetGameObjs.length )   //是否游戏中
			{
				for each (var obj:MovieClip in displayList)
				{
					obj.addEventListener( MouseEvent.MOUSE_OVER, mouseOver );
				}
			}
			else
			{
				for each (var obj:MovieClip in displayList)
				{
					obj.addEventListener( MouseEvent.CLICK, clickPic );
				}
			}
		}
		
		/**
		 * 鼠标点击一张图片，给图片增加特效
		 */
		public function mouseClick(e:MouseEvent):void 
		{
			var id:int = coverObjs.indexOf( e.currentTarget );
			if( -1 == id )
			{
				var len:int = coverObjs.length;
				coverObjs[len] = curCover;
				targetObjs[len] = curObj;
			}
			else
			{
				curCover = coverObjs[id];
				curObj = targetObjs[id];
			}  
			
			//同步对方的界面
			gameScene.getClientSocket().changeCover(e.currentTarget.x, e.currentTarget.y);
			
			if( curCover.hasEventListener( MouseEvent.MOUSE_OUT ) ){
				curCover.removeEventListener( MouseEvent.MOUSE_OUT, mouseOut );
				var flag:Boolean = gameScene.setTargetGameObjs( curObj );   //游戏界面无法添加
				if( flag )
				{
					var displayList:Vector.<DisplayObject> = gameScene.getDisplayList;
					var dislen:int = displayList.length;
					
					//清空游戏对象的监听事件
					for (var i:int = 0; i < dislen; i++) 
					{
						var obj:MovieClip = displayList[i];  //动态数组，每次删减后都重组
						if( obj is Box )
						{
							obj.removeEventListener( MouseEvent.CLICK, mouseClick );
						}
						else if(obj.hasEventListener( MouseEvent.MOUSE_OVER ))
						{
							obj.removeEventListener( MouseEvent.MOUSE_OVER, mouseOver );  //移除鼠标点击特效监听
							obj.removeEventListener( MouseEvent.MOUSE_OUT, mouseOut );  //移除鼠标点击特效监听
						}
					}
					targetObjs = null; //清除临时对象数组
					coverObjs = null; //清除临时覆盖层数组
					
					setTimeout( function():void
					{
						gameScene.getClientSocket().readyForGame();
					},100);
				}
			}
			else
			{
				mouseOut(e);
			}
		}
		
		/**
		 * 移除覆盖层
		 * */
		public function removeCover( id:int ):void
		{
			curCover = coverObjs[id];
			curCover.removeEventListener( MouseEvent.CLICK, mouseClick );
			gameScene.removeObject( curCover );
			curCover = null;
		}
		
		/**
		 * 鼠标移出
		 */
		public function mouseOut(e:MouseEvent):void
		{
			var id:int = coverObjs.indexOf( e.currentTarget );		//单击、双击
			if( -1 != id )
			{
				coverObjs.splice( id, 1 );
				targetObjs.splice( id, 1 );
				gameScene.removeTargetGameObjs( e.currentTarget as MovieClip );
			}

			curCover = e.currentTarget as MovieClip;
			curCover.x = curCover.x + CHANGE_SIZE;
			curCover.y = curCover.y + CHANGE_SIZE;
			curCover.width = curCover.width - CHANGE_SIZE;
			curCover.height = curCover.height - CHANGE_SIZE;
			curCover.removeEventListener( MouseEvent.MOUSE_OUT, mouseOut );
			gameScene.removeObject( curCover );
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
			//移除因鼠标过快不能删除的覆盖层
			var id:int = coverObjs.indexOf( curCover );		
			if( null != curCover && -1 == id  )
			{
				gameScene.removeObject( curCover );
			}
			
			curObj = e.currentTarget as MovieClip;
			curObj.x = curObj.x - CHANGE_SIZE;
			curObj.y = curObj.y - CHANGE_SIZE;
			curObj.width = curObj.width + CHANGE_SIZE;
			curObj.height = curObj.height + CHANGE_SIZE;

			curCover = new Box();
			
			curCover.x = curObj.x;
			curCover.y = curObj.y;
			curCover.width = curObj.width;
			curCover.height = curObj.height;
			
			gameScene.addObject( curCover );
			curCover.addEventListener( MouseEvent.MOUSE_OUT, mouseOut );
			curCover.addEventListener( MouseEvent.CLICK, mouseClick );
		}
		
		/**
		 * 点击图片特效 
		 */
		public function clickPic(e:MouseEvent):void
		{
			if( null != curCover )
			{
				gameScene.removeObject( curCover );
				gameScene.dataLogic.exchangePic(curObj, e.currentTarget as MovieClip);
				curObj = null;
				curCover = null;
			}
			else
			{
				curObj = e.currentTarget as MovieClip;
				curCover = new Box();
				curCover.x = curObj.x;
				curCover.y = curObj.y;
				curCover.width = curObj.width;
				curCover.height = curObj.height;
				
				gameScene.addObject( curCover );	
			}
		}
		
	}
}