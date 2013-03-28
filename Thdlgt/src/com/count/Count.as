package com.count
{
	
	import com.loader.InfoLoader;
	import com.utils.Utils;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;

	public class Count
	{
		private var countNum:Array = new Array(5); //记分数组
		
		private var countArr:Vector.<Bitmap> = new Vector.<Bitmap>(10);
		private var zeroLoader:Loader, oneLoader:Loader, twoLoader:Loader, threeLoader:Loader,
		fourLoader:Loader, fiveLoader:Loader, sixLoader:Loader, sevenLoader:Loader,
		eightLoader:Loader, nightLoader:Loader;
		
		public function Count()
		{
			loadCount();
		}
		
		public function initCountAppend():void
		{
			for (var i:int = 0; i < countNum.length; i++) 
			{
				var obj:Bitmap = Utils.cloneBitMap( countArr[0] );
				obj.width = 10, obj.height = 10, obj.x = 25*i + 10, obj.y = 20;
				Global._scene.addCountBmps( obj );
			}
		}
		
		public function countChange(len:int, num:Array):Array
		{
			var one:int = num[4], two:int = num[3],
				three:int = num[2], four:int = num[1], five:int = num[0];	
			var oneSum:int = 0, oneEnd:int = 0;
			if( len <= 9 )
			{
				one = one + len;
				if (one >= 10) 
				{
					var str:Array = one.toString().split("");
					two = two + int(str[0]);
					one = int(str[1]);
					
					if( two >= 10)
					{
						str = two.toString().split("");
						three = three + int(str[0]);
						two = int(str[1]);
					}
				}
			}
			else
			{
				var str:Array = one.toString().split("");
				two = two + int(str[0]);
				oneEnd = int(str[1]);
				one = one + oneEnd;
				if (one >= 10) 
				{
					var str:Array = one.toString().split("");
					two = two + int(str[1]);
					one = int(str[1]);
					
					if( two >= 10)
					{
						str = two.toString().split("");
						three = three + int(str[0]);
						two = int(str[1]);
					}
				}
			}
			
			num[4] = one,  num[3] = two,
				num[2] = three , num[1] = four, num[0] = five;
			return num;
		}
		
		/**
		 * 积分变化
		 */
		public function changeCount(count:uint):void
		{
			countNum = countChange( count, countNum);
			
			for (var j:int = Global._scene.countBmps.length-1; j >= 0; j--) 
			{
				Global._scene.removeCountBmps( Global._scene.countBmps[j] );
			}
			
			for (var i:int = 0; i < countNum.length; i++) 
			{
				var obj:Bitmap = Utils.cloneBitMap(countArr[countNum[i]]);
				obj.width = 10, obj.height = 10, obj.x = 25*i + 10, obj.y = 20;
				Global._scene.addCountBmps( obj );
			}
			
		}
		
		
		protected function loadCount():void
		{
			oneLoader = InfoLoader.loadInfo( "../pic/One.png" );
			oneLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, loadOneCmp );
			
			twoLoader = InfoLoader.loadInfo( "../pic/Two.png" );
			twoLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, loadTwoCmp );
			
			threeLoader = InfoLoader.loadInfo( "../pic/Three.png" );
			threeLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, loadThreeCmp );
			
			fourLoader = InfoLoader.loadInfo( "../pic/Four.png" );
			fourLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, loadFourCmp );
			
			fiveLoader = InfoLoader.loadInfo( "../pic/Five.png" );
			fiveLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, loadFiveCmp );
			
			sixLoader = InfoLoader.loadInfo( "../pic/Six.png" );
			sixLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, loadSixCmp );
			
			sevenLoader = InfoLoader.loadInfo( "../pic/Seven.png" );
			sevenLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, loadSevenCmp );
			
			eightLoader = InfoLoader.loadInfo( "../pic/Eight.png" );
			eightLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, loadEightCmp );
			
			nightLoader = InfoLoader.loadInfo( "../pic/Night.png" );
			nightLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, loadNightCmp );
			
			zeroLoader = InfoLoader.loadInfo( "../pic/Zero.png" );
			zeroLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, loadZeroCmp );
		}	
		
		protected function loadZeroCmp(e:Event):void
		{
			countArr[0] = Bitmap(zeroLoader.content);
			initCountAppend();
		}
		
		protected function loadNightCmp(e:Event):void
		{
			countArr[9] = Bitmap(nightLoader.content);
		}
		
		protected function loadEightCmp(e:Event):void
		{
			countArr[8] = Bitmap(eightLoader.content);
		}
		protected function loadSevenCmp(e:Event):void
		{
			countArr[7]= Bitmap(sevenLoader.content);
		}
		protected function loadSixCmp(e:Event):void
		{
			countArr[6] = Bitmap(sixLoader.content);
		}
		protected function loadFiveCmp(e:Event):void
		{
			countArr[5] = Bitmap(fiveLoader.content);
		}
		protected function loadFourCmp(e:Event):void
		{
			countArr[4] = Bitmap(fourLoader.content);
		}
		protected function loadThreeCmp(e:Event):void
		{
			countArr[3] = Bitmap(threeLoader.content);
		}
		
		protected function loadTwoCmp(e:Event):void
		{
			countArr[2] = Bitmap(twoLoader.content);
		}
		
		protected function loadOneCmp(e:Event):void
		{
			countArr[1] = Bitmap(oneLoader.content);
		}
	}
}