package com.dbxgzs.userCmd
{
	import com.dbxgzs.object.GameObject;
	import com.dbxgzs.scene.GameScene;
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setTimeout;

	public class UserCmd
	{
		protected const LINE:int = 8, VERT:int = 9; //每行9个，每列8个
		protected var delPicArr:Array, delPointArr:Array;
		protected var totalGameArr:Array;
		
		protected var gameScene:GameScene;
		protected var gameObject:GameObject;
		
		public function UserCmd(_gameScene:GameScene)
		{
			gameScene = _gameScene;
			gameObject = new GameObject();
			delPicArr = new Array();
			delPointArr = new Array();
		}
		
		/**
		 * 图片删除爆炸特效
		 */
		public function delSpeEff( l:int, v:int ):void
		{
			var px:Number = l + 10, py:Number = v + 10;
			var first:SpeEffFirst = new SpeEffFirst();
			first.x = px, first.y = py, first.width = 40, first.height = 40;
			var second:SpeEffSecond = new SpeEffSecond();
			second.x = px, second.y = py, second.width = 40, second.height = 40;
			var third:SpeEffThird = new SpeEffThird();
			third.x = px, third.y = py, third.width = 40, third.height = 40;
			var forth:SpeEffForth = new SpeEffForth();
			forth.x = px, forth.y = py, forth.width = 40, forth.height = 40;
			var fifth:SpeEffFifth = new SpeEffFifth();
			fifth.x = px, fifth.y = py, fifth.width = 40, fifth.height = 40;
			var stage:Stage = Global.stage;
			gameScene.addObject( first );
			stage.setChildIndex( first, stage.numChildren-1);
			gameScene.addObject( second );
			stage.setChildIndex( second, stage.numChildren-1);
			gameScene.addObject( third );
			stage.setChildIndex( third, stage.numChildren-1);
			gameScene.addObject( forth );
			stage.setChildIndex( forth, stage.numChildren-1);
			gameScene.addObject( fifth );
			stage.setChildIndex( fifth, stage.numChildren-1);
			
			setTimeout( function():void{
				gameScene.removeObject( first );	
			}, 500);
			setTimeout( function():void{
				gameScene.removeObject( second );	
				gameScene.removeObject( forth );
			}, 100);
			setTimeout( function():void{
				gameScene.removeObject( third );	
				gameScene.removeObject( fifth );	
			}, 150);
		}
		
		/**
		 * 回溯到点的前1,2及本身遍历
		 */
		public function aheadOneTwoCur( l:int, v:int ):void
		{
			//回溯2点
			if( v >= 2 )  //行
			{
				checkLine( l, v - 2 );
				checkLine( l, v - 1 );
				checkLine( l, v );
			}
			if( l >= 2 )  //列
			{
				checkVert( l - 2, v );
				checkVert( l - 1, v );
				checkVert( l, v );
			}
			
			//回溯1点
			if( v == 1 )  
			{
				checkLine( l, v - 1 );
				checkLine( l, v );
			}
			
			if( l == 1 )  //列
			{
				checkVert( l - 1, v );
				checkVert( l, v );
			}
			
			//本点
			if( v == 0 )
			{
				checkLine( l, v );
			}
			
			if( l == 0 )  //列
			{
				checkVert( l, v );
			}
		}
		
		/**
		 * 计算点往右是否存在相邻的图片相同的个数>=3
		 * */
		public function checkLine( l:int, v:int ):void
		{
			if( 0 == totalGameArr[l][v] )
			{
				return;
			}
			var targetObj:MovieClip = totalGameArr[l][v];
			var targetObjType:String = getQualifiedClassName( targetObj );
			var flag:Boolean = true;
			var size:int = 1, vert:int = v + 1, arrLen:int, targetArrLen:int ;
			var curObj:Object, curObjType:String;
			while( flag )
			{
				if( vert > VERT - 1 )  //超出数组下标
				{
					break;
				}
				//trace("curObj = ["+l+","+vert+"]");
				curObj = totalGameArr[l][vert++];
				//如果该图片已经存在于将要被删除的数组中
				if ( 0 == curObj || delPicArr.indexOf( curObj ) != -1 || targetObjType != getQualifiedClassName(curObj))
				{
					flag=false;
				}
				else
				{
					size++;
				}
			}
			
			var arr:Array;
			if( size >= 3 )
			{
				for (var i:int = 0; i < size; i++) 
				{
					arr = [];
					arr[0] = l;
					arr[1] = v + i;
					arrLen = delPointArr.length;
					delPointArr[arrLen] = arr;
					targetArrLen = delPicArr.length;
					curObj = totalGameArr[arr[0]][arr[1]];
					if ( delPicArr.indexOf( curObj ) == -1 )
					{
						delPicArr[targetArrLen] = curObj;
					}
					//trace( "["+l+","+(v+i)+"]"+getQualifiedClassName( totalGameArr[l][v+i] ) );
				}
			}
		}
		
		/**
		 * 计算点往下是否存在相邻的图片相同的个数>=3
		 * */
		public function checkVert( l:int, v:int ):void
		{
			if( 0 == totalGameArr[l][v] )
			{
				return;
			}
			var targetObj:MovieClip = totalGameArr[l][v];
			var targetObjType:String = getQualifiedClassName( targetObj );
			var flag:Boolean = true;
			var size:int = 1, line:int = l + 1, arrLen:int, targetArrLen:int ;
			var curObj:Object, curObjType:String;
			while( flag )
			{
				if( line > LINE - 1 )  //超出数组下标
				{
					break;
				}
				//trace("curObj = ["+line+","+v+"]");
				curObj = totalGameArr[line++][v];
				if ( 0 == curObj || delPicArr.indexOf( curObj ) != -1 || targetObjType != getQualifiedClassName(curObj) )
				{
					flag = false;
				}
				else
				{
					size++;
				}
			}
			
			var arr:Array;
			if( size >= 3 )
			{
				for (var i:int = 0; i < size; i++) 
				{
					arr = [];
					arr[0] = l + i;
					arr[1] = v;
					arrLen = delPointArr.length;
					delPointArr[arrLen] = arr;
					targetArrLen = delPicArr.length;
					curObj = totalGameArr[arr[0]][arr[1]];
					if ( delPicArr.indexOf( curObj ) == -1 )
					{
						delPicArr[targetArrLen] = curObj;
					}
					//trace( "["+(l+i)+","+v+"]"+getQualifiedClassName( totalGameArr[l+i][v] ) );
				}
			}
		}
		
		/**
		 * 待删除的点
		 */
		public function get delPointArrVal():Array
		{
			return delPointArr;
		}
		
		/**
		 * 待删除的图片
		 */
		public function get delPicArrVal():Array
		{
			return delPicArr;
		}
		
		/**
		 * 设置游戏数组
		 */
		public function set totalGameArrVal(_totalGameArr:Array):void
		{
			totalGameArr = _totalGameArr;
		}
		
		/**
		 * 返回游戏数组
		 */
		public function get totalGameArrVal():Array
		{
			return totalGameArr;
		}
	}
}