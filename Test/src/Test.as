package
{
	import flash.display.Sprite;
	
	public class Test extends Sprite
	{
		private var _num:Number;
		
		public function Test()
		{
			num = 10;
		}

		public function get num():Number
		{
			return _num;
		}

		public function set num(value:Number):void
		{
			_num = value;
		}

	}
}