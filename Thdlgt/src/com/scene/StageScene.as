package com.scene
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Stage;

	public class StageScene
	{
		
		private var _stagePics:Vector.<DisplayObject>; //舞台容器
		private var _maps:Vector.<Bitmap>; //地图容器
		private var _planes:Vector.<Bitmap>; //飞机容器
		private var _enemyPlanes:Vector.<Bitmap>;//敌机容器
		private var _bullets:Vector.<Bitmap>;
		private var _enemyBullets:Vector.<Bitmap>;
		
		private var _brokenBmps:Vector.<Bitmap>;
		private var _bulletFoodBmps:Vector.<Bitmap>;
		private var _bombBmps:Vector.<Bitmap>;
		private var _countBmps:Vector.<Bitmap>;
		private var _gameCmdBmps:Vector.<MovieClip>;
		
		public function StageScene( stage:Stage )
		{
			Global._stage = stage;
			
			stagePics = new Vector.<DisplayObject>(); //初始化舞台容器
			maps = new Vector.<Bitmap>(); //初始化地图容器
			_planes = new Vector.<Bitmap>(); //初始化飞机容器
			_enemyPlanes = new Vector.<Bitmap>(); //初始化敌机容器
			_bullets = new Vector.<Bitmap>();
			_enemyBullets = new Vector.<Bitmap>();
			_brokenBmps = new Vector.<Bitmap>();
			_bulletFoodBmps = new Vector.<Bitmap>();
			_bombBmps = new Vector.<Bitmap>();
			_countBmps = new Vector.<Bitmap>();
			_gameCmdBmps = new Vector.<MovieClip>();
		}
		
		/**
		 * 新增一个子弹对象
		 */
		public function addGameCmdBmps(obj:MovieClip):void
		{
			if (_gameCmdBmps.indexOf(obj) != -1)
			{
				trace("该图片已经存在于容器");
				return;
			}
			else
			{
				var len:int=_gameCmdBmps.length;
				_gameCmdBmps[len] = obj;
				addToStage( obj, stagePics.length );
			}
		}
		
		/**
		 * 移除一个子弹对象
		 */
		public function removeGameCmdBmps(obj:MovieClip):void
		{
			var id:int = _gameCmdBmps.indexOf( obj );
			if(id == -1) 
			{
				trace( "该图片不存在于容器" );
				return;
			}
			else
			{
				_gameCmdBmps.splice( id, 1 );		
				removeFromStage( obj );			
			}
		}
		
		
		
		/**
		 * 新增一个子弹对象
		 */
		public function addCountBmps(obj:Bitmap):void
		{
			if (_countBmps.indexOf(obj) != -1)
			{
				trace("该图片已经存在于容器");
				return;
			}
			else
			{
				var len:int=_countBmps.length;
				_countBmps[len] = obj;
				addToStage( obj, stagePics.length );
			}
		}
		
		/**
		 * 移除一个子弹对象
		 */
		public function removeCountBmps(obj:Bitmap):void
		{
			var id:int = _countBmps.indexOf( obj );
			if(id == -1) 
			{
				trace( "该图片不存在于容器" );
				return;
			}
			else
			{
				_countBmps.splice( id, 1 );		
				removeFromStage( obj );			
			}
		}
		
		/**
		 * 新增一个子弹对象
		 */
		public function addBombBmps(obj:Bitmap):void
		{
			if (_bombBmps.indexOf(obj) != -1)
			{
				//trace("该图片已经存在于容器");
				return;
			}
			else
			{
				var len:int=_bombBmps.length;
				_bombBmps[len] = obj;
				addToStage( obj, stagePics.length );
			}
		}
		
		/**
		 * 移除一个子弹对象
		 */
		public function removeBombBmps(obj:Bitmap):void
		{
			var id:int = _bombBmps.indexOf( obj );
			if(id == -1) 
			{
				//trace( "该图片不存在于容器" );
				return;
			}
			else
			{
				_bombBmps.splice( id, 1 );		
				removeFromStage( obj );			
			}
		}
		
		/**
		 * 新增一个子弹食物对象
		 */
		public function addBulletFoodBmps(obj:Bitmap):void
		{
			if (_bulletFoodBmps.indexOf(obj) != -1)
			{
				trace("该图片已经存在于容器");
				return;
			}
			else
			{
				var len:int=_bulletFoodBmps.length;
				_bulletFoodBmps[len] = obj;
				addToStage( obj, stagePics.length );
			}
		}
		
		/**
		 * 移除一个子弹食物对象
		 */
		public function removeBulletFoodBmps(obj:Bitmap):void
		{
			var id:int = _bulletFoodBmps.indexOf( obj );
			if(id == -1) 
			{
				trace( "该图片不存在于容器" );
				return;
			}
			else
			{
				_bulletFoodBmps.splice( id, 1 );		
				removeFromStage( obj );			
			}
		}
		
		/**
		 * 新增一个子弹对象
		 */
		public function addBrokenBmps(obj:Bitmap):void
		{
			if (brokenBmps.indexOf(obj) != -1)
			{
				trace("该图片已经存在于容器");
				return;
			}
			else
			{
				var len:int=brokenBmps.length;
				brokenBmps[len] = obj;
				addToStage( obj, stagePics.length );
			}
		}
		
		/**
		 * 移除一个子弹对象
		 */
		public function removeBrokenBmps(obj:Bitmap):void
		{
			var id:int = brokenBmps.indexOf( obj );
			if(id == -1) 
			{
				trace( "该图片不存在于容器" );
				return;
			}
			else
			{
				brokenBmps.splice( id, 1 );		
				removeFromStage( obj );			
			}
		}
		
		
		/**
		 * 新增一个子弹对象
		 */
		public function addEnemyBullets(obj:Bitmap):void
		{
			if (enemyBullets.indexOf(obj) != -1)
			{
				trace("该敌方子弹已经存在于容器");
				return;
			}
			else
			{
				var len:int=enemyBullets.length;
				enemyBullets[len] = obj;
				addToStage( obj, stagePics.length );
			}
		}
		
		/**
		 * 移除一个子弹对象
		 */
		public function removeEnemyBullets(obj:Bitmap):void
		{
			var id:int = enemyBullets.indexOf( obj );
			if(id == -1) 
			{
				trace( "该敌方子弹不存在于容器" );
				return;
			}
			else
			{
				enemyBullets.splice( id, 1 );		
				removeFromStage( obj );			
			}
		}
		
		/**
		 * 新增一个子弹对象
		 */
		public function addBullets(obj:Bitmap):void
		{
			if (bullets.indexOf(obj) != -1)
			{
				trace("该子弹已经存在于容器");
				return;
			}
			else
			{
				var len:int=bullets.length;
				bullets[len] = obj;
				addToStage( obj, stagePics.length );
			}
		}
		
		/**
		 * 移除一个子弹对象
		 */
		public function removeBullets(obj:Bitmap):void
		{
			var id:int = bullets.indexOf( obj );
			if(id == -1) 
			{
				trace( "该子弹不存在于容器" );
				return;
			}
			else
			{
				bullets.splice( id, 1 );		
				removeFromStage( obj );			
			}
		}
		
		/**
		 * 新增一个敌机对象
		 */
		public function addEnemyPlanes(obj:Bitmap):void
		{
			if (enemyPlanes.indexOf(obj) != -1)
			{
				trace("该敌机已经存在于容器");
				return;
			}
			else
			{
				var len:int=enemyPlanes.length;
				enemyPlanes[len] = obj;
				addToStage( obj, stagePics.length );
			}
		}
		
		/**
		 * 移除一个敌机对象
		 */
		public function removeEnemyPlanes(obj:Bitmap):void
		{
			var id:int = enemyPlanes.indexOf( obj );
			if(id == -1) 
			{
				trace( "该敌机不存在于容器" );
				return;
			}
			else
			{
				enemyPlanes.splice( id, 1 );		
				removeFromStage( obj );			
			}
		}
		
		/**
		 * 新增一个飞机对象
		 */
		public function addPlanes(obj:Bitmap):void
		{
			if (planes.indexOf(obj) != -1)
			{
				trace("该飞机已经存在于容器");
				return;
			}
			else
			{
				var len:int=planes.length;
				planes[len] = obj;
				addToStage( obj, stagePics.length );
			}
		}
		
		/**
		 * 移除一个飞机对象
		 */
		public function removePlanes(obj:Bitmap):void
		{
			var id:int = planes.indexOf( obj );
			if(id == -1) 
			{
				trace( "该飞机不存在于容器" );
				return;
			}
			else
			{
				planes.splice( id, 1 );		
				removeFromStage( obj );			
			}
		}
		
		/**
		 * 新增一个地图对象
		 */
		public function addMaps(obj:Bitmap):void
		{
			if (maps.indexOf(obj) != -1)
			{
				trace("该地图已经存在于容器");
				return;
			}
			else
			{
				var len:int=maps.length;
				maps[len] = obj;
				addToStage( obj, 0 );
				//Global._stage.addChildAt(obj, 0);
			}
		}
		
		/**
		 * 移除一个地图对象
		 */
		public function removeMaps(obj:Bitmap):void
		{
			var id:int = maps.indexOf( obj );
			if(id == -1) 
			{
				trace( "该地图不存在于容器" );
				return;
			}
			else
			{
				maps.splice( id, 1 );		
				//Global._stage.removeChild(obj);
				removeFromStage( obj );			
			}
		}
		
		/**
		 * 保存到舞台
		 */
		public function addToStage(obj:DisplayObject, index:int ):void
		{
			if(stagePics.indexOf(obj) != -1) 
			{
				trace( "该对象已经存在于舞台" );
				return;
			}
			else
			{
				stagePics[stagePics.length] = obj;
				Global._stage.addChildAt( obj, index );
			}
		}
		
		/**
		 * 移除一个舞台对象
		 */
		public function removeFromStage(obj:DisplayObject):void
		{
			var id:int = stagePics.indexOf( obj );
			if(id == -1) 
			{
				trace( "该对象不存在于舞台" );
				return;
			}
			else
			{
				stagePics.splice( id, 1 );		
				Global._stage.removeChild( obj );				
			}
		}

		public function get bullets():Vector.<Bitmap>
		{
			return _bullets;
		}

		public function get enemyBullets():Vector.<Bitmap>
		{
			return _enemyBullets;
		}

		public function get planes():Vector.<Bitmap>
		{
			return _planes;
		}

		public function get enemyPlanes():Vector.<Bitmap>
		{
			return _enemyPlanes;
		}

		public function get brokenBmps():Vector.<Bitmap>
		{
			return _brokenBmps;
		}

		public function get bulletFoodBmps():Vector.<Bitmap>
		{
			return _bulletFoodBmps;
		}

		public function get bombBmps():Vector.<Bitmap>
		{
			return _bombBmps;
		}

		public function set bombBmps(value:Vector.<Bitmap>):void
		{
			_bombBmps = value;
		}

		public function get countBmps():Vector.<Bitmap>
		{
			return _countBmps;
		}

		public function set countBmps(value:Vector.<Bitmap>):void
		{
			_countBmps = value;
		}

		public function get stagePics():Vector.<DisplayObject>
		{
			return _stagePics;
		}

		public function set stagePics(value:Vector.<DisplayObject>):void
		{
			_stagePics = value;
		}

		public function get maps():Vector.<Bitmap>
		{
			return _maps;
		}

		public function set maps(value:Vector.<Bitmap>):void
		{
			_maps = value;
		}

		public function set planes(value:Vector.<Bitmap>):void
		{
			_planes = value;
		}

		public function set enemyPlanes(value:Vector.<Bitmap>):void
		{
			_enemyPlanes = value;
		}

		public function set bullets(value:Vector.<Bitmap>):void
		{
			_bullets = value;
		}

		public function set enemyBullets(value:Vector.<Bitmap>):void
		{
			_enemyBullets = value;
		}

		public function set brokenBmps(value:Vector.<Bitmap>):void
		{
			_brokenBmps = value;
		}

		public function set bulletFoodBmps(value:Vector.<Bitmap>):void
		{
			_bulletFoodBmps = value;
		}

		public function get gameCmdBmps():Vector.<MovieClip>
		{
			return _gameCmdBmps;
		}

		public function set gameCmdBmps(value:Vector.<MovieClip>):void
		{
			_gameCmdBmps = value;
		}


	}
}