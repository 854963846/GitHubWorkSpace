package com.dbxgzs.extendMC
{
	import com.dbxgzs.scene.GameScene;
	
	import flash.display.MovieClip;
	import flash.text.StyleSheet;
	import flash.text.TextField;

	public class ExtendMC
	{
		private var gameScene:GameScene;
		//己方背景，对手背景，标题样式， 标题
		private var bg:Background = new Background(), bgOther:Background = new Background();
		private var titleStyle:StyleSheet, title:TextField; 
		
		public var tlb:MovieClip, tlr:MovieClip; //计时器
		
		public function ExtendMC(_gameScene:GameScene)
		{
			gameScene = _gameScene;
		}

		/**
		 * 初始化舞台背景
		 */
		public function initStageBg():void
		{
			//加载己方背景
			bg.x = 50, bg.y = 50 ;
			gameScene.addToStage( bg );
			
			//加载对手背景
			bgOther.x = 525 , bgOther.y = 50;
			gameScene.addToStage( bgOther );
			
			//创建标题
			createTitle();
		}
		
		/**
		 * 创建标题
		 */
		public function createTitle():void
		{
			//标题样式
			titleStyle = new StyleSheet();
			var heading:Object = new Object();
			heading.fontWeight = "bold";
			heading.fontSize = 23;
			heading.color = "#FF0000";
			heading.textAlign = "center";
			titleStyle.setStyle(".count", heading);
			//标题
			title = new TextField();
			title.styleSheet = titleStyle ;
			title.htmlText = "<p class='count'>请选择5个游戏人物</p>";
			title.y = 10;
			title.width = 1000;
			gameScene.addExtendsObject( title );
		}
		
		/**
		 * 移除标题
		 */
		public function removeTitle():void
		{
			gameScene.removeExtendsObject( title );
			titleStyle = null;
			title = null;
		}
		
		/**
		 * 添加计时器
		 */
		public function appendTimeLine():void
		{
			//展示计数器
			tlb=new TimeLineBlack();
			tlb.x=20, tlb.y=20;
			tlb.width=960;
			gameScene.addExtendsObject(tlb);
			
			tlr=new TimeLineRed();
			tlr.x=20, tlr.y=20;
			tlr.width=960;
			gameScene.addExtendsObject(tlr);
		}
		
	}
}