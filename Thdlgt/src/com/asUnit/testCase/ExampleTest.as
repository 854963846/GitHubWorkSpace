package com.asUnit.testCase
{
	import com.asUnit.Example;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;

	public class ExampleTest
	{		
		private var exmple:Example;
		private var thdLgt:ThdLgt;
		
		[Before]
		public function setUp():void
		{
			exmple = new Example();
			trace("3");
		}
		
		[After]
		public function tearDown():void
		{
			trace("4");
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
			trace("1");
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
			trace("2");
		}
		
		[Test]
		public function testAdd():void
		{
			assertEquals( "fuck....", 3, exmple.add( 1, 2 ) );
		}
		
//		[Test]
//		public function testMain():void
//		{
//			thdLgt = new ThdLgt();
//			assertNotNull( thdLgt.test() );
//		}
	}
}