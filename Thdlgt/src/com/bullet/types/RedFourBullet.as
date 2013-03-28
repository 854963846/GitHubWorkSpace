package com.bullet.types
{
	import com.bullet.Bullet;
	import com.plane.Plane;
	
	public class RedFourBullet extends Bullet
	{
		public function RedFourBullet(plane:Plane)
		{
			super(plane);
			this._speed = 15, this._kill = 100, this._width = 15, this._height = 15;
			this.loadMyBullet();
		}
		
		override public function loadMyBullet():void
		{
			loadBullet("../pic/FourRedBullet.png");
		}
	}
}