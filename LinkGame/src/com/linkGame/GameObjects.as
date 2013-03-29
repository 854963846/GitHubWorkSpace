package com.linkGame
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.text.engine.BreakOpportunity;

	public class GameObjects
	{
		private var _gameObjects:Array ;
		public function GameObjects()
		{
			_gameObjects = new Array();
			appendObjects(_gameObjects);
		}
		
		/**
		 * 获取所有的
		 */
		public function get getGameObjects():Array {
			return _gameObjects;
		}
		
		/**
		 * 加载已有的图片进入数组
		 */
		public function appendObjects(gameObjects:Array):void {
			gameObjects[0] = "apple";
			gameObjects[1] = "banana";
			gameObjects[2] = "doubleApple";
			gameObjects[3] = "orange";
			gameObjects[4] = "pear";
//			gameObjects[5] = "bbt";
//			gameObjects[6] = "bl";
//			gameObjects[7] = "cj";
//			gameObjects[8] = "eight";
//			gameObjects[9] = "hj";
//			gameObjects[10] = "lb";
//			gameObjects[11] = "qj";
//			gameObjects[12] = "qz";
//			gameObjects[13] = "yz";
			
			/*
			gameObjects[0] = "jiDeng";
			gameObjects[1] = "zhiPing";
			gameObjects[2] = "weiTing";
			gameObjects[3] = "zengHui";
			gameObjects[4] = "jinHao";
			gameObjects[5] = "tengFeng";
			gameObjects[6] = "boYa";
			gameObjects[7] = "yongXi";
			gameObjects[8] = "zhiCheng";
			gameObjects[8] = "wenBing";
			gameObjects[9] = "junJie";
			gameObjects[10] = "junWen";
			gameObjects[11] = "jiaMin";
			gameObjects[12] = "zeSheng";
			gameObjects[13] = "haiQuan";
			gameObjects[14] = "erPing";
			gameObjects[15] = "jiaMing";
			gameObjects[16] = "junFan";
			gameObjects[17] = "minJian";
			gameObjects[18] = "mingYuan";
			gameObjects[19] = "shenBo";
			gameObjects[20] = "jinXi";
			gameObjects[21] = "liHua";
			gameObjects[22] = "yiYu";
			gameObjects[23] = "yiMing";
			gameObjects[24] = "feiHone";
			gameObjects[25] = "wanYing";
			gameObjects[26] = "xiaoYan";
			gameObjects[27] = "wanWen";
			gameObjects[28] = "xiaoYang";
			gameObjects[29] = "liangJing";
			gameObjects[30] = "liangMei";
			gameObjects[31] = "peiLian";
			gameObjects[32] = "liuJing";
			gameObjects[33] = "tingTing";
			gameObjects[34] = "zaiChang";
			gameObjects[35] = "wenMin";
			gameObjects[36] = "jinZhi";
			gameObjects[37] = "xiaoHui";
			gameObjects[38] = "zhaoXue";
			 */
		}
		
		/**
		 * 根据不同的名词返回对应的对象
		 */
		public function getAppendObjects(str:String):MovieClip{
			var obj:MovieClip = null;
			switch(str){
				case "apple": obj = new ShapeApple(); break;
				case "banana": obj = new ShapeBanana(); break;
				case "doubleApple": obj = new ShapeDoubleApple(); break;
				case "orange": obj = new ShapeOrange(); break ;
				case "pear": obj = new ShapePear(); break ;
//				case "bbt": obj = new ShapeBbt();  break;
//				case "bl": obj = new ShapeBl(); break;
//				case "cj": obj = new ShapeCj(); break;
//				case "eight": obj = new ShapeEight(); break;
//				case "hj": obj = new ShapeHj(); break;
//				case "lb": obj = new ShapeLb(); break;
//				case "qj": obj = new ShapeQj(); break ;
//				case "qz": obj = new ShapeQz(); break ;
//				case "yz": obj = new ShapeYz(); break ;
				
				/*
				case "jiDeng": obj = new JiDeng(); break ;
				case "zhiPing": obj = new ZhiPing(); break;
				case "weiTing": obj = new WeiTing(); break;
				case "zengHui": obj = new ZengHui(); break;
				case "jinHao": obj = new JinHao(); break;
				case "tengFeng": obj = new TengFeng(); break;
				case "boYa": obj = new BoYa(); break;
				case "yongXi": obj = new YongXi(); break;
				case "zhiCheng": obj = new ZhiCheng(); break;
				case "wenBing": obj = new WenBing(); break;
				case "junJie": obj = new JunJie(); break;
				case "junWen": obj = new JunWen(); break;
				case "jiaMin": obj = new JiaMin(); break;
				case "zeSheng": obj = new ZeSheng(); break;
				case "haiQuan": obj = new HaiQuan(); break;
				case "erPing": obj = new ErPing(); break;
				case "jiaMing": obj = new JiaMing(); break;
				case "junFan": obj = new JunFan(); break;
				case "minJian": obj = new MinJian(); break;
				case "mingYuan": obj = new MingYuan(); break;
				case "shenBo": obj = new ShenBo(); break;
				case "jinXi": obj = new JinXi(); break;
				case "liHua": obj = new LiHua(); break;
				case "yiYu": obj = new YiYu(); break;
				case "yiMing": obj = new YiMing(); break;
				case "feiHone": obj = new FeiHone(); break;
				case "wanYing": obj = new WanYing(); break;
				case "xiaoYan": obj = new XiaoYan(); break;
				case "wanWen": obj = new WanWen(); break;
				case "xiaoYang": obj = new XiaoYang(); break;
				case "liangJing": obj = new LiangJing(); break;
				case "liangMei": obj = new LiangMei(); break;
				case "peiLian": obj = new PeiLian(); break;
				case "liuJing": obj = new LiuJing(); break;
				case "tingTing": obj = new TingTing(); break;
				case "zaiChang": obj = new ZaiChang(); break;
				case "wenMin": obj = new WenMin(); break;
				case "jinZhi": obj = new JinZhi(); break;
				case "xiaoHui": obj = new XiaoHui(); break;
				case "zhaoXue": obj = new ZhaoXue(); break;
				
				
				
				*/
				
				
				default : break;
			}
			return obj;
		}
		
		
	}
}