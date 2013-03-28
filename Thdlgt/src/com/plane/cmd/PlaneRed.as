package com.plane.cmd
{
	import com.controller.BasicController;
	import com.plane.PlaneCmd;
	
	public class PlaneRed extends PlaneCmd
	{
		
		public function PlaneRed( ctrl:BasicController )
		{
			super(ctrl);
			loadRedPlane();
		}
		
		public function loadRedPlane():void
		{
			var x:Number = 0, y:Number = 0;
			if ( null != super.getBitMap ) 
			{
				x = super.getBitMap.x, y = super.getBitMap.y;
				//Global._scene.removePlanes( super.getBitMap );
				Global._stageObjs.removePlanes( super );
			}
			loadPlane("../pic/PlaneRed.png", x==0?180:x, y==0?470:y);
		}
	}
}