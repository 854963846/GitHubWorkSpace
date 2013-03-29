package
{
	import com.scene.GameScene;
	import flash.display.Sprite;
	
	public class LinkGame extends Sprite
	{
		public function LinkGame()
		{
			var scene:GameScene = new GameScene(stage);
			
			addChild(scene);
		}
		
		
	}
}