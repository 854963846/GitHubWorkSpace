package com.plane.cmd
{
	import com.loader.InfoLoader;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	public class PlaneLoader
	{
		private var blueLoader:Loader, redLoader:Loader, bombLoader:Loader;
		private var _planesDict:Dictionary;
		private var _bombArr:Array;
		private var oneLoader:Loader, twoLoader:Loader, threeLoader:Loader,
		fourLoader:Loader, fiveLoader:Loader, sixLoader:Loader, sevenLoader:Loader,
		eightLoader:Loader, nightLoader:Loader;
		
		public function PlaneLoader( )
		{
			planesDict = new Dictionary();
			bombArr = new Array();
			loadPlane();
			loadBomb();
		}

		/**
		 * 加载飞机图片
		 */
		protected function loadPlane():void
		{
			blueLoader = InfoLoader.loadInfo( "../pic/PlaneBlue.png" );
			blueLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, loadBlueCmp );
			
			redLoader = InfoLoader.loadInfo( "../pic/PlaneRed.png" );
			redLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, loadRedCmp );
		
			bombLoader = InfoLoader.loadInfo( "../pic/BombFirst.png" );
			bombLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, loadBombCmp );
		}	
		
		protected function loadBombCmp(e:Event):void
		{
			planesDict["bomb"] = Bitmap(bombLoader.content);
		}
		
		protected function loadRedCmp(e:Event):void
		{
			planesDict["red"] = Bitmap(redLoader.content);
		}
		
		protected function loadBlueCmp(e:Event):void
		{
			planesDict["blu"] = Bitmap(blueLoader.content);
		}	
		
		protected function loadBomb():void
		{
			oneLoader = InfoLoader.loadInfo( "../pic/BombOne.png" );
			oneLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, loadOneCmp );
			
			twoLoader = InfoLoader.loadInfo( "../pic/BombTwo.png" );
			twoLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, loadTwoCmp );
			
			threeLoader = InfoLoader.loadInfo( "../pic/BombThree.png" );
			threeLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, loadThreeCmp );
			
			fourLoader = InfoLoader.loadInfo( "../pic/BombFour.png" );
			fourLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, loadFourCmp );
			
			fiveLoader = InfoLoader.loadInfo( "../pic/BombFive.png" );
			fiveLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, loadFiveCmp );
			
			sixLoader = InfoLoader.loadInfo( "../pic/BombSix.png" );
			sixLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, loadSixCmp );
			
			sevenLoader = InfoLoader.loadInfo( "../pic/BombSeven.png" );
			sevenLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, loadSevenCmp );
			
			eightLoader = InfoLoader.loadInfo( "../pic/BombEight.png" );
			eightLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, loadEightCmp );
			
			nightLoader = InfoLoader.loadInfo( "../pic/BombNight.png" );
			nightLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, loadNightCmp );
		}	
		
		protected function loadNightCmp(e:Event):void
		{
			bombArr[8] = Bitmap(nightLoader.content);
		}
		
		protected function loadEightCmp(e:Event):void
		{
			bombArr[7] = Bitmap(eightLoader.content);
		}
		protected function loadSevenCmp(e:Event):void
		{
			bombArr[6]= Bitmap(sevenLoader.content);
		}
		protected function loadSixCmp(e:Event):void
		{
			bombArr[5] = Bitmap(sixLoader.content);
		}
		protected function loadFiveCmp(e:Event):void
		{
			bombArr[4] = Bitmap(fiveLoader.content);
		}
		protected function loadFourCmp(e:Event):void
		{
			bombArr[3] = Bitmap(fourLoader.content);
		}
		protected function loadThreeCmp(e:Event):void
		{
			bombArr[2] = Bitmap(threeLoader.content);
		}
		
		protected function loadTwoCmp(e:Event):void
		{
			bombArr[1] = Bitmap(twoLoader.content);
		}
		
		protected function loadOneCmp(e:Event):void
		{
			bombArr[0] = Bitmap(oneLoader.content);
		}
		

		public function get planesDict():Dictionary
		{
			return _planesDict;
		}

		public function set planesDict(value:Dictionary):void
		{
			_planesDict = value;
		}

		public function get bombArr():Array
		{
			return _bombArr;
		}

		public function set bombArr(value:Array):void
		{
			_bombArr = value;
		}


	}
}