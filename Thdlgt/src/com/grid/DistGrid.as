package com.grid
{
	import com.cmd.HitCmd;
	import com.plane.PlaneCmd;
	import com.plane.PlaneEnemy;
	import com.scene.StageObjects;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.utils.getTimer;

	public class DistGrid
	{
		private var gridWidth:int = 30; //默认是自己飞机的宽度
		private var indexArr:Array;
		private var lineCount:int, vertCount:int;  //每行的格子数，每列的格子数
		private var lineNum:int, vertNum:int;  //当前对象所属的行，列格子数
		private var px:Number, py:Number;
		private var bulletsObj:Vector.<Bitmap>; //子弹容器
		private var planesObj:Vector.<Bitmap>;
		private var stageObjs:StageObjects;
		private var hitCmd:HitCmd = new HitCmd();
		
		private var _enemyPlanes:Vector.<Bitmap>;
		private var _planes:Vector.<Bitmap>;
		
		public function DistGrid()
		{
		}
		
		public function chkHits(e:Event):void
		{
			var t1:uint = getTimer();
			getLargestWidth(); //获取舞台上对象的最大宽度，高度
			var t2:uint = getTimer();
			getLineAndvertCount(); //获取行格子数跟列格子数
			var t3:uint = getTimer();
			distAllGrids();    //给舞台的每个对象划分所属格子
			var t4:uint = getTimer();
			checkBulletsHits();  //检测子弹与飞机是否发生碰撞
			var t5:uint = getTimer();
			//trace("getLargestWidth()="+(t2-t1)+", getLineAndvertCount()="+(t3-t2)+", distAllGrids()="+(t4-t3)+", checkBulletsHits()="+(t5-t4));
		}
		
		private function checkNextGrids(bmp:Bitmap, lineNum:int, vertNum:int):Boolean
		{
			if(commonCheck(bmp, lineNum, vertNum)) //所在的点 
			{
				return true;
			}
			if (commonCheck(bmp, lineNum - 1, vertNum))//上
			{
				return true;
			} 
			if (commonCheck(bmp, lineNum - 1, vertNum - 1))//上左
			{
				return true;
			} 
			if (commonCheck(bmp, lineNum, vertNum - 1))//左
			{
				return true;
			}
			if (commonCheck(bmp, lineNum + 1, vertNum - 1))//左下
			{
				return true;
			}
			if (commonCheck(bmp, lineNum + 1, vertNum)) //下
			{
				return true;
			} 
			if (commonCheck(bmp, lineNum + 1, vertNum + 1))//下右
			{
				return true;
			}
			if (commonCheck(bmp, lineNum, vertNum + 1))//右
			{
				return true;
			} 
			if (commonCheck(bmp, lineNum - 1, vertNum + 1))//右上
			{
				return true;
			}
			return false;
		}
		
		private function commonCheck(bmp:Bitmap, lineNum:int, vertNum:int):Boolean
		{
			var indexPlaceArr:Array = indexArr[lineNum*lineCount+vertNum];
			if( stageObjs.bullets.indexOf(bmp) != -1 ) 
			{
				for each (var bm:Bitmap in indexPlaceArr)   
				{
					//if( stageObjs.enemyBullets.indexOf( bm ) != -1 ) 
					if( _enemyPlanes.indexOf( bm ) != -1 )
					{
						if(checkHits(bmp, bm))
						{
							hitCmd.killEnemy(bmp, bm);
							return true;
						}
					}
				}
			}
			else if(stageObjs.enemyBullets.indexOf(bmp)  != -1)  
			{
				for each (var bm:Bitmap in indexPlaceArr)  
				{
					//if( stageObjs.bullets.indexOf( bm ) != -1 ) 
					if( _planes.indexOf( bm ) != -1 )
					{
						if(checkHits(bmp, bm))
						{
							hitCmd.killMe(bmp, bm);
							return true;
						}
					}
				}
			}
			else if(_planes.indexOf(bmp)  != -1)    //飞机飞机碰撞
			{
				for each (var bm:Bitmap in indexPlaceArr)  
				{
					if( _enemyPlanes.indexOf( bm ) != -1 )
					{
						if(checkHitsPoints(bm, bmp.x, bmp.y))
						{
							hitCmd.hitPlane(bmp, bm);
							return true;
						}
					}
					
					if( hitCmd.bulletFoodBmps.indexOf( bm ) != -1 )
					{
						if(checkHitsPoints(bm, bmp.x, bmp.y))
						{
							hitCmd.eatBulletFood(bmp, bm);
							return true;
						}
					}
				}
			}
			return false;
		}
		
		/**
		 * @param bmp:敌人飞机
		 * @param x:本机x轴位置
		 * @param y:本机y轴位置
		 */
		private function checkHitsPoints(bmp:Bitmap, x:Number, y:Number):Boolean
		{
			var flag:Boolean = false;

			if( bmp.hitTestPoint( x+15, y, true) || bmp.hitTestPoint( x, y+20, true) ||bmp.hitTestPoint( x+30, y+20, true) ||
				bmp.hitTestPoint( x, y+20, true) || bmp.hitTestPoint( x+10, y+30, true) )
			{
				flag = true;
			}
			return flag;
		}
		
		private function checkHits(initBmp:Bitmap, bmp:Bitmap):Boolean
		{
			var flag:Boolean = false;
            if( bmp.hitTestPoint( initBmp.x, initBmp.y,true) || bmp.hitTestPoint( initBmp.x+14, initBmp.y,true) )
			{
				flag = true;
			}
			return flag;
		}
		
		/**
		 * 检测舞台上的飞机是否发生碰撞
		 */
		private function checkBulletsHits():void
		{
			//子弹与飞机碰撞
			bulletsObj = stageObjs.bullets.concat(stageObjs.enemyBullets);
			for each (var bmp:Bitmap in bulletsObj) 
			{
				px = bmp.x, py = bmp.y;
				lineNum =  Math.floor(bmp.y/gridWidth),
				vertNum = Math.floor(bmp.x/gridWidth);
				checkNextGrids(bmp, lineNum, vertNum);
			}
			
			//飞机与飞机碰撞
			//planesObj = _planes.concat( _enemyPlanes );
			for each (var bmp:Bitmap in _planes) 
			{
				px = bmp.x, py = bmp.y;
				lineNum =  Math.floor(bmp.y/gridWidth),
					vertNum = Math.floor(bmp.x/gridWidth);
				checkNextGrids(bmp, lineNum, vertNum);
			}
			
			//飞机与子弹食物碰撞
//			planesObj = _planes.concat( _enemyPlanes );
//			for each (var bmp:Bitmap in planesObj) 
//			{
//				px = bmp.x, py = bmp.y;
//				lineNum =  Math.floor(bmp.y/gridWidth),
//					vertNum = Math.floor(bmp.x/gridWidth);
//				checkNextGrids(bmp, lineNum, vertNum);
//			}
			
		}
		
		/**
		 * 给舞台对象划分所属格子
		 */
		private function distAllGrids():void
		{
			indexArr = new Array();
			stageObjs = Global._stageObjs;
			_planes = new Vector.<Bitmap>(), _enemyPlanes = new Vector.<Bitmap>(); 
			var stageObjBmp:Vector.<Bitmap> = stageObjs.bullets.concat(stageObjs.enemyBullets);
			for each (var pc:PlaneCmd in stageObjs.planes) 
			{
				_planes[_planes.length] = pc.getBitMap;
			}
			for each (var pe:PlaneEnemy in stageObjs.enemyPlanes) 
			{
				_enemyPlanes[_enemyPlanes.length] = pe.bitMap;
			}
			stageObjBmp = stageObjBmp.concat( _planes ).concat( _enemyPlanes );
			
			stageObjBmp = stageObjBmp.concat( Global._scene.bulletFoodBmps );
			
			for each (var bmp:Bitmap in stageObjBmp) 
			{
				px = bmp.x, py = bmp.y;
				var index:int = Math.floor(bmp.y/gridWidth)*lineCount + Math.floor(bmp.x/gridWidth);
				if( null == indexArr[index] )
				{
					indexArr[index] = new Array();
					indexArr[index][0] = bmp;
				}
				else
				{
					indexArr[index][indexArr[index].length] = bmp;
				}					
			}
		}
		
		/**
		 * 计算每行/列多少个格子
		 */
		private function getLineAndvertCount():void
		{
			lineCount = Math.ceil( Global._stage.stageWidth/gridWidth );
			vertCount = Math.ceil( Global._stage.stageHeight/gridWidth );
		}
		
		/**
		 * 子弹不比飞机大，唯一有可能比飞机打的只有敌方飞机，所以只需要遍历敌方飞机，找到其最大宽度即可
		 */
		private function getLargestWidth():void
		{
			var ep:Vector.<PlaneEnemy> = Global._stageObjs.enemyPlanes;
			for each (var pe:PlaneEnemy in ep) 
			{
				if( pe.bitMap.width > gridWidth )
				{
					gridWidth = pe.bitMap.width;
				}
			}
		}
		
		
	}
}
