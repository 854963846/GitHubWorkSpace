package com.dbxgzs.scene
{
	import com.dbxgzs.clientSocket.ClientSocket;
	import com.dbxgzs.eventCommand.EventCommand;
	import com.dbxgzs.extendMC.Count;
	import com.dbxgzs.extendMC.ExtendMC;
	import com.dbxgzs.logic.DataLogic;
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.utils.getQualifiedClassName;

	public class GameScene extends MovieClip
	{
		//容器
		private var stageList:Vector.<DisplayObject> = new Vector.<DisplayObject>(); //舞台展示对象
		private var displayList:Vector.<DisplayObject> = new Vector.<DisplayObject>(); //游戏对象
		private var extendList:Vector.<DisplayObject> = new Vector.<DisplayObject>(); //其他展示对象
		private var targetGameObjs:Vector.<MovieClip> = new Vector.<MovieClip>(); //用户选择的游戏对象
		
		//调用类
		public var dataLogic:DataLogic; //数据逻辑
		public var eventCmd:EventCommand; //事件监听
		public var extendMC:ExtendMC; //舞台展示对象
		public var count:Count;
		private var clientSocket:ClientSocket = new ClientSocket(this); //客户端socket
		
		public function GameScene(_stage:Stage)
		{
			Global.stage = _stage;
			extendMC = new ExtendMC(this);
			extendMC.initStageBg(); //初始化舞台背景
			initStage(); //初始化舞台
		}
		
		/**
		 * 返回客户端socket
		 */
		public function getClientSocket():ClientSocket
		{
			return this.clientSocket;
		}
		
		/**
		 * 增加非游戏对象到舞台
		 */
		public function addExtendsObject(obj:DisplayObject):void
		{
			if(extendList.indexOf(obj) != -1) 
			{
				trace( "该对象已经存在于舞台" );
				return;
			}
			else
			{
				var len:int = extendList.length;
				extendList[len] = obj;
				addToStage( obj );
			}
		}
		
		/**
		 * 移除一个非游戏舞台对象
		 */
		public function removeExtendsObject(obj:DisplayObject):void
		{
			var id:int = extendList.indexOf( obj );
			if(id == -1) 
			{
				trace( "该对象不存在于舞台" );
				return;
			}
			else
			{
				extendList.splice( id, 1 );		
				removeFromStage( obj );			
			}
		}

		/**
		 * 新增一个游戏对象到舞台
		 */
		public function addObject(obj:DisplayObject):void
		{
			if (displayList.indexOf(obj) != -1)
			{
				trace("该对象已经存在于舞台");
				return;
			}
			else
			{
				var len:int=displayList.length;
				displayList[len] = obj;
				addToStage( obj );
			}
		}
		
		/**
		 * 移除一个舞台对象
		 */
		public function removeObject(obj:DisplayObject):void
		{
			var id:int = displayList.indexOf( obj );
			if(id == -1) 
			{
				trace( "该对象不存在于舞台" );
				return;
			}
			else
			{
				displayList.splice( id, 1 );		
				removeFromStage( obj );			
			}
		}
		
		/**
		 * 保存到舞台
		 */
		public function addToStage(obj:DisplayObject):void
		{
			if(stageList.indexOf(obj) != -1) 
			{
				trace( "该对象已经存在于舞台" );
				return;
			}
			else
			{
				stageList[stageList.length] = obj;
				Global.stage.addChild( obj );
			}
		}
		
		/**
		 * 移除一个舞台对象
		 */
		public function removeFromStage(obj:DisplayObject):void
		{
			var id:int = stageList.indexOf( obj );
			if(id == -1) 
			{
				trace( "该对象不存在于舞台" );
				return;
			}
			else
			{
				stageList.splice( id, 1 );		
				Global.stage.removeChild( obj );				
			}
		}
		
		
		/**
		 * 返回展示对象
		 */
		public function get getDisplayList():Vector.<DisplayObject>
		{
			return this.displayList;
		}
		
		/**
		 * 清除其他对象
		 */
		public function clearExtendListObj():void
		{
			var len:int = extendList.length;
			for (var i:int = 0; i < len; i++) 
			{
				removeExtendsObject( extendList[0] );
			}
		}
		
//		/**
//		 * 清空舞台
//		 */
//		public function clearStage():void
//		{
//			targetGameObjs = new Vector.<MovieClip>();
//			var len:int = stageList.length;
//			for (var i:int = 0; i < len; i++) 
//			{
//				removeObject( stageList[0] );
//			}
//		}
		
		/**
		 * 添加游戏对象
		 */
		public function setTargetGameObjs( obj:MovieClip ):Boolean
		{
			var len:int = targetGameObjs.length;
			targetGameObjs[len] = obj;
			if( 5 == len + 1 )
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * 获取游戏对象
		 */
		public function get getTargetGameObjs():Vector.<MovieClip>
		{
			return this.targetGameObjs;
		}
		
		/**
		 * 移除游戏对象
		 */
		public function removeTargetGameObjs( obj:MovieClip ):void
		{
			var id:int = targetGameObjs.indexOf( obj );
			targetGameObjs.splice( id, 1 );
		}
		
		/**
		 * 重置游戏对象
		 */
		public function clearTargetGameObjs():void
		{
			this.targetGameObjs = new Vector.<MovieClip>();
		}
		
		/**
		 * 添加待用户自定义的游戏对象到舞台
		 */
		public function appendPreGameObj( obj:MovieClip, line:int, vert:int ):void
		{
			obj.width = 47;
			obj.height = 47;
			obj.x = line;
			obj.y = vert;
			addObject( obj ) ;
		}
		
		/**
		 * 添加己方游戏对象到舞台
		 */
		public function appendGameObj( obj:MovieClip, line:int, vert:int):void
		{
			obj.width = 47;
			obj.height = 47;
			obj.x = 50 + vert*47;
			obj.y = 50 + line*47;
			addObject( obj );
		}
		
		/**
		 * 填充游戏对象到舞台
		 */
		public function fillGameObj( obj:MovieClip, line:int, vert:int):void
		{
			obj.width = 47;
			obj.height = 47;
			obj.x = vert*47;
			addObject( obj);
			TweenLite.to( obj, 0, {x:vert*47+50, y:line*47+50} );  //动画效果进入
		}
		
		/**
		 * 移动游戏对象
		 */
		public function moveGameObj( obj:MovieClip, line:int, vert:int):void
		{
			TweenLite.to( obj, 0, {x:vert*47 + 50, y:line*47 + 50} );  //动画效果进入
		}
		
		/**
		 * 初始化舞台，用户选择游戏角色
		 */
		public function initStage():void
		{
			dataLogic = new DataLogic(this);
			dataLogic.initStage();
			eventCmd = new EventCommand(this); 		//给舞台对象增加特效
		}
		
		/**
		 * 游戏开始，初始化游戏场景
		 */
		public function startGame():void
		{
			count = new Count(this);
			count.appendCount();  //添加积分
			dataLogic.startGame();  //游戏开始
		}
	}
}