package
{
	import com.dbxgzs.scene.GameScene;
	
	import flash.display.Sprite;
	
	[SWF(width="1000", height="450")]
	public class MstchingGameClient extends Sprite
	{	
		public function MstchingGameClient()
		{
			var gameScene:GameScene = new GameScene(this.stage);
			addChild(gameScene);	//加载场景	
		}
	}
}