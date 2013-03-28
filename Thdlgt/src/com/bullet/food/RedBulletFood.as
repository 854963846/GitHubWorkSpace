package com.bullet.food
{
	import com.bullet.BulletFood;

	public class RedBulletFood extends BulletFood
	{
		public function RedBulletFood()
		{
			loadMyTypeFood();
		}
		
		
		override public function loadMyTypeFood():void
		{
			loadPlane( "../pic/RedBulletFood.png" );
		}
		
	}
}