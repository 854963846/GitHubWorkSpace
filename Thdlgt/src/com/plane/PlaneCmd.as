package com.plane
{
	import com.bullet.Bullet;
	import com.bullet.BulletFactory;
	import com.cmd.HitCmd;
	import com.controller.BasicController;
	import com.greensock.TweenLite;
	import com.loader.InfoLoader;
	import com.plane.cmd.PlaneLoader;
	import com.utils.Utils;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	public class PlaneCmd implements Plane
	{
		//private var infoLoader:InfoLoader;
		private var loader:Loader;
		private var bitMap:Bitmap;
		private var _bitMapX:Number, _bitMapY:Number;
		private var _width:int = 30, _height:int = 30;
		private var _bulletType:int = 1; //1初始子弹， 2增强子弹， 3极致子弹
		private var planeLoader:PlaneLoader;
		private var _bomb:Bitmap;
		private var hitCmd:HitCmd = new HitCmd();
		private var _shootMusic:Sound = new Sound(), 
			_bombMusic:Sound = new Sound();
		private var _shootMusicChannel:SoundChannel = new SoundChannel(),
			_bombMusicChannel:SoundChannel = new SoundChannel();
		
		protected var _url:String;
		protected var _health:Number = 100; //生命值
		protected var _ctrl:BasicController;
		protected var _speed:int = 5;
		protected var _bullet:Bullet;
		private var blt:Bitmap;
		
		public function PlaneCmd( ctrl:BasicController )
		{
			_ctrl = ctrl;
			ctrl.planCmd = this;
			
			planeLoader = new PlaneLoader();
		}
		
		/**
		 * 加载飞机图片
		 */
		protected function loadPlane( url:String, x:Number, y:Number ):void
		{
			_url = url;
			bitMapX = x, bitMapY = y;
			//infoLoader = new InfoLoader();		
			//加载飞机
			loader = InfoLoader.loadInfo( url );
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, loadCmp );
			
			_shootMusic.load(new URLRequest( "../music/shoot.mp3" ));
			_bombMusic.load(new URLRequest( "../music/bomb.mp3" ));
			
			//根据飞机生成相应的子弹
			_bullet = BulletFactory.getDefineBullet(this, url, _bulletType ); 
		}	

		protected function loadCmp(e:Event):void
		{
			bitMap = Bitmap(loader.content);
			bitMap.width = _width, bitMap.height = _height;
			bitMap.y = bitMapY, bitMap.x = bitMapX;
			bitMap.alpha = 0;
			//Global._scene.addPlanes( bitMap );
			
			if( 180==bitMapX && bitMapY == 470)
			{
				moveIn();
			}
		}	
		
		/**
		 * 初始化游戏时候飞机进入
		 */
		public function moveIn():void
		{
			Global._stageObjs.addPlanes( this ); //在对象数组中保存
			TweenLite.to( bitMap, 0.3, {x:bitMapX, y:370, alpha:1});
			Global._stage.addEventListener( Event.ENTER_FRAME, _ctrl.movePlane );
		}
	
		/**
		 * 射击
		 */
		public function shoot():void
		{
			blt = bullet.bitMap;
			if( null!= blt )
			{
				blt = Utils.cloneBitMap( blt );
				if( _url.toLowerCase().indexOf("red") != -1 )
				{
					blt.x = bitMap.x + (bitMap.width- bullet.bitMap.width)*0.5, blt.y = bitMap.y-bullet.bitMap.height;	
				}
				else if( _url.toLowerCase().indexOf("blu") != -1 )
				{
					blt.x = bitMap.x + (bitMap.width- bullet.bitMap.width)*0.4, blt.y = bitMap.y-50;
				}
				
				blt.name = bullet.bitMap.name;
				Global._stageObjs.addBullets( blt );
				_shootMusicChannel = _shootMusic.play();
			}
		}
		
		/**
		 * 炸弹
		 */
		public function bomb():void
		{
			if( Global._scene.bombBmps.indexOf( _bomb ) == -1 )
			{
				_bomb = planeLoader.planesDict["bomb"];
				_bomb.width = 13, _bomb.height = 13;
				_bomb.x = bitMap.x + (bitMap.width- bullet.bitMap.width)*0.5, 
					_bomb.y = bitMap.y - bullet.bitMap.height;
				
				Global._scene.addBombBmps( _bomb );
				TweenLite.to( _bomb, 0.8, {x:185, y:250, width:3, height:3} );
				
				var timer:Timer = new Timer(1000, 1);
				timer.addEventListener(TimerEvent.TIMER, moveBomb);
				timer.start();
			}
		}
		
		protected function moveBomb(e:TimerEvent):void
		{
			var bombArr:Array = planeLoader.bombArr;
			var one:Bitmap = bombArr[1];
			one.width = 300, one.height = 300;
			one.x = 45, one.y = 100 ;
			Global._scene.addBombBmps( one );
			
			var timer:Timer = new Timer(850,2);
			timer.addEventListener( TimerEvent.TIMER, bombScreen );
			timer.start();
		}		
		
		protected function bombScreen(event:TimerEvent):void
		{
			_bombMusicChannel = _bombMusic.play();
			removeEnemyThings();
			var bombArr:Array = planeLoader.bombArr;
			var one:Bitmap = bombArr[0],two:Bitmap = bombArr[1], three:Bitmap = bombArr[2], four:Bitmap = bombArr[3],
				five:Bitmap = bombArr[4], six:Bitmap = bombArr[5], seven:Bitmap = bombArr[6],
				eight:Bitmap = bombArr[7], night:Bitmap = bombArr[8];
			
			three = getCorePoint( three, two ), 
			four = getCorePoint( four, two ), five = getCorePoint( five, two ),
			six = getCorePoint( six, two ), seven = getCorePoint( seven, two ),
			eight = getCorePoint( eight, two ), night = getCorePoint( night, two );
			
			one.width = 100, one.height=600, one.x = 0, one.y = -50, one.alpha=0.5;
				
			var rt:Bitmap = Utils.cloneBitMap( two );
			rt.width = 100, rt.height = 100;
			rt.x = 50*Math.ceil(Math.random()*6), rt.y = 50*Math.ceil(Math.random()*8);
			Global._scene.addBombBmps( one );
			Global._scene.addBombBmps( rt );
			Global._scene.addBombBmps( three );
			setTimeout( function():void{
				Global._scene.removeBombBmps( rt );
				Global._scene.removeBombBmps( three );
				
				Global._scene.removeBombBmps( one );
				one.width = 100, one.height=600, one.x = 100, one.y = -50, one.alpha=0.8;
				Global._scene.addBombBmps( one );
				rt.x = 50*Math.ceil(Math.random()*6), rt.y = 50*Math.ceil(Math.random()*8);
				Global._scene.addBombBmps( rt);
				Global._scene.addBombBmps( four );
			},100 );
			setTimeout( function():void{
				Global._scene.removeBombBmps( rt );
				Global._scene.removeBombBmps( four );
				Global._scene.removeBombBmps( one );
				one.width = 100, one.height=600, one.x = 200, one.y = -50, one.alpha=0.5;
				Global._scene.addBombBmps( one );
				
				rt.x = 50*Math.ceil(Math.random()*6), rt.y = 50*Math.ceil(Math.random()*8);
				Global._scene.addBombBmps( rt );
				Global._scene.addBombBmps( five );
			},200 );
			setTimeout( function():void{
				Global._scene.removeBombBmps( rt );
				Global._scene.removeBombBmps( five );
				Global._scene.removeBombBmps( one );
				one.width = 100, one.height=600, one.x = 300, one.y = -50, one.alpha=0.8;
				Global._scene.addBombBmps( one );
				
				rt.x = 50*Math.ceil(Math.random()*6), rt.y = 50*Math.ceil(Math.random()*8);
				Global._scene.addBombBmps( two );
				Global._scene.addBombBmps( six );
			},300 );
			setTimeout( function():void{
				Global._scene.removeBombBmps( rt );
				Global._scene.removeBombBmps( six );
				Global._scene.removeBombBmps( one );
				one.width = 100, one.height=600, one.x = 400, one.y = -50, one.alpha=0.8;
				Global._scene.addBombBmps( one );
				
				rt.x = 50*Math.ceil(Math.random()*6), rt.y = 50*Math.ceil(Math.random()*8);
				Global._scene.addBombBmps( rt );
				Global._scene.addBombBmps( seven );
			},400 );
			setTimeout( function():void{
				Global._scene.removeBombBmps( rt );
				Global._scene.removeBombBmps( seven );
				Global._scene.removeBombBmps( one );
				one.width = 100, one.height=600, one.x = 600, one.y = -50, one.alpha=0.5;
				Global._scene.addBombBmps( one );
				
				rt.x = 50*Math.ceil(Math.random()*6), rt.y = 50*Math.ceil(Math.random()*8);
				Global._scene.addBombBmps( rt );
				Global._scene.addBombBmps( eight );
			},500 );
			setTimeout( function():void{
				Global._scene.removeBombBmps( rt );
				Global._scene.removeBombBmps( eight );
				Global._scene.removeBombBmps( one );
				one.width = 100, one.height=600, one.x = 100, one.y = -50, one.alpha=0.8;
				Global._scene.addBombBmps( one );
				
				rt.x = 50*Math.ceil(Math.random()*6), rt.y = 50*Math.ceil(Math.random()*8);
				Global._scene.addBombBmps( rt );
				Global._scene.addBombBmps( night );
			},600 );
			setTimeout( function():void{
				Global._scene.removeBombBmps( one );
				Global._scene.removeBombBmps( rt );
				Global._scene.removeBombBmps( night );
				Global._scene.removeBombBmps( two );
				Global._scene.removeBombBmps( _bomb );
			},700 );
			
		}		
		
		/**
		 * 移除敌方的飞机跟子弹 
		 * 
		 */		
		private function removeEnemyThings():void
		{
			var enemyPlanes:Vector.<PlaneEnemy> = Global._stageObjs.enemyPlanes;
			var enemyBullets:Vector.<Bitmap> = Global._stageObjs.enemyBullets;
			var enemyBulletSpeed:Dictionary = Global._stageObjs.enemyBulletSpeed;
			var enemyBulletKill:Dictionary = Global._stageObjs.enemyBulletKill;
			//降血
			for each (var plane:PlaneEnemy in enemyPlanes) 
			{
				if( plane.bitMap.x>=0 && plane.bitMap.x<=350 
					&& plane.bitMap.y>=0 && plane.bitMap.x<=450 )
				{
					plane.health = plane.health - 1000;
				}
			}
			
			//飞机爆炸
			for (var i:int = enemyPlanes.length-1; i >= 0; i--) 
			{
				if( enemyPlanes[i].health <= 0 )
				{
					hitCmd.kills( enemyPlanes[i].bitMap.width, enemyPlanes[i].bitMap.height, enemyPlanes[i].bitMap.x, enemyPlanes[i].bitMap.y );
					Global._stageObjs.removeEnemyPlanes( enemyPlanes[i] );
				}
			}
			
			for each (var bitMap:Bitmap in enemyBullets) 
			{
				Global._stageObjs.removeEnemyBullets( enemyBullets[0] );
			}
			
			for each (var key:String in enemyBulletSpeed) 
			{
				delete enemyBulletSpeed[key];
			}
			
			for each (var key:String in enemyBulletKill) 
			{
				delete enemyBulletKill[key];
			}
			
		}
		
		public function getCorePoint(initBmp:Bitmap, targetBmp:Bitmap):Bitmap
		{
			initBmp.width = 400, initBmp.height = 400;
			initBmp.x = targetBmp.x + (targetBmp.width-initBmp.width)*0.5, 
			initBmp.y = targetBmp.y + (targetBmp.height-initBmp.height)*0.5;
			return initBmp;
		}
		
		/**
		 * 改变飞机
		 */
		public function changePlaneStyle(type:String):void
		{
			if( "red" == type.toLowerCase() )
			{
				var curBitMap:Bitmap = planeLoader.planesDict["red"];
				bitMap.bitmapData = curBitMap.bitmapData;
				_url = "red";
			}
			else if( "blu" == type.toLowerCase() )
			{
				var curBitMap:Bitmap = planeLoader.planesDict["blu"];
				bitMap.bitmapData = curBitMap.bitmapData;
				_url = "blu";
			}
		}
		
		
		public function get getBitMap():Bitmap
		{
			return bitMap;
		}
		
		public function get getSpeed():int
		{
			return _speed;
		}

		public function get bulletType():int
		{
			return _bulletType;
		}

		public function set bulletType(value:int):void
		{
			_bulletType = value;
			_bullet = BulletFactory.getDefineBullet(this, _url, _bulletType ); 
		}

		public function get bullet():Bullet
		{
			return _bullet;
		}

		public function set bullet(value:Bullet):void
		{
			_bullet = value;
		}

		public function get health():Number
		{
			return _health;
		}

		public function set health(value:Number):void
		{
			_health = value;
		}

		public function get ctrl():BasicController
		{
			return _ctrl;
		}

		public function get bitMapX():Number
		{
			return _bitMapX;
		}

		public function set bitMapX(value:Number):void
		{
			_bitMapX = value;
		}

		public function get bitMapY():Number
		{
			return _bitMapY;
		}

		public function set bitMapY(value:Number):void
		{
			_bitMapY = value;
		}

		public function get url():String
		{
			return _url;
		}

		public function set url(value:String):void
		{
			_url = value;
		}


	}
}