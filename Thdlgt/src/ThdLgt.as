package
{
	import com.gameCmd.GameCmd;
	import com.loader.loadMap.LoadMap;
	import com.scene.StageObjects;
	import com.scene.StageScene;
	
	import flash.display.Sprite;
	
	[SWF(width="390", height="500", backgroundColor="#666666", frameRate="60")]
	public class ThdLgt extends Sprite
	{
		public function ThdLgt()
		{
			Global._scene = new StageScene(this.stage);
			Global._stageObjs = new StageObjects();
			
			var loadMap:LoadMap = new LoadMap();
			var gameCmd:GameCmd = new GameCmd();
			
			trace("xxx");
			 
		}
	}
}