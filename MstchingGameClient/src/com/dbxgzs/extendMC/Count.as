package com.dbxgzs.extendMC
{
	import com.dbxgzs.object.GameObject;
	import com.dbxgzs.scene.GameScene;
	
	import flash.display.MovieClip;

	public class Count
	{
		private var countNum:Array = new Array(5); //记分数组
		public var countContainer:Array = new Array(); //积分显示对象
		
		private var countEnemyNums:Array = new Array(5);
		private var countEnemyContainer:Array = new Array();
		
		private var gameScene:GameScene;

		public function Count(_gameScene:GameScene)
		{
			gameScene = _gameScene;
		}
		
		public function countAppend(num:Array, container:Array, px:int):void
		{
			num = new Array(5);
			var gameObject:GameObject = new GameObject();
			for (var i:int = 0; i < num.length; i++) 
			{
				var obj:MovieClip = gameObject.getCount( 0 );
				obj.width = 20, obj.height = 20, obj.x = 25 + px, obj.y = 50 + 50*( i + 1 );
				gameScene.addExtendsObject( obj );
				container[container.length] = obj;
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
		 * 积分操作 
		 */
		public function appendCount():void
		{
			countAppend( countNum, countContainer, 460 );
		}	
		
		/**
		 * 积分变化
		 */
		public function changeCount(len:uint):void
		{
			countNum = countChange( len, countNum);
			
			for each (var num:MovieClip in countContainer) 
			{
				gameScene.removeExtendsObject( num );
			}
			countContainer = new Array(5);			
			
			var px:int = 460;
			var gameObject:GameObject = new GameObject();
			for (var i:int = 0; i < countNum.length; i++) 
			{
				var obj:MovieClip = gameObject.getCount( countNum[i] );
				obj.width = 20, obj.height = 20, obj.x = 25 + px, obj.y = 50 + 50*( i + 1 );
				gameScene.addExtendsObject( obj );
				countContainer[countContainer.length] = obj;
			}
		}
		
		/**
		 * 积分操作 
		 */
		public function appendEnemyCount():void
		{
			countAppend( countEnemyNums, countEnemyContainer,935 );
		}	
		
		/**
		 * 积分变化
		 */
		public function changeEnemyCount(len:uint):void
		{
			countEnemyNums = countChange( len, countEnemyNums);
			
			for each (var num:MovieClip in countEnemyContainer) 
			{
				gameScene.removeExtendsObject( num );
			}
			countEnemyContainer = new Array(5);			
			var gameObject:GameObject = new GameObject();
			var px:int = 960;
			for (var i:int = 0; i < countEnemyNums.length; i++) 
			{
				var obj:MovieClip = gameObject.getCount( countEnemyNums[i] );
				obj.width = 20, obj.height = 20, obj.x = px, obj.y = 50 + 50*( i + 1 );
				gameScene.addExtendsObject( obj );
				countEnemyContainer[countEnemyContainer.length] = obj;
			}
		}
	}
}