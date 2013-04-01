package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class Test extends Sprite
	{
		
		public function Test()
		{
			var mc:MovieClip = new MovieClip();
			mc.graphics.beginFill(0xff9900);
			mc.graphics.drawRect(0,0,100,100);
			addChild( mc );
			
			var mc1:MovieClip = new MovieClip();
			mc1.graphics.beginFill(0x339933);
			mc1.graphics.drawRect(0,0,50,50);
			mc.addChild( mc1 );
			
			mc.addEventListener( MouseEvent.CLICK, mcClick );
			mc1.addEventListener( MouseEvent.CLICK, mc1Click );
			mc.mouseChildren =false;
		}
		
		protected function mc1Click(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			trace("mc1");
		}
		
		protected function mcClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			trace("mc");
		}
		
	}
}