package com.bullet.food
{
	import com.bullet.BulletFood;

	public class BlueBulletFood extends BulletFood
	{
		public function BlueBulletFood()
		{
			loadMyTypeFood();
		}
		
		
		override public function loadMyTypeFood():void
		{
			loadPlane( "../pic/BlueBulletFood.png" );
		}
		
	}
}