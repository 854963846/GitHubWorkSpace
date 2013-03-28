package com.bullet.types
{
	import com.bullet.Bullet;
	import com.plane.Plane;
	
	public class RedThreeBullet extends Bullet
	{
		public function RedThreeBullet(plane:Plane)
		{
			super(plane);
			this._speed = 15, this._kill = 70, this._width = 13, this._height = 13;
			this.loadMyBullet();
		}
		
		override public function loadMyBullet():void
		{
			loadBullet("../pic/ThreeRedBullet.png");
		}
	}
}