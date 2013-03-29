package com.dbxgzs.clientSocket
{
	import com.dbxgzs.scene.GameScene;
	import com.dbxgzs.serverPush.ServerPush;
	
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.Socket;

	public class ClientSocket
	{
		private var clientSocket:Socket;
		private static const IP:String = "127.0.0.1";
		private static const PORT:String = "9420"; 
		private var serverPush:ServerPush;
		private var gameScene:GameScene;
		public function ClientSocket(_gameScene:GameScene)
		{
			gameScene = _gameScene;
			serverPush = new ServerPush(_gameScene);
			clientSocket = new Socket(IP, parseInt(PORT));
			listenerConfig();
		}
		
		/**
		 * 启动连接服务器监听
		 */
		private function listenerConfig():void
		{
			clientSocket.addEventListener(Event.CLOSE, onClose);
			clientSocket.addEventListener(Event.CONNECT, onConnect); //监听连接时间事件
			clientSocket.addEventListener(ProgressEvent.SOCKET_DATA, getData);
		}
		
		protected function onConnect(event:Event):void
		{
			trace("connect success....");
		}
		
		protected function onClose(event:Event):void
		{
			trace("connect closed....");			
		}
		
		/**
		 * 接收服务器推送信息
		 */
		protected function getData(e:ProgressEvent):void
		{
			var target:Socket = e.currentTarget as Socket;
			var agreement:int = target.readInt();
			switch(agreement)
			{
				case 1:	//协议1，展示对方的界面
				{
					serverPush.showPrePics(target.readObject());
					break;
				}
					
				case 2: //协议2，修改选中覆盖层
				{
					serverPush.changeCover(target.readMultiByte(target.bytesAvailable, "UTF-8"));
					break;
				}	
					
				case 3: //协议3，倒数开始游戏
				{
					serverPush.countBackward();
					break;
				}	
					
				case 4: //协议4，初始化对手的界面
				{
					serverPush.initEnemyGame(target.readObject());
					break;
				}
					
				case 5: //协议5，同步用户交换两点图片
				{
					serverPush.sysUserCmd(target.readObject());
					break;
				}
					
				case 6: //协议6，同步填充
				{
					serverPush.fillGameObjs(target.readObject());
					break;
				}
					
				default:
				{
					break;
				}
			}
		}
		
		/**
		 * 发送待选游戏对象到服务端
		 */
		public function appendPreGameObjs(objNames:Vector.<String>):void
		{
			clientSocket.writeInt(1);
			clientSocket.writeObject( objNames );
			clientSocket.flush();
		}
		
		/**
		 * 选择待游戏对象时候覆盖层
		 */
		public function changeCover(x:Number, y:Number):void
		{
			clientSocket.writeInt( 2 );
			var str:String = x + "," + y;
			clientSocket.writeMultiByte( str, "UTF-8" );
			clientSocket.flush();
		}
		
		/**
		 * 游戏对象选完，待游戏开始
		 */
		public function readyForGame():void
		{
			clientSocket.writeInt( 3 );
			clientSocket.flush();
		}
		
		/**
		 * 发送己方的界面到服务器
		 */
		public function initEnemyGame(totalGameArr:Array):void
		{
			clientSocket.writeInt( 4 );
			clientSocket.writeObject( totalGameArr );
			clientSocket.flush();
		}
		
		/**
		 * 同步用户的交换图片操作
		 */
		public function synUserCmd(pointsArr:Array):void
		{
			clientSocket.writeInt( 5 );
			clientSocket.writeObject( pointsArr );
			clientSocket.flush();			
		}
		
		/**
		 * 同步填充
		 */
		public function fillGame(fillGameObjectsArr:Array):void
		{
			clientSocket.writeInt( 6 );
			clientSocket.writeObject( fillGameObjectsArr );
			clientSocket.flush();			
		}
		
		/**
		 * 通知服务器游戏结束
		 */
		public function timeOver():void
		{
			clientSocket.writeInt( 7 );
			clientSocket.flush();			
		}
		
		/**
		 * 重新开始游戏
		 */
		public function playGame():void
		{
			clientSocket.writeInt( 8 );
			clientSocket.flush();
		}
	}
}