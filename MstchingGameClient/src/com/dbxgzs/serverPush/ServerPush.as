package com.dbxgzs.serverPush
{
	import com.dbxgzs.extendMC.TimeOverMC;
	import com.dbxgzs.object.GameObject;
	import com.dbxgzs.scene.GameScene;
	import com.dbxgzs.userCmd.EnemyCmd;
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.setTimeout;

	public class ServerPush
	{
		private var displayList:Array;
		private var gameObj:GameObject;
		// 第一行距离顶部的距离， 每行有多少张图片， 列图片间距， 行图片间距
		public var dictionary:Dictionary;
		private var coverBox:Box;
		private var gameObject:GameObject = new GameObject();
		private var countNum:MovieClip;  //倒计时显示对象
		private var gameScene:GameScene;
		private var totalGameArr:Array;
		private const LINE:int = 8, VERT:int = 9; //每行9个，每列8个
		private static const top:int = 60, lineSize:int = 7, lineSlide:int = 8, vertSlide:int = 5; 
		private var timeOverMC:TimeOverMC;
		private var enemyCmd:EnemyCmd;
		
		public function ServerPush(_gameScene:GameScene)
		{
			gameScene = _gameScene;
			displayList = new Array();
			gameObj = new GameObject();
			dictionary = new Dictionary();
			totalGameArr = new Array();
		}
		
		/**
		 * 展示对方待游戏对象  协议1
		 */
		public function showPrePics(objNames:Vector.<Object>):void
		{
			trace(objNames.toString());
			var len:int = objNames.length;
			var flag:Boolean = true;
			for (var i:int = 1; i <= 6; i++)  //共6行
			{
				if( flag )
				{
					for (var j:int = 1; j <= lineSize; j++)  //每行7个
					{
						var num:int = (i-1)*lineSize+j;
						if( num > len )  //超出存在图片个数
						{
							flag = false;
							break;
						}
						var name:String = objNames[num-1].toLowerCase();
						var obj:MovieClip = gameObj.getDisplayObject(name);
						appendPreGameObj( obj, i,  j);
					}
				}
				else
				{
					break;
				}
			}
		}
		
		/**
		 * 追加对手游戏对象到舞台
		 */
		public function  appendPreGameObj( obj:MovieClip, i:int, j:int ):void
		{
			obj.width = 47;
			obj.height = 47;
			obj.x = 525+(j-1)*50+j*lineSlide;
			obj.y = 55+50*(i-1)+vertSlide*i;
			gameScene.addObject( obj ) ;  
		}

		/**
		 * 修改覆盖层  协议2
		 */
		public function changeCover(val:String):void
		{
			if (!dictionary.hasOwnProperty(val))
			{
				coverBox=new Box();
				dictionary[val]=coverBox;
				var arr:Array=val.split(",");
				coverBox.width=47;
				coverBox.height=47;
				coverBox.x=parseFloat(arr[0]) + 475;
				coverBox.y=parseFloat(arr[1]);
				gameScene.addObject(coverBox);
			}
			else
			{
				var obj:MovieClip=dictionary[val];
				gameScene.removeObject(obj);
				delete dictionary[val];
			}
		}
		
		/**
		 * 倒数开始游戏  协议3
		 */
		public function countBackward():void
		{
			var timer:Timer=new Timer(1000, 6);
			timer.addEventListener(TimerEvent.TIMER, countBackwordEvent);
			timer.addEventListener( TimerEvent.TIMER_COMPLETE, removeGameObj);
			timer.start();
		}
		
		
		/**
		 * 倒数事件 
		 */
		public function countBackwordEvent(e:TimerEvent):void
		{
			if( null != countNum )
			{
				gameScene.removeExtendsObject( countNum );
			}
			var bc:int = 6 - e.currentTarget.currentCount;
			countNum = gameObject.getCount(bc);
			countNum.width = 300, countNum.height = 300;
			countNum.x = (Global.stage.stageWidth - countNum.width)/2;
			countNum.y = (Global.stage.stageHeight - countNum.height)/2;
			gameScene.addExtendsObject( countNum );
		}
		
		/**
		 * 倒计时完成后清除对手界面信息                                                                                                                                                                                                                                            
		 */
		public function removeGameObj(e:TimerEvent):void
		{
			gameScene.removeExtendsObject( countNum ); //移除倒计时
			
			//移除游戏对象
			var displayListVector:Vector.<DisplayObject> = gameScene.getDisplayList;
			var dislen:int = displayListVector.length;
			for (var i:int = 0; i < dislen; i++) 
			{
				var obj:MovieClip = displayListVector[0];  //动态数组，每次删减后都重组
				gameScene.removeObject( obj );
			}
			
			gameScene.extendMC.removeTitle(); //移除标题
			gameScene.startGame(); //开始游戏
			gameScene.extendMC.appendTimeLine();  //添加计时器

			var timer:Timer = new Timer(100,1500);
			//var timer:Timer = new Timer(100,100);
			timer.addEventListener( TimerEvent.TIMER, timeDel );
			timer.addEventListener( TimerEvent.TIMER_COMPLETE, timeCmp );
			timer.start();
		}
		
		
		/**
		 * 计时器完成
		 */
		protected function timeCmp(event:TimerEvent):void
		{
			gameScene.dataLogic.checkFlag = false; //清除自动消除动作
			
			totalGameArr = new Array();	//重置游戏数组
			
			//清除其他对象
			gameScene.clearExtendListObj(); 
			
			//清除图片点击事件
			var arr:Vector.<DisplayObject> = gameScene.getDisplayList;
			var len:int = arr.length;
			var obj:MovieClip;
			for (var i:int = 0; i < len; i++) 
			{
				obj = arr[0] ;
				if( obj.hasEventListener( MouseEvent.CLICK ) )
				{
					obj.removeEventListener( MouseEvent.CLICK, gameScene.eventCmd.clickPic );
				}
				gameScene.removeObject( obj );
			}
			
			//通知服务器游戏结束
			gameScene.getClientSocket().timeOver();
			
			timeOverMC = new TimeOverMC(gameScene, this);
			timeOverMC.showTimeOver();
		}
		
		/**
		 * 时间递减
		 */
		protected function timeDel(event:TimerEvent):void
		{
			var tlr:MovieClip = gameScene.extendMC.tlr;
			tlr.width = tlr.width - 0.64;
		}
		
		/**
		 * 初始化对手游戏界面
		 */
		public function initEnemyGame(gameObjArr:Object):void
		{
			var gameObjs:Array = gameObjArr as Array;
			var line:int = gameObjs.length;
			var obj:MovieClip = null;
			for (var i:int = 0; i < line; i++) 
			{
				var lineArr:Array = gameObjs[i] as Array;
				var vert:int = lineArr.length;
				var totalLineArr:Array = new Array();
				for (var j:int = 0; j < vert; j++) 
				{
					obj = gameObject.getDisplayObject( lineArr[j] );
					totalLineArr[totalLineArr.length] = obj;
					appendInitGameObj( obj, i, j);
				}
				totalGameArr[totalGameArr.length] = totalLineArr;
			}
			//添加积分器
			gameScene.count.appendEnemyCount();
			
			//初始化并设置游戏对象数组的值
			enemyCmd = new EnemyCmd(gameScene);
			enemyCmd.totalGameArrVal = totalGameArr;
		}
		
		/**
		 * 把图片添加到舞台
		 */
		public function appendInitGameObj(obj:MovieClip, line:int, vert:int):void
		{
			obj.width = 47;
			obj.height = 47;
			obj.x = 525 + vert*47;
			obj.y = 50 + line*47;
			gameScene.addObject( obj);
		}
		
		
		/**
		 * 同步用户交换两点图片
		 */
		public function sysUserCmd(obj:Object):void
		{
			var pointsArr:Array = obj as Array;
			var fl:int = pointsArr[0], fv:int = pointsArr[1],  //行，列
				sl:int = pointsArr[2], sv:int = pointsArr[3];  //行，列
			
			totalGameArr = enemyCmd.totalGameArrVal; 
			
			var firstTarget:MovieClip = totalGameArr[fl][fv];
			var secondTarget:MovieClip = totalGameArr[sl][sv];
			
			TweenLite.to( firstTarget, 0.3, {x:secondTarget.x, y:secondTarget.y} );  //移动图片
			TweenLite.to( secondTarget, 0.3, {x:firstTarget.x, y:firstTarget.y} ); //移动图片
			
			totalGameArr[fl][fv] = secondTarget;		//交换数组位置
			totalGameArr[sl][sv] = firstTarget;			//交换数组位置
			
			enemyCmd.aheadOneTwoCur( fl, fv );			//交换数组位置
			enemyCmd.aheadOneTwoCur( sl, sv );
			
			if( 0 == enemyCmd.delPicArrVal.length )
			{
				totalGameArr[fl][fv] = firstTarget;
				totalGameArr[sl][sv] = secondTarget;
				setTimeout( function():void
				{
					TweenLite.to( firstTarget, 0.3, {x:secondTarget.x, y:secondTarget.y} );
					TweenLite.to( secondTarget, 0.3, {x:firstTarget.x, y:firstTarget.y} );
				},500);
			}
			else
			{
				var delTimer:Timer = new Timer(500,1);
				delTimer.addEventListener( TimerEvent.TIMER, enemyCmd.delPic );
				delTimer.start();
			}
		}

		/**
		 * 同步填充 协议6
		 */
		public function fillGameObjs(fillGameObjects:Object):void
		{
			totalGameArr = enemyCmd.totalGameArrVal;
			for (var v:int = 0; v < VERT; v++) 
			{
				var emptySize:int = 0;
				for (var l:int=LINE - 1; l >= 0; l--)
				{
					var curObj:Object = totalGameArr[l][v];
					if (0 == curObj)
					{
						emptySize++;
					}
					else if (0 != emptySize && 0 != curObj)  //对于下方有空，本格有之而言
					{
						totalGameArr[l+emptySize][v] = curObj;
						totalGameArr[l][v] = 0;
						TweenLite.to( curObj, 0, {x:v*47 + 525, y:(l+emptySize)*47 + 50} );  //动画效果进入
					}
				}
			}	
			
			var fillGameObjsArr:Array = fillGameObjects as Array;
			var fillLen:int = fillGameObjsArr.length;
			for (var i:int = 0; i < fillLen; i++) 
			{
				var tempArr:Array = fillGameObjsArr[i];
				var v:int = tempArr[1];
				var l:int = tempArr[2];
				var objName:String = tempArr[0];
				var obj:MovieClip = gameObject.getDisplayObject( objName);
				totalGameArr[l][v] = obj;
				fillGameObj( obj, l, v );
			}
			
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
					enemyCmd.aheadOneTwoCur( l, v );
				}
			}
			if( 0 != enemyCmd.delPointArrVal.length )
			{
				enemyCmd.delGameObj();  //消除符合条件的图片
			}
		}	
		
		/**
		 * 追加游戏对象到舞台
		 */
		public function fillGameObj( obj:MovieClip, line:int, vert:int):void
		{
			obj.width = 47;
			obj.height = 47;
			obj.x = vert*47 + 525;
			gameScene.addObject( obj);
			TweenLite.to( obj, 0, {y:line*47+50} );  //动画效果进入
		}
	}
}