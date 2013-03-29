package com.dbxgzs.extendMC
{
	import com.dbxgzs.scene.GameScene;
	import com.dbxgzs.serverPush.ServerPush;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	public class TimeOverMC 
	{
		private var gameScene:GameScene;
		private var serverPush:ServerPush;
		private var timeOver:TimeOver, gameStartOver:GameStartOver, gameStartUp:GameStartUp;
		
		public function TimeOverMC(_gameScene:GameScene, _serverPush:ServerPush)
		{
			gameScene = _gameScene;
			serverPush = _serverPush;
		}
		
		/**
		 * 时间到
		 */
		public function showTimeOver():void
		{
			timeOver = new TimeOver();
			timeOver.width = 300, timeOver.height = 100;
			var stageWidth:int = Global.stage.stageWidth, stageHeight:int = Global.stage.stageHeight;
			timeOver.x = (stageWidth - timeOver.width)*0.5;
			timeOver.y = (stageHeight - timeOver.height)*0.5 - 100;
			gameScene.addExtendsObject( timeOver );
			
			gameStartOver = new GameStartOver();
			gameStartOver.x = timeOver.x + 0.5*(timeOver.width - gameStartOver.width);
			gameStartOver.y = timeOver.y + timeOver.height + 30;
			gameScene.addExtendsObject( gameStartOver );
			gameStartOver.addEventListener( MouseEvent.MOUSE_OVER, gameStartMouseOver );
		}
		
		/**
		 * 鼠标一移开
		 */
		protected function gameStartMouseOut(event:MouseEvent):void
		{
			gameScene.removeExtendsObject( event.currentTarget as MovieClip  );
			gameScene.addExtendsObject( gameStartOver );
		}
		
		/**
		 * 鼠标进入
		 */
		protected function gameStartMouseOver(event:MouseEvent):void
		{
			gameScene.removeExtendsObject( event.currentTarget as MovieClip );
			if( null == gameStartUp )
			{
				gameStartUp = new GameStartUp();
				gameStartUp.x = gameStartOver.x + (gameStartOver.width - gameStartUp.width)*0.5;
				gameStartUp.y = gameStartOver.y + (gameStartOver.height - gameStartUp.height)*0.5;
				gameStartUp.addEventListener( MouseEvent.CLICK, gameStartUpClick );
				gameStartUp.addEventListener( MouseEvent.MOUSE_OUT, gameStartMouseOut );
			}
			gameScene.addExtendsObject( gameStartUp );
		}
		
		/**
		 * 鼠标点击
		 */
		protected function gameStartUpClick(event:MouseEvent):void
		{
			gameScene.removeExtendsObject( timeOver );
			gameScene.removeExtendsObject( event.currentTarget as MovieClip );
			gameStartOver.removeEventListener( MouseEvent.MOUSE_OVER, gameStartMouseOver );
			gameStartOver = null;
			gameStartUp.removeEventListener( MouseEvent.CLICK, gameStartUpClick );
			gameStartUp.removeEventListener( MouseEvent.MOUSE_OUT, gameStartMouseOut );
			gameStartUp = null;
			timeOver = null;
			
			serverPush.dictionary = new Dictionary();
			gameScene.getClientSocket().playGame();
			gameScene.clearTargetGameObjs();
			gameScene.extendMC.initStageBg(); //初始化舞台背景
			gameScene.initStage(); //初始化舞台
			gameScene.dataLogic.checkFlag = true;
		}
	}
}