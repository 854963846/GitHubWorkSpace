package com.dbxgzs.object
{
	import flash.display.MovieClip;

	public class GameObject
	{
		
		private var gameObjects:Vector.<MovieClip>;
		
		public function GameObject()
		{
		}
		
		/**
		 * 待展示的对象名称
		 */
		public function displayObjectNames():Vector.<String>
		{
			var gameObjects:Vector.<String> = new Vector.<String>();
			gameObjects[0] = "lihua";
			gameObjects[1] = "yongxi";
			gameObjects[2] = "jinxi";
			gameObjects[3] = "wanying";
			gameObjects[4] = "jinhao";
			gameObjects[5] = "haiquan";
			gameObjects[6] = "liangjing";
			gameObjects[7] = "lihua1";
			
//			gameObjects[0] = "jiDeng";
//			gameObjects[1] = "zhiPing";
//			gameObjects[2] = "weiTing";
//			gameObjects[3] = "zengHui";
//			gameObjects[4] = "jinHao";
//			gameObjects[5] = "tengFeng";
//			gameObjects[6] = "boYa";
//			gameObjects[7] = "yongXi";
//			gameObjects[8] = "zhiCheng";
//			gameObjects[8] = "wenBing";
//			gameObjects[9] = "junJie";
//			gameObjects[10] = "junWen";
//			gameObjects[11] = "jiaMin";
//			gameObjects[12] = "zeSheng";
//			gameObjects[13] = "haiQuan";
//			gameObjects[14] = "erPing";
//			gameObjects[15] = "jiaMing";
//			gameObjects[16] = "junFan";
//			gameObjects[17] = "minJian";
//			gameObjects[18] = "mingYuan";
//			gameObjects[19] = "shenBo";
//			gameObjects[20] = "jinXi";
//			gameObjects[21] = "liHua";
//			gameObjects[22] = "yiYu";
//			gameObjects[23] = "yiMing";
//			gameObjects[24] = "feiHone";
//			gameObjects[25] = "wanYing";
//			gameObjects[26] = "xiaoYan";
//			gameObjects[27] = "wanWen";
//			gameObjects[28] = "xiaoYang";
//			gameObjects[29] = "liangJing";
//			gameObjects[30] = "liangMei";
//			gameObjects[31] = "peiLian";
//			gameObjects[32] = "liuJing";
//			gameObjects[33] = "tingTing";
//			gameObjects[34] = "zaiChang";
//			gameObjects[35] = "wenMin";
//			gameObjects[36] = "jinZhi";
//			gameObjects[37] = "xiaoHui";
//			gameObjects[38] = "zhaoXue";
			return gameObjects;
		}
		
		/**
		 * 根据名称，生成展示对象
		 */
		public function getDisplayObject( name:String ):MovieClip
		{
			var obj:MovieClip = null;
			switch( name.toLowerCase() )
			{
				case "haiquan": obj = new HaiQuan(); break ;
				case "jinhao": obj = new JinHao(); break ;
				case "jinxi": obj = new JinXi(); break ;
				case "wanying": obj = new WanYing(); break ;
				case "yongxi": obj = new YongXi(); break ;
				case "lihua": obj = new LiHua(); break ;
				case "liangjing": obj = new LiangJing(); break ;
				case "lihua1": obj = new LiHua(); break ;
//				case "jiDeng": obj = new JiDeng(); break ;
//				case "zhiPing": obj = new ZhiPing(); break;
//				case "weiTing": obj = new WeiTing(); break;
//				case "zengHui": obj = new ZengHui(); break;
//				case "jinHao": obj = new JinHao(); break;
//				case "tengFeng": obj = new TengFeng(); break;
//				case "boYa": obj = new BoYa(); break;
//				case "yongXi": obj = new YongXi(); break;
//				case "zhiCheng": obj = new ZhiCheng(); break;
//				case "wenBing": obj = new WenBing(); break;
//				case "junJie": obj = new JunJie(); break;
//				case "junWen": obj = new JunWen(); break;
//				case "jiaMin": obj = new JiaMin(); break;
//				case "zeSheng": obj = new ZeSheng(); break;
//				case "haiQuan": obj = new HaiQuan(); break;
//				case "erPing": obj = new ErPing(); break;
//				case "jiaMing": obj = new JiaMing(); break;
//				case "junFan": obj = new JunFan(); break;
//				case "minJian": obj = new MinJian(); break;
//				case "mingYuan": obj = new MingYuan(); break;
//				case "shenBo": obj = new ShenBo(); break;
//				case "jinXi": obj = new JinXi(); break;
//				case "liHua": obj = new LiHua(); break;
//				case "yiYu": obj = new YiYu(); break;
//				case "yiMing": obj = new YiMing(); break;
//				case "feiHone": obj = new FeiHone(); break;
//				case "wanYing": obj = new WanYing(); break;
//				case "xiaoYan": obj = new XiaoYan(); break;
//				case "wanWen": obj = new WanWen(); break;
//				case "xiaoYang": obj = new XiaoYang(); break;
//				case "liangJing": obj = new LiangJing(); break;
//				case "liangMei": obj = new LiangMei(); break;
//				case "peiLian": obj = new PeiLian(); break;
//				case "liuJing": obj = new LiuJing(); break;
//				case "tingTing": obj = new TingTing(); break;
//				case "zaiChang": obj = new ZaiChang(); break;
//				case "wenMin": obj = new WenMin(); break;
//				case "jinZhi": obj = new JinZhi(); break;
//				case "xiaoHui": obj = new XiaoHui(); break;
//				case "zhaoXue": obj = new ZhaoXue(); break;
				default : break;
			}
			return obj;
		}
		
		
		public function getCount( num:int ):MovieClip
		{
			var obj:MovieClip = null;
			switch(num)
			{
				case 0:
				{
					obj = new Zero();
					break;
				}
				case 1:
				{
					obj = new One();
					break;
				}
				case 2:
				{
					obj = new Two();
					break;
				}
				case 3:
				{
					obj = new Three();
					break;
				}
				case 4:
				{
					obj = new Four();
					break;
				}
				case 5:
				{
					obj = new Five();
					break;
				}
				case 6:
				{
					obj = new Six();
					break;
				}
				case 7:
				{
					obj = new Seven();
					break;
				}
				case 8:
				{
					obj = new Eight();
					break;
				}
				case 9:
				{
					obj = new Night();
					break;
				}
					
				default:
				{
					break;
				}
			}
			return obj;
		}
	}
}