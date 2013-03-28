package com.loader.loadMap
{
	import com.loader.InfoLoader;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class LoadMap extends InfoLoader
	{
		private var firstLoader:Loader;   
		private var secondLoader:Loader;
		private var firstBm:Bitmap;
		private var secondBm:Bitmap;
		
		private var mapArr:Vector.<Bitmap>;
		
		public function LoadMap()
		{
			mapArr = new Vector.<Bitmap>();
			
			loadBg();
		}
		
		private function loadBg():void
		{
			firstLoader = InfoLoader.loadInfo("../pic/backgroundOne.png");
			firstLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, loadOneCmp );
			
			var timer:Timer = new Timer(1000,1);
			timer.addEventListener( TimerEvent.TIMER, loadBgTwo );
			timer.start();
		}
		
		protected function loadBgTwo(event:TimerEvent):void
		{
			secondLoader = InfoLoader.loadInfo("../pic/backgroundTwo.png");
			secondLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, loadTwoCmp );
		}		
		
		protected function loadOneCmp(event:Event):void
		{
			firstBm = Bitmap(firstLoader.content);
			firstBm.y = -3322;
			Global._scene.addMaps( firstBm );
			Global._stage.addEventListener( Event.ENTER_FRAME, moveBgOne );
		}
		
		protected function loadTwoCmp(event:Event):void
		{
			secondBm = Bitmap(secondLoader.content);
			secondBm.y = firstBm.y-3822;
			Global._scene.addMaps( secondBm );
		}
		
		/**
		 * 背景移动
		 */
		protected function moveBgOne(event:Event):void
		{
			firstBm.y +=1;
			if(null != secondBm ){
				secondBm.y +=1;
				
				if(firstBm.y==500)
				{
					firstBm.y = secondBm.y - 3322;
				}
				else if(secondBm.y==500)
				{
					secondBm.y = firstBm.y - 3322;
				}
			}
		}
		
	}
}