package com.scene
{
	import com.command.MouseController;
	import com.display.DisplayGame;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.utils.Timer;

	public class GameScene extends Sprite
	{
		private var objectList:Array;
		public var lineShape:Array = new Array();
		private var displayGame:DisplayGame;
		private var timeLine:MovieClip;
		private var changeSome:ShapeChangeSomeOne;
		private var findSome:ShapeFindSomeOne;
		private var gameOver:ShapeGameOver;
		private var resume:ShapeResume;
		private var timer:Timer;
		private var win:ShapeWin;
		private var changeSomeFlag:Boolean = false;
		
		public function GameScene(stage)
		{
			Global.stage = stage ;
			objectList = new Array() ;
			initScene();  //初始化舞台
		}
		
		/**
		 * 新增显示对象
		 */
		public function addObject(obj:MovieClip):void {
			objectList.push(obj) ;
			Global.stage.addChild( obj );
		}
		
		/**
		 * 移除显示对象
		 */
		public function removeObject(obj:MovieClip):void {
			var id:int = objectList.indexOf(obj);
			if( id != -1) {
				objectList.splice( id, 1 );
				Global.stage.removeChild( obj );
				if(0 == objectList.length && timer.currentCount!=570&&!changeSomeFlag) {
					youWin();
				}
			}
		}
		
		/**
		 * 初始化游戏背景
		 */
		public function initScene():void {
			var bg:MovieClip = new Background();
			bg.width = 500 ;
			bg.height = 370;
			Global.stage.addChild( bg );
			
			var style:StyleSheet = new StyleSheet();
			var heading:Object = new Object();
			heading.fontWeight = "bold";
			heading.fontSize = 20;
			heading.color = "#FF0000";
			style.setStyle(".count", heading);
			
			Global.label = new TextField();
			Global.label.text = Global.count+"";
			Global.label.styleSheet = style ;
			Global.label.htmlText = "<p class='count'>" + Global.count + "</p>";
			Global.stage.addChild(Global.label);
			Global.label.x = 30;
			Global.label.y = 40;
			Global.label.width = 30;
			Global.label.height = 30;
			
			//换一部分按钮
			changeSome = new ShapeChangeSomeOne();
			changeSome.width = 35;
			changeSome.height = 35;
			changeSome.x = 16;
			changeSome.y = 110.40;
			Global.stage.addChild(changeSome);
			
			//自动匹配按钮
			findSome = new ShapeFindSomeOne();
			findSome.width = 35;
			findSome.height = 35;
			findSome.x = 16;
			findSome.y = 152.40
			Global.stage.addChild(findSome);
			
			//添加开始按钮
			var startBtn:MovieClip = new ShapeGameStartUp();
			startBtn.x = 200;
			startBtn.y = 160;
			Global.stage.addChild( startBtn );
			startBtn.addEventListener( MouseEvent.MOUSE_OVER, mouseOverStartBtn );
		}
		
		/**
		 * 聚焦实现
		 */
		public function mouseOverStartBtn(e:MouseEvent):void {
			Global.stage.removeChild( e.currentTarget as MovieClip );
			var startBtn:MovieClip = new ShapeGameStartOver();
			startBtn.x = 200;
			startBtn.y = 160;
			Global.stage.addChild( startBtn );
			startBtn.addEventListener( MouseEvent.MOUSE_OUT , mouseOutStartBtn );
			startBtn.addEventListener( MouseEvent.CLICK, mouseClickStartBtn );
		}
		
		
		/**
		 * 点击事件
		 */
		public function mouseClickStartBtn(e:MouseEvent):void {
			
			Global.stage.removeChild( Global.label );
			
			var style:StyleSheet = new StyleSheet();
			var heading:Object = new Object();
			heading.fontWeight = "bold";
			heading.fontSize = 20;
			heading.color = "#FF0000";
			style.setStyle(".count", heading);
			
			Global.label = new TextField();
			Global.label.text = Global.count+"";
			Global.label.styleSheet = style ;
			Global.label.htmlText = "<p class='count'>" + Global.count + "</p>";
			Global.stage.addChild(Global.label);
			
			
			Global.label.x = 30;
			Global.label.y = 40;
			Global.label.width = 30;
			Global.label.height = 30;
			
			if(null!=gameOver){
				Global.stage.removeChild(gameOver);
			}
			
			if(null!=win){
				Global.stage.removeChild(win);
			}
			
			e.currentTarget.removeEventListener( MouseEvent.MOUSE_OUT , mouseOutStartBtn );
			Global.stage.removeChild( e.currentTarget as MovieClip );
			displayGame = new DisplayGame(this, new MouseController());	//初始化场景
			
			changeSome.addEventListener( MouseEvent.CLICK, changeSomeShape );
			findSome.addEventListener( MouseEvent.CLICK, findSomeShape );
			
			timeLine = new ShapeTimeLine();
			timeLine.x = 65 ;
			timeLine.y = 357 ;
			timeLine.width = 425;
			Global.stage.addChild( timeLine );
			timer = new Timer(100, 570);
			timer.addEventListener( TimerEvent.TIMER, timeUp );
			timer.addEventListener( TimerEvent.TIMER_COMPLETE, youLose );
			timer.start();
		}
		
		
		public function youLose(e:TimerEvent):void {
			if(objectList.length==0) return;
			gameOver = new ShapeGameOver();
			gameOver.x = 150;
			gameOver.y = 160;
			Global.stage.addChild(gameOver);
			
			resume = new ShapeResume();
			resume.x = 400;
			resume.y = 320;
			Global.stage.addChild( resume );
			resume.addEventListener( MouseEvent.CLICK, mouseClickStartBtn);
			
			var size:int = objectList.length;
			for(var i:int = 0; i<size; i++){
				removeObject( objectList[0] );
			}
			
			changeSome.removeEventListener( MouseEvent.CLICK, changeSomeShape );
			findSome.removeEventListener( MouseEvent.CLICK, findSomeShape );
		}
		
		public function findSomeShape(e:MouseEvent):void {
			Global.stage.removeChild(e.currentTarget as MovieClip);
			var findSome:ShapeFindSomeTwo = new ShapeFindSomeTwo();
			findSome.width = 35;
			findSome.height = 35;
			findSome.x = 16;
			findSome.y = 152.40
			Global.stage.addChild(findSome);
			
			//自动提示
			displayGame.autoTips();
			
		}
		
		public function changeSomeShape(e:MouseEvent):void{
			Global.stage.removeChild(e.currentTarget as MovieClip);
			var changeSome:ShapeChangeSomeTwo = new ShapeChangeSomeTwo();
			changeSome.width = 35;
			changeSome.height = 35;
			changeSome.x = 16;
			changeSome.y = 110.40;
			Global.stage.addChild(changeSome);
			
			changeSomeFlag = true;
			
			//移除全部
			var size:int = objectList.length;
			for(var i:int = 0; i<size; i++){
				removeObject( objectList[0] );
			}
			
			//
			displayGame.changeShapes();
		}
		
		/**
		 * 计算时间
		 */
		public function timeUp(e:TimerEvent):void {
			timeLine.width = timeLine.width - 0.73;
		}
		
		/**
		 * 移开事件
		 */
		public function mouseOutStartBtn(e:MouseEvent):void {
			Global.stage.removeChild( e.currentTarget as MovieClip );
			var startBtn:MovieClip = new ShapeGameStartUp();
			Global.stage.addChild( startBtn );
			startBtn.x = 200;
			startBtn.y = 160;
			startBtn.addEventListener( MouseEvent.MOUSE_OVER, mouseOverStartBtn );
		}
		
		/**
		 * 胜利
		 */
		public function youWin():void{
			win  = new ShapeWin();
			win.x = 220;
			win.y = 70;
			Global.stage.addChild(win);
			
			resume = new ShapeResume();
			resume.x = 400;
			resume.y = 320;
			Global.stage.addChild( resume );
			resume.addEventListener( MouseEvent.CLICK, mouseClickStartBtn);
			
			var size:int = objectList.length;
			for(var i:int = 0; i<size; i++){
				removeObject( objectList[0] );
			}
			
			changeSome.removeEventListener( MouseEvent.CLICK, changeSomeShape );
			findSome.removeEventListener( MouseEvent.CLICK, findSomeShape );
			timer.removeEventListener( TimerEvent.TIMER, timeUp );
			timer.removeEventListener( TimerEvent.TIMER_COMPLETE, youLose );
		}
	}
}