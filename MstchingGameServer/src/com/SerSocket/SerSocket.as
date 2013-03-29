package com.SerSocket
{
	import flash.events.ProgressEvent;
	import flash.events.ServerSocketConnectEvent;
	import flash.net.ServerSocket;
	import flash.net.Socket;
	import flash.utils.setTimeout;

	public class SerSocket
	{
		private var serverSocket:ServerSocket = new ServerSocket();
		private var socketArr:Array = new Array();
		private var readyForGameArr:Array = new Array();
		private var firstPlayerReady:Boolean = false, secondPlayerReady:Boolean = false;
		private var firstClient:Socket, secondClient:Socket;
		
		public function SerSocket( port:int, ip:String)
		{
			setUpListener(port, ip);
		}
		
		/**
		 * 启动服务器监听
		 */
		private function setUpListener(port:int, ip:String):void
		{
			if(serverSocket.bound)
			{
				serverSocket.close();
				serverSocket = new ServerSocket();
			}
			serverSocket.bind( port, ip );
			serverSocket.addEventListener( ServerSocketConnectEvent.CONNECT, onConnect );
			serverSocket.listen();
		}		
		
		/**
		 * 监听客户端连接
		 */
		protected function onConnect(event:ServerSocketConnectEvent):void
		{
			var clientSocket:Socket = event.socket;
			clientSocket.addEventListener( ProgressEvent.SOCKET_DATA, getClientData);
			if( socketArr.indexOf( clientSocket ) == -1 && socketArr.length<2 )
			{
				if( 0 == socketArr.length )
				{
					firstPlayerReady = true;
					firstClient = clientSocket;
				}
				else
				{
					secondPlayerReady = true;
					secondClient = clientSocket;
				}
				socketArr[socketArr.length] = clientSocket;
			}
			else
			{
				socketArr = new Array();
				readyForGameArr = new Array();
				socketArr[0] = clientSocket;
				firstClient = clientSocket;
			}
		}
		
		/**
		 * 监听用户发送过来的数据
		 */
		protected function getClientData(e:ProgressEvent):void
		{
			var target:Socket = e.currentTarget as Socket;
			var agreement:int = target.readInt();  //读取协议
			
			if( socketArr.length > 1 && firstPlayerReady && secondPlayerReady )
			{
				switch(agreement)
				{
					case 1:	pushClientPreObjs(); break;				//协议1，接收待游戏对象
					case 2: pushClientChangeCover(target); break;	//协议2，接收待游戏对象
					case 3: setReadyForGame(target); break; 		//协议3，选定人后开始游戏
					case 4: initEnemyGame(target); break;			//协议4，初始化对手的游戏界面
					case 5: synUserCmd(target); break;				//协议5，对手的图片交换操作
					case 6: fillGameObjs(target); break;			//协议6，填充被消除的地方
					case 7: timeOver(target); break;				//协议7，游戏时间结束
					default: break;
				}
			}
			
			if( 8 == agreement )
			{
				playGame(target);  //协议8，重新开始游戏
			} 
		}
		
		/**
		 * 重新开始游戏
		 */
		public function playGame(target:Socket):void 
		{
			//根据用户设置其游戏状态
			if(target == firstClient)  
			{
				firstPlayerReady = true;
			}
			else if( target == secondClient)  
			{
				secondPlayerReady = true;
			}
		}
		
		/**
		 * 游戏结束
		 */
		public function timeOver(target:Socket):void
		{
			firstPlayerReady = false;
			secondPlayerReady = false;
			readyForGameArr[0] = 0;
			readyForGameArr[1] = 0;
		}
		
		/**
		 * 推送填充
		 */
		public function fillGameObjs(target:Socket):void
		{
			if(target == firstClient)  //操作用户是1，把信息传给用户2
			{
				secondClient.writeInt( 6 );
				secondClient.writeObject( target.readObject() );
				secondClient.flush();
			}
			else if( target == secondClient)
			{
				firstClient.writeInt( 6 );
				firstClient.writeObject( target.readObject() );
				firstClient.flush();
			}
		}
		
		/**
		 * 推送对手的界面
		 */
		public function synUserCmd(target:Socket):void
		{
			if(target == firstClient)  //操作用户是1，把信息传给用户2
			{
				secondClient.writeInt( 5 );
				secondClient.writeObject( target.readObject() );
				secondClient.flush();
			}
			else if( target == secondClient)
			{
				firstClient.writeInt( 5 );
				firstClient.writeObject( target.readObject() );
				firstClient.flush();
			}
		}
		
		/**
		 * 推送对手的界面
		 */
		public function initEnemyGame(target:Socket):void
		{
			if(target == firstClient)  //操作用户是1，把信息传给用户2
			{
//				setTimeout( function():void
//				{
					secondClient.writeInt( 4 );
					secondClient.writeObject( firstClient.readObject() );
					secondClient.flush();
					trace( "push second ..." );
//				},200);
			}
			else if( target == secondClient)
			{
//				setTimeout( function():void
//				{
					firstClient.writeInt( 4 );
					firstClient.writeObject( secondClient.readObject() );
					firstClient.flush();
					trace( "push first ..." );
//				},200);
			}
		}
		
		/**
		 * 倒计时开始游戏
		 */
		public function setReadyForGame(target:Socket):void
		{
			if(target == firstClient)  //操作用户是1，把信息传给用户2
			{
				readyForGameArr[0] = 1;
			}
			else if( target == secondClient)
			{
				readyForGameArr[1] = 1;
			}
			
			if( 1==readyForGameArr[0] && 1==readyForGameArr[1] )
			{
				firstClient.writeInt( 3 );
				firstClient.flush();
				//setTimeout(function():void
				//{
					secondClient.writeInt( 3 );
					secondClient.flush();
				//},100);
			}
		}
		
		/**
		 * 推送覆盖层
		 */
		public function pushClientChangeCover(target:Socket):void
		{
			if(target == firstClient)  //操作用户是1，把信息传给用户2
			{
				secondClient.writeInt( 2 );
				secondClient.writeMultiByte( target.readMultiByte(target.bytesAvailable, "UTF-8"), "UTF-8" );
				secondClient.flush();	
			}
			else if( target == secondClient)
			{
				firstClient.writeInt( 2 );
				firstClient.writeMultiByte( target.readMultiByte(target.bytesAvailable, "UTF-8"), "UTF-8" );
				firstClient.flush();	
			}
		}
		
		/**
		 * 给用户推送对方界面的信息
		 */
		private function pushClientPreObjs():void
		{
			firstClient.writeInt( 1 );
			firstClient.writeObject( secondClient.readObject() );
			secondClient.writeInt( 1 );
			secondClient.writeObject( firstClient.readObject() );
			firstClient.flush();
			secondClient.flush();			
		}
	}
}