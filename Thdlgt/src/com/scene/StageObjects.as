package com.scene
{
	import com.bullet.BulletFood;
	import com.plane.PlaneCmd;
	import com.plane.PlaneEnemy;
	
	import flash.display.Bitmap;
	import flash.utils.Dictionary;

	public class StageObjects
	{
		private var _planes:Vector.<PlaneCmd>; //飞机容器
		private var _enemyPlanes:Vector.<PlaneEnemy>;//敌机容器
		private var _bullets:Vector.<Bitmap>;
		private var _enemyBullets:Vector.<Bitmap>;
		private var _bulletFoods:Vector.<BulletFood>;
		
		private var _enemyBulletSpeed:Dictionary;
		private var _bulletSpeed:Dictionary;
		private var _enemyBulletKill:Dictionary;
		private var _bulletKill:Dictionary;
		
		public function StageObjects()
		{
			_planes = new Vector.<PlaneCmd>(); //初始化飞机容器
			_enemyPlanes = new Vector.<PlaneEnemy>(); //初始化敌机容器
			_bullets = new Vector.<Bitmap>();
			_enemyBullets = new Vector.<Bitmap>();
			_bulletFoods = new Vector.<BulletFood>(2);
			
			_enemyBulletSpeed = new Dictionary();
			_bulletSpeed = new Dictionary();
			_enemyBulletKill = new Dictionary();
			_bulletKill = new Dictionary();
		}
		
		/**
		 * 新增一个子弹杀伤对象
		 */
		public function addEnemyBulletKill(name:String, value:int):void
		{
			_enemyBulletKill[name] = value;
		}
		
		/**
		 * 移除一个子弹杀伤对象
		 */
		public function removeEnemyBulletKill(name:String):void
		{
			delete _enemyBulletKill[name];
		}
		
		/**
		 * 新增一个子弹杀伤对象
		 */
		public function addBulletKill(name:String, value:int):void
		{
			_bulletKill[name] = value;
		}
		
		/**
		 * 移除一个子弹杀伤对象
		 */
		public function removeBulletKill(name:String):void
		{
			delete _bulletKill[name];
		}
		
		/**
		 * 新增一个子弹速度对象
		 */
		public function addBulletSpeed(name:String, value:int):void
		{
			_bulletSpeed[name] = value;
		}
		
		/**
		 * 移除一个子弹速度对象
		 */
		public function removeBulletSpeed(name:String):void
		{
			delete _bulletSpeed[name];
		}
		
		/**
		 * 新增一个子弹速度对象
		 */
		public function addEnemyBulletSpeed(name:String, value:int):void
		{
			_enemyBulletSpeed[name] = value;
		}
		
		/**
		 * 移除一个子弹速度对象
		 */
		public function removeEnemyBulletSpeed(name:String):void
		{
			delete _enemyBulletSpeed[name];
		}
		
		/**
		 * 新增一个子弹对象
		 */
		public function addEnemyBullets(obj:Bitmap):void
		{
			if (enemyBullets.indexOf(obj) != -1)
			{
				trace("该对象已经存在于敌人子弹容器");
				return;
			}
			else
			{
				var len:int=enemyBullets.length;
				enemyBullets[len] = obj;
				Global._scene.addEnemyBullets( obj );
				
				//添加子弹速度,杀伤
				var flag:Boolean = false;
				for each (var ep:PlaneEnemy in enemyPlanes) 
				{
					if( obj.name == ep.bullet.bitMap.name )
					{
						if( !bulletSpeed.hasOwnProperty( obj.name ) )
						{
							addEnemyBulletSpeed( obj.name, ep.bullet.speed );
							addEnemyBulletKill( obj.name, ep.bullet.kill );
							flag = true;
						}
					}
					if(flag)
					{
						break;
					}
				}
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
				trace( "该对象不存在于敌人子弹容器" );
				return;
			}
			else
			{
				enemyBullets.splice( id, 1 );	
				Global._scene.removeEnemyBullets( obj );
			}
		}
		
		/**
		 * 新增一个子弹对象
		 */
		public function addBullets(obj:Bitmap):void
		{
			if (bullets.indexOf(obj) != -1)
			{
				trace("该对象已经存在于子弹容器");
				return;
			}
			else
			{
				var len:int=bullets.length;
				bullets[len] = obj;
				Global._scene.addBullets( obj );
				
				//添加子弹速度,杀伤
				var flag:Boolean = false;
				for each (var p:PlaneCmd in planes) 
				{
					if( obj.name == p.bullet.bitMap.name )
					{
						if( !bulletSpeed.hasOwnProperty( obj.name ) )
						{
							addBulletSpeed( obj.name, p.bullet.speed );
							addBulletKill( obj.name, p.bullet.kill );
							flag = true;
						}
					}
					if(flag)
					{
						break;
					}
				}
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
				trace( "该对象不存在于子弹容器" );
				return;
			}
			else
			{
				bullets.splice( id, 1 );	
				Global._scene.removeBullets( obj );
			}
		}
		
		/**
		 * 新增一个飞机对象
		 */
		public function addPlanes(obj:PlaneCmd):void
		{
			if (planes.indexOf(obj) != -1)
			{
				trace("该对象已经存在于飞机容器");
				return;
			}
			else
			{
				var len:int=planes.length;
				planes[len] = obj;
				Global._scene.addPlanes( obj.getBitMap );
			}
		}
		
		/**
		 * 移除一个飞机对象
		 */
		public function removePlanes(obj:PlaneCmd):void
		{
			var id:int = planes.indexOf( obj );
			if(id == -1) 
			{
				trace( "该对象不存在于飞机容器" );
				return;
			}
			else
			{
				planes.splice( id, 1 );		
				Global._scene.removePlanes( obj.getBitMap );
			}
		}
		
		/**
		 * 新增一个飞机对象
		 */
		public function addEnemyPlanes(obj:PlaneEnemy):void
		{
			if (enemyPlanes.indexOf(obj) != -1)
			{
				trace("该对象已经存在于敌人飞机容器");
				return;
			}
			else
			{
				var len:int=enemyPlanes.length;
				enemyPlanes[len] = obj;
				Global._scene.addEnemyPlanes( obj.bitMap );
			}
		}
		
		/**
		 * 移除一个飞机对象
		 */
		public function removeEnemyPlanes(obj:PlaneEnemy):void
		{
			var id:int = enemyPlanes.indexOf( obj );
			if(id == -1) 
			{
				trace( "该对象不存在于敌人飞机容器" );
				return;
			}
			else
			{
				enemyPlanes.splice( id, 1 );
				Global._scene.removeEnemyPlanes( obj.bitMap );
			}
		}

		public function get enemyPlanes():Vector.<PlaneEnemy>
		{
			return _enemyPlanes;
		}

		public function get planes():Vector.<PlaneCmd>
		{
			return _planes;
		}

		public function get enemyBullets():Vector.<Bitmap>
		{
			return _enemyBullets;
		}

		public function get bullets():Vector.<Bitmap>
		{
			return _bullets;
		}

		public function get enemyBulletSpeed():Dictionary
		{
			return _enemyBulletSpeed;
		}

		public function get bulletSpeed():Dictionary
		{
			return _bulletSpeed;
		}

		public function get enemyBulletKill():Dictionary
		{
			return _enemyBulletKill;
		}

		public function get bulletKill():Dictionary
		{
			return _bulletKill;
		}

		public function get bulletFoods():Vector.<BulletFood>
		{
			return _bulletFoods;
		}

		public function set planes(value:Vector.<PlaneCmd>):void
		{
			_planes = value;
		}

		public function set enemyPlanes(value:Vector.<PlaneEnemy>):void
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

		public function set bulletFoods(value:Vector.<BulletFood>):void
		{
			_bulletFoods = value;
		}

		public function set enemyBulletSpeed(value:Dictionary):void
		{
			_enemyBulletSpeed = value;
		}

		public function set bulletSpeed(value:Dictionary):void
		{
			_bulletSpeed = value;
		}

		public function set enemyBulletKill(value:Dictionary):void
		{
			_enemyBulletKill = value;
		}

		public function set bulletKill(value:Dictionary):void
		{
			_bulletKill = value;
		}


	}
}