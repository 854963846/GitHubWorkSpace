package com.controller
{
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.KeyboardEvent;

	public class KeyBoardController extends BasicController
	{
		private var stageWidth:int = Global._stage.stageWidth, stageHeight:int = Global._stage.stageHeight;
		private var width:int, height:int;
		private var px:Number, py:Number;
		private var bitMap:Bitmap;
		private var speed:Number;
		private var _directionArr:Vector.<int> = new Vector.<int>(6); // left, up, right, down, fire, bigFire
		
		
		public function KeyBoardController()
		{
			super();
			setUpKeyBoardListener();
		}
		
		override public function setUpKeyBoardListener():void
		{
			Global._stage.addEventListener( KeyboardEvent.KEY_DOWN, appendKeyCode );
			Global._stage.addEventListener( KeyboardEvent.KEY_UP, removeKeyCode );
		}		
		
		/**
		 * 移除按键数组
		 */
		public function removeKeyCode(e:KeyboardEvent):void
		{
			if(null==bitMap) 
			{
				bitMap.rotationY = 0;
			}
			switch( e.keyCode )
			{
				case 37: directionArr[0] = 0;break;  //left
				case 38: directionArr[1] = 0;break;  //up
				case 39: directionArr[2] = 0;break;  //right
				case 40: directionArr[3] = 0;break;  //down
				case 32: directionArr[4] = 0;break;  //space
				case 90: directionArr[5] = 0;break;  // Z
				default:break;
			}
		}
		
		/**
		 * 保存按键数组
		 */
		public function appendKeyCode(e:KeyboardEvent):void
		{
			switch( e.keyCode )
			{
				case 37: directionArr[0] = 37;break;  //left
				case 38: directionArr[1] = 38;break;  //up
				case 39: directionArr[2] = 39;break;  //right
				case 40: directionArr[3] = 40;break;  //down
				case 32: directionArr[4] = 32;break;  //space
				case 90: directionArr[5] = 90;break;  // Z
				default:break;
			}
		}		
		
		override public function movePlane(e:Event):void
		{
			bitMap = planCmd.getBitMap as Bitmap;
			width = bitMap.width, height = bitMap.height;
			speed = planCmd.getSpeed;
			px = bitMap.x, py = bitMap.y;
			
			for (var i:int = 0; i < 6; i++) 
			{
				switch( directionArr[i] )
				{
					case 37: moveLeft();break;
					case 38: moveUp();break;
					case 39: moveRight();break;
					case 40: moveDown();break;
					case 32: planCmd.shoot();break;  
					case 90: directionArr[5]=0;planCmd.bomb();break;  
					default:break;
				}
			}
		}
		
//飞机移动方向		
		private function moveDown():void
		{
			if(py + planCmd.getSpeed <= stageHeight - height)
			{
				bitMap.y += speed;
			}
		}
		
		private function moveRight():void
		{
			bitMap.rotationY = -20;
			if(px + planCmd.getSpeed <= stageWidth - width)
			{
				bitMap.x += speed;
			}
		}
		
		private function moveUp():void
		{
			if(py>0)
			{
				bitMap.y -= speed;
			}
		}
		
		private function moveLeft():void
		{
			bitMap.rotationY = 20;
			if(px>0)
			{
				bitMap.x -= speed;
			}
		}

		public function set directionArr(value:Vector.<int>):void
		{
			_directionArr = value;
		}

		public function get directionArr():Vector.<int>
		{
			return _directionArr;
		}

		
	}
}