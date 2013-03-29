package flexUnitTests
{
	import flash.utils.Dictionary;

	public class TestDictionary
	{	
		private var num:Number;
		
		[Test]
		public function testDictionary():void
		{
			var dict:Dictionary = new Dictionary(true);
			var arr:Array = [1,2,3];
			var ay:Array = [4,5,6];
			dict["a"] = arr;
			//dict["b"] = ay;
			for each(var key:* in dict) 
			{
				trace( key );
//				trace(dict[key]);
//				delete dict[key];
//				trace(dict[key]);
//				key = null;
//				trace(arr);
			}
			
			for (var i:int = 0; i < arr.length; i++) 
			{
				
			}
			
		}
		
		
		[Before]
		public function setUp():void
		{
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		
	}
}