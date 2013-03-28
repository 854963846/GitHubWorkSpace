package com.plane
{
	import com.bullet.Bullet;
	
	import flash.display.Bitmap;

	public class PlaneEnemy  implements Plane
	{
		protected var _bitMap:Bitmap;
		protected var _speed:int;
		protected var _bullet:Bullet; //子弹类型
		protected var _health:Number; //生命值
		
		public function PlaneEnemy()
		{
		}
		
		public function get bitMap():Bitmap
		{
			return _bitMap;
		}

		public function set bitMap(value:Bitmap):void
		{
			_bitMap = value;
		}

		public function get speed():int
		{
			return _speed;
		}

		public function set speed(value:int):void
		{
			_speed = value;
		}
		
		public function get bullet():Bullet
		{
			return _bullet;
		}

		
		public function get health():Number
		{
			return _health;
		}
		
		public function set health(value:Number):void
		{
			_health = value;
		}

	}
}