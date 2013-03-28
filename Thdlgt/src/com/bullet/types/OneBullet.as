package com.bullet.types
{
	import com.bullet.Bullet;
	import com.plane.Plane;
	
	public class OneBullet extends Bullet
	{
		public function OneBullet(plane:Plane)
		{
			super(plane);
			this._speed = 3, this._kill = 50, this._width = 5, this._height = 5;
			this.loadMyBullet();
		}
		
		override public function loadMyBullet():void
		{
			loadBullet("../pic/OneBullet.png");
		}
	}
}