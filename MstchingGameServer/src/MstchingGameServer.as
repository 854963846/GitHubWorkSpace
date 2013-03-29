package
{
	import com.SerSocket.SerSocket;
	
	import flash.display.Sprite;
	
	public class MstchingGameServer extends Sprite
	{
		private static const IP:String = "127.0.0.1";
		private static const PORT:String = "9420"; 
		
		private var serverSocket:SerSocket
		
		public function MstchingGameServer()
		{
			if( null== serverSocket )
			{
				serverSocket = new SerSocket( parseInt(PORT), IP);
			}
		}
	}
}