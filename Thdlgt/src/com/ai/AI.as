package com.ai
{
	
	import com.ai.type.AIFifthType;
	import com.ai.type.AIFirstType;
	import com.ai.type.AIForthType;
	import com.ai.type.AISecondType;
	import com.ai.type.AIThirdType;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class AI
	{
		private var firstTypeAI:AIFirstType;
		private var secondTypeAI:AISecondType;
		private var thirdTypeAI:AIThirdType;
		private var forthTypeAI:AIForthType;
		private var fifthTypeAI:AIFifthType;
		
		private var _time:int = 0;
		private var _timer:Timer;
		
		public function AI()
		{
			loadEnemyPlane();
		}
		
		private function loadEnemyPlane():void
		{
			firstTypeAI = new AIFirstType();
			secondTypeAI = new AISecondType();
			thirdTypeAI = new AIThirdType();
			forthTypeAI = new AIForthType();
			fifthTypeAI = new AIFifthType();
		}
		
		public function startAI(e:TimerEvent):void
		{
			timer = new Timer(2000,0);
			timer.addEventListener(TimerEvent.TIMER, createRandomAI );
			timer.start();
		}
		
		protected function createRandomAI(event:TimerEvent):void
		{
			var timer:Timer = event.currentTarget as Timer;
			if( Global._stageObjs.enemyPlanes.length == 0 ){
				//switch(time++)
					//switch(randomAI())
					switch(3)
				{
					case 1: firstTypeAI.ai(); break;
					case 2: secondTypeAI.ai(); break;
					case 3: thirdTypeAI.ai(); break;
					case 4: forthTypeAI.ai(); break;
					case 5: fifthTypeAI.ai(); break;
					default:break;
				}
			}
		}
		
		private function randomAI():int
		{
			return Math.floor(Math.random()*4);
		}

		public function get time():int
		{
			return _time;
		}

		public function set time(value:int):void
		{
			_time = value;
		}

		public function get timer():Timer
		{
			return _timer;
		}

		public function set timer(value:Timer):void
		{
			_timer = value;
		}

		
	}
}