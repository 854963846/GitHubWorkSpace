package com.dbxgzs.logic
{
	import com.dbxgzs.eventCommand.EventCommand;
	import com.dbxgzs.object.GameObject;
	import com.dbxgzs.scene.GameScene;
	import com.dbxgzs.userCmd.MyCmd;
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	
	
	public class DataLogic
	{
		private var LINE:int = 8, VERT:int = 9; //每行9个，每列8个
		private var totalGameArr:Array; //总游戏界面， 准备删除的点的坐标， 准备删除的点图片
		private var eventCnd:EventCommand;
		private var gameScene:GameScene;
		private var curObj:Object;
		private var couldDel:Boolean = true;
		private var drawPicFlag:Boolean = false;
		public var checkFlag:Boolean = true;
		private var gameObj:GameObject;
		private var targetGameObjs:Vector.<MovieClip>;
		private var gameObjSize:int;
		private var obj:MovieClip;
		private var fillGameObjectsArr:Array;
		private var myCmd:MyCmd;
		
		public function DataLogic( _gameScene:GameScene )
		{
			gameScene = _gameScene;
			totalGameArr = new Array();
			gameObj = new GameObject();
			myCmd = new MyCmd(gameScene);
		}
		
		/**
		 * 初始化待选择游戏对象
		 * */
		public function initStage():void
		{	
			var objNames:Vector.<String> = this.gameObj.displayObjectNames();
			trace( objNames );
			var len:int = objNames.length;
			var flag:Boolean = true;
			// 第一行距离顶部的距离， 每行有多少张图片， 列图片间距， 行图片间距
			var top:int = 60, lineSize:int = 7, lineSlide:int = 8, vertSlide:int = 5;  
			for (var i:int = 1; i <= 6; i++)  //共6行
			{
				if( flag )
				{
					var j:int = 0;
					for (; j < lineSize; j++)  //每行6个
					{
						var num:int = (i-1)*lineSize+j;
						if( num > len - 1 )  //超出存在图片个数
						{
							flag = false;
							break;
						}
						var name:String = objNames[num].toLowerCase();
						obj = gameObj.getDisplayObject(name);
						gameScene.appendPreGameObj( obj, 50+j*50+(j+1)*lineSlide, 60*i-10*(i-1) +vertSlide*(i-1) );
					}
				}
				else
				{
					break ;	
				}
			}
			gameScene.getClientSocket().appendPreGameObjs(objNames);
		}
		
		/**
		 * 开始游戏
		 * */
		public function startGame():void
		{	
			targetGameObjs = gameScene.getTargetGameObjs;
			gameObjSize = targetGameObjs.length;
			var obj:MovieClip = null;
			for (var l:int = 0; l < LINE; l++) 
			{
				var lineGameArr:Array = new Array();
				for (var v:int = 0; v < VERT ; v++) 
				{
					var objName:String = getQualifiedClassName( targetGameObjs[ randomSize(gameObjSize) ] );
					obj = gameObj.getDisplayObject( objName.toLowerCase() );
					lineGameArr[v] = obj;
				}
				totalGameArr[l] = lineGameArr;
			}
			//己方的游戏数组
			myCmd.totalGameArrVal = totalGameArr;
			
			while(couldDel)  //清除在初始化时候可以被消除的图片
			{
				initCheckGame(false);
			}
			var totalArr:Array = new Array();
			for (var l:int = 0; l < LINE; l++) //初始化界面
			{
				var lineArr:Array = new Array();
				for (var v:int = 0; v < VERT; v++) 
				{
					obj = totalGameArr[l][v];
					gameScene.appendGameObj( obj, l, v);
					
					lineArr[lineArr.length] = getQualifiedClassName( obj );
				}
				totalArr[totalArr.length] = lineArr;
			}
			
			//发送己方的初始图片展示到服务器
			gameScene.getClientSocket().initEnemyGame(totalArr);
			
			eventCnd = new EventCommand(gameScene);
		}
		
		/**
		 * 返回游戏对象个数的下标  <=游戏对象个数
		 * */
		private function randomSize( gameObjSize:int ):int
		{
			var num:int = 0;
			while( true )
			{
				num = Math.ceil(gameObjSize*Math.random());
				if( num > 0 && num <= gameObjSize )
				{
					break;
				}
			}
			return num - 1;
		}
		
		/**
		 * 初始化之后查看是否存在有可消除的对象
		 * */
		public function initCheckGame(_drawPicFlag:Boolean):void
		{
			drawPicFlag = _drawPicFlag;
			for (var l:int = 0; l < LINE; l++) 
			{
				for (var v:int = 0; v < VERT; v++) 
				{
					myCmd.aheadOneTwoCur( l, v );
				}
			}
			
			if( 0 != myCmd.delPointArrVal.length )
			{
				myCmd.delGameObjs(_drawPicFlag);  //消除符合条件的图片
				fillGameObj();
			}
			else
			{
				couldDel = false;
			}
		}

		
		/**
		 * 补充图片
		 * */
		public function fillGameObj():void
		{
			fillGameObjectsArr = new Array();
			
			if( checkFlag )  //如果时间到了，则不再生成新的图片
			{
				for (var v:int = 0; v < VERT; v++) 
				{
					fillVertObj(v, drawPicFlag);		
				}
			}
			
			if( drawPicFlag ) //同步填充新生成点
			{
				gameScene.getClientSocket().fillGame(fillGameObjectsArr);
			}
		}
		
		/**
		 * 补充每列的图片
		 */
		private function fillVertObj(v:int, drawPicFlag:Boolean):void
		{
			var totalGameArr:Array = myCmd.totalGameArrVal;
			var emptySize:int = 0;
			for (var l:int=LINE - 1; l >= 0; l--)
			{
				curObj= totalGameArr[l][v];
				if (0 == curObj)
				{
					emptySize++;
				}
				else if (0 != emptySize && 0 != curObj)  //对于下方有空，本格有之而言
				{
					totalGameArr[l+emptySize][v] = curObj;
					totalGameArr[l][v] = 0;
					gameScene.moveGameObj( curObj as MovieClip, l+emptySize, v );
				}
			}
			
			for (var i:int = emptySize-1; i >= 0; i--) 
			{
				var objName:String = getQualifiedClassName( targetGameObjs[ randomSize(gameObjSize) ] );
				obj = gameObj.getDisplayObject( objName.toLowerCase() );
				totalGameArr[i][v] = obj;
				if (drawPicFlag) 
				{
					gameScene.fillGameObj( obj, i, v );
					obj.addEventListener( MouseEvent.CLICK, eventCnd.clickPic );
					
					//存储新生成图片的信息
					var targetArr:Array = new Array();
					targetArr[0] = objName;  
					targetArr[1] = v;
					targetArr[2] = i;
					fillGameObjectsArr[fillGameObjectsArr.length] = targetArr;
				}
			}
		}		
		
		/**
		 * 交换两张图片的位置
		 */
		public function exchangePic(firstTarget:MovieClip, secondTarget:MovieClip):void
		{
			var fx:Number = firstTarget.x, fy:Number = firstTarget.y, 
				width:int = firstTarget.width, height:int = firstTarget.height,
				sx:Number = secondTarget.x, sy:Number = secondTarget.y;
			var fl:int = (fy-50)/height, fv:int = (fx-50)/width, sl:int = (sy-50)/height, sv:int = (sx-50)/width;
			
			var sum:int = Math.abs(sl-fl) + Math.abs(sv-fv);
			if( 1 != sum )  //判断两点是否可移动
			{
				return;
			}
			
			//同步用户的交换图片操作
			var pointsArr:Array = new Array(fl, fv, sl, sv);
			gameScene.getClientSocket().synUserCmd(pointsArr);
			
			TweenLite.to( firstTarget, 0.3, {x:sx, y:sy} );  //移动图片
			TweenLite.to( secondTarget, 0.3, {x:fx, y:fy} ); //移动图片
			
			var totalGameArr:Array = myCmd.totalGameArrVal;
			totalGameArr[fl][fv] = secondTarget;		//交换数组位置
			totalGameArr[sl][sv] = firstTarget;			//交换数组位置
			
			myCmd.aheadOneTwoCur( fl, fv );					//交换数组位置
			myCmd.aheadOneTwoCur( sl, sv );
			
			if( 0 == myCmd.delPicArrVal.length )
			{
				
				totalGameArr[fl][fv] = firstTarget;
				totalGameArr[sl][sv] = secondTarget;
				setTimeout( function():void
				{
					TweenLite.to( firstTarget, 0.3, {x:fx, y:fy} );
					TweenLite.to( secondTarget, 0.3, {x:sx, y:sy} );
				},500);
			}
			else
			{
				var delTimer:Timer = new Timer(500,1);
				delTimer.addEventListener( TimerEvent.TIMER, delPic );
				delTimer.start();
			}
		}
		
		/**
		 * 删除图片
		 */
		protected function delPic(event:TimerEvent):void
		{
			drawPicFlag = true;
			myCmd.delGameObjs(true);
			var fillTimer:Timer = new Timer(500,1);
			fillTimer.addEventListener(TimerEvent.TIMER, fillPicView);
			fillTimer.start();
		}
		
		protected function fillPicView(event:TimerEvent):void
		{
			fillGameObj();  //把每列图片补充完整
			var initTimer:Timer = new Timer(1000,1);
			initTimer.addEventListener(TimerEvent.TIMER, checkTotal);
			initTimer.start();
		}
		
		protected function checkTotal(event:TimerEvent):void
		{
			for (var l:int = 0; l < LINE; l++) 
			{
				for (var v:int = 0; v < VERT; v++) 
				{
					myCmd.aheadOneTwoCur( l, v );
				}
			}
			if( 0 != myCmd.delPointArrVal.length && checkFlag )
			{
				myCmd.delGameObjs(true);  //消除符合条件的图片
				var fillTimer:Timer = new Timer(500,1);
				fillTimer.addEventListener(TimerEvent.TIMER, fillPicView);
				fillTimer.start();
			}
		}		
	}
}

 