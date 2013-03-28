package com.bullet.types
{
	import com.bullet.Bullet;
	import com.plane.Plane;
	
	public class BlueTwoBullet extends Bullet
	{
		public function BlueTwoBullet(plane:Plane)
		{
			super(plane);
			this._speed = 15, this._kill = 50, this._width = 10, this._height = 10;
			this.loadMyBullet();
		}
		
		override public function loadMyBullet():void
		{
			loadBullet("../pic/TwoBlueBullet.png");
		}
	}
}