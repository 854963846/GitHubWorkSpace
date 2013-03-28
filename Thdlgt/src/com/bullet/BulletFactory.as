package com.bullet
{
	import com.bullet.types.BlueOneBullet;
	import com.bullet.types.BlueThreeBullet;
	import com.bullet.types.BlueTwoBullet;
	import com.bullet.types.OneBullet;
	import com.bullet.types.RedFourBullet;
	import com.bullet.types.RedThreeBullet;
	import com.bullet.types.RedTwoBullet;
	import com.plane.Plane;

	public class BulletFactory
	{
		
		public function BulletFactory()
		{
		}
		
		public static function getDefineBullet(plane:Plane, planUrl:String, bulletType:int):Bullet
		{
			if( planUrl.toLowerCase().indexOf("red") != -1 )
			{
				if(1==bulletType)
				{
					return new RedTwoBullet(plane);
				}
				else if(2==bulletType)
				{
					return new RedThreeBullet(plane);
				}
				else if(3==bulletType)
				{
					return new RedFourBullet(plane);
				}
			}
			
			if( planUrl.toLowerCase().indexOf("blu") != -1 )
			{
				if(1==bulletType)
				{
					return new BlueOneBullet(plane);
				}
				else if(2==bulletType)
				{
					return new BlueTwoBullet(plane);
				}
				else if(3==bulletType)
				{
					return new BlueThreeBullet(plane);
				}
			}
			
			if( planUrl.toLowerCase().indexOf("enemyplane") != -1 ||  planUrl.toLowerCase().indexOf("boss.png") != -1)
			{
				if(0==bulletType)
				{
					return new OneBullet(plane);
				}
			}
			
			return new RedTwoBullet(plane); 
		}
	}
}