package com.display
{
	import com.command.MouseController;
	import com.linkGame.GameObjects;
	import com.scene.GameScene;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.AsyncErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.engine.BreakOpportunity;
	import flash.utils.Timer;
	import flash.utils.setTimeout;

	public class DisplayGame
	{
		private var gameScene:GameScene ;
		private var mouseController:MouseController;
		private var totalShape:Array = new Array(); //展示数组
		private var lineShape:Array = new Array();  //每行
		private var dimenShape:Array = new Array(); //对应展示图片的二维数组
		private var gameObjects:GameObjects = null;
		private var xLine:uint = 1, yLine:uint = 1, totalShapeNum:uint = 0 ; //当前遍历的下标,总展示数组下标
		
		private var xLineNum:uint = 10; //Math.floor((Global.stage.stageWidth-60)/30) ;  //每行展示的图标个数
		private var yLineNum:uint = 6; //Math.floor((Global.stage.stageHeight-60)/30) ; //每列展示的图标个数
		private const TOTAL_COUNT:uint = xLineNum*yLineNum; //总输出个数
		
		private var firstFocusShape:Array = new Array();
		private var coverOne:MovieClip = new ShapeCoverOne();  //遮罩
		private var coverTwo:MovieClip = new ShapeCoverOne();  //遮罩
		private var coverThree:MovieClip = new ShapeCoverOne();  //遮罩
		private var secondFucusShape:Array = new Array();
		private var extendPoint:Array = new Array();
		
		private var fireOne:ShapeFireOne;
		private var fireTwo:ShapeFireTwo;
		private var fireThree:ShapeFireThree;
		private var sfireOne:ShapeFireOne;
		private var sfireTwo:ShapeFireTwo;
		private var sfireThree:ShapeFireThree;
		
		private var points:Array;  //绘图坐标
		
		public function DisplayGame(_gameScene:GameScene, _mouseController)
		{
			gameScene = _gameScene;
			mouseController = _mouseController;
			createTotalShape();
			var timer:Timer = new Timer(10, TOTAL_COUNT );
			timer.addEventListener( TimerEvent.TIMER, initGame );
			timer.start();
		}
		
		/**
		 * 初始化待展示的图片
		 */
		public function createTotalShape():void {
			gameObjects = new GameObjects();
			var gameObjectsNum:int = gameObjects.getGameObjects.length;
			var gObj:Array = gameObjects.getGameObjects;
			var halfNum:int = TOTAL_COUNT/2;
			
			//随机生成一半图片
			var halfRandom:Array = new Array();
			for(var i:int = 1; i <= halfNum; ){
				var targetShape:int = Math.round(Math.random()*100) ;
				if( 0 <= targetShape && gameObjectsNum > targetShape ) {
					halfRandom.push( gObj[targetShape] ) ;
					i++;
				}
			}
			totalShape = halfRandom.concat( halfRandom.reverse());
		}
		
		/**
		 * 按每0.001秒展示一张图片，同时创建 二维数组
		 */
		public function initGame(e:TimerEvent):void {
			drawShapes();
			e.updateAfterEvent();
		}
		
		public function drawShapes():void {
			var obj:MovieClip = gameObjects.getAppendObjects( totalShape[totalShapeNum++] ) ;
			
			obj.addEventListener( MouseEvent.MOUSE_OVER, overShape ); //添加鼠标进入
			obj.addEventListener( MouseEvent.MOUSE_OUT, outShape ); //添加鼠标移开
			obj.addEventListener( MouseEvent.CLICK, clickShape ); //鼠标单击
			
			gameScene.addObject(obj);
			lineShape[xLine] = obj; //保存每行的对象
			
			obj.x = obj.width*xLine + 65;
			obj.y = obj.height*yLine;
			xLine++;
			if( xLineNum < xLine ) {
				lineShape[0] = new Array(); //每行的第一个
				lineShape[xLine] = new Array();	//每行的最后一个
				dimenShape[yLine] = lineShape ; //把一行对象加进数组,形成一个二维数组
				lineShape = new Array();
				xLine = 1 ;
				if(totalShapeNum == TOTAL_COUNT) { //如果所有的图片都输出了，则在二维数组最后加上行空数组
					dimenShape[0] = new Array();	//第一行为空
					dimenShape[yLine+1] = new Array(); //最后一行为空
				}else{
					yLine++ ;
				}
			}
		}
		
		/**
		 * 鼠标点击
		 */
		public function clickShape(e:MouseEvent):void{
			var mouseX:Number = e.stageX - 65; //鼠标点中的位置
			var mouseY:Number = e.stageY ;
			if(e.currentTarget.hasEventListener( MouseEvent.MOUSE_OVER )){
				e.currentTarget.removeEventListener( MouseEvent.MOUSE_OVER, overShape );
				e.currentTarget.removeEventListener( MouseEvent.MOUSE_OUT, outShape );
				
				if( 0 == firstFocusShape.length ){
					firstFocusShape[0] = e.currentTarget;
					firstFocusShape[1] = Math.ceil((mouseY-43.85)/43.85) ;
					firstFocusShape[2] = Math.ceil((mouseX-34.80)/34.80) ;
					
					//选中遮罩层
					coverTarget(e.currentTarget as MovieClip);
				}else{
					secondFucusShape[0] = e.currentTarget;
					secondFucusShape[1] = Math.ceil((mouseY-43.85)/43.85) ;
					secondFucusShape[2] = Math.ceil((mouseX-34.80)/34.80) ;
					
					var sameShapeFlag:Boolean = compareShape(firstFocusShape, secondFucusShape); //比较两个对象是否同种类型
					if(sameShapeFlag){
						var flag:Boolean = detectConnect(firstFocusShape, secondFucusShape); //判断是否能够连通
						if(flag) {
							removeShape(firstFocusShape, secondFucusShape);
						}
					}
					Global.stage.removeChild( coverOne ); //移除遮罩
					returnShape(firstFocusShape[0] as MovieClip, secondFucusShape[0] as MovieClip);
					firstFocusShape = new Array(); //重置
					secondFucusShape = new Array();
				}
				
			}
		}
		
		/**
		 * 添加遮罩
		 */
		private function coverTarget(obj:MovieClip):void {
			//选中遮罩层
			coverOne.width = obj.width - 5;
			coverOne.height = obj.height - 3;
			coverOne.x = obj.x;
			coverOne.y = obj.y;
			Global.stage.addChild( coverOne );
			coverOne.addEventListener( MouseEvent.CLICK, initShape );
		}
		
		/**
		 * 点击遮罩层时候去掉遮罩，还原大小
		 */
		private function initShape( e:MouseEvent ):void {
			Global.stage.removeChild( coverOne );//移除遮罩
			
			var mouseX:Number = e.stageX - 65; //鼠标点中的位置
			var mouseY:Number = e.stageY ;
			var line:int = Math.ceil((mouseY-43.85)/43.85) ;
			var ver:int = Math.ceil((mouseX-34.80)/34.80) ;
			var target:MovieClip = dimenShape[line][ver] as MovieClip; 
			
			target.x = target.x + 5;
			target.y = target.y + 5;
			target.width = target.width - 5 ;
			target.height = target.height - 5 ;
			target.addEventListener( MouseEvent.MOUSE_OVER, overShape );
			target.addEventListener( MouseEvent.MOUSE_OUT, outShape );
			
			firstFocusShape = new Array(); //重置
		}
		
		/**
		 * 检测两点是否连通
		 */
		public function detectConnect(firstArr:Array, secondArr:Array):Boolean {
			var veritcalFlag:Boolean = false, horizonFlag:Boolean = false, oneLineFlag:Boolean = false, twoLineFlag:Boolean = false;
			var fx:int = firstArr[1], fy:int = firstArr[2], sx:int = secondArr[1], sy:int = secondArr[2];
			//一线
			if( fx==sx || fy==sy ){
				oneLineFlag = twoPointConnect(fx, fy, sx, sy);
				if(oneLineFlag){
					points = new Array();
					points[0] = actualLocation( fx, fy);
					points[1] = actualLocation( sx, sy);
					return true;
				}
			}
			
			//两条线
			twoLineFlag = twoLineLoop(fx, fy, sx, sy);
			if(twoLineFlag) {
				return true;
			}
			
			//三线
			//垂直
			veritcalFlag = verticalLoop(fx, fy, sx, sy);
			if(veritcalFlag) return true;
			
			//水平
			horizonFlag = horizonLoop(fx, fy, sx, sy);
			if(horizonFlag) return true;
			return false;
		}
		
		/**
		 * 根据数组坐标返回真实的坐标
		 */
		private function actualLocation(x:int, y:int):Array {
			
			var width:Number = firstFocusShape[0].width ;
			var height:Number = firstFocusShape[0].height ;
			var local:Array = new Array();
			var size:int = points.length;
			if(0==size){
				local[0] = firstFocusShape[0].x + height/2;
				local[1] = firstFocusShape[0].y + width/2;
			}else { //			if(dimenShape[x][y]==0||typeof(dimenShape[x][y])=="undefined") 
				for(var i:int = 0; i<size; i++){
					if(x==points[i][2]) {  //如果跟第一个同列
						local[0] = points[i][0] + (y-points[i][3])*(width-5) ;
						if(local[0]>480) local[0] = 480;
						if(local[0]<70) local[0] = 80;
						local[1] = points[i][1] ;						
					}else if(y==points[i][3]) {  //如果跟第一个同行
						local[0] = points[i][0];
						local[1] = points[i][1] + (x-points[i][2])*(height-5);
					}
				}
			}
			local[2] = x;
			local[3] = y;
			return local;
		}
		
		
		/**
		 * 垂直方向遍历
		 */
		private function verticalLoop(_fl:int, _fv:int, _sl:int, _sv:int):Boolean {
			points = new Array();
			points[0] = actualLocation( _fl, _fv);
			//第一点往上
			for(var i:int = _fl-1; i>=0; i--) {
				if(!targetPointEmpty(i, _fv)){
					if(twoPointConnect(_fl, _fv, i, _fv)) {
						points[1] = actualLocation( i, _fv);
						if(!targetPointEmpty(i, _sv)){
							if(twoPointConnect(i, _fv, i, _sv)) {
								points[2] = actualLocation( i, _sv);
								if(twoPointConnect(i, _sv, _sl, _sv)) {
									points[3] = actualLocation( _sl, _sv);
									return true;
								}							
							}
						}
					}
				}else {
					break ;
				}
			}
			
			//第一点往下
			for(var j:int = _fl+1; j <= yLineNum+1; j++) {
				if(!targetPointEmpty(j, _fv)){
					if(twoPointConnect(_fl, _fv, j, _fv)) {
						points[1] = actualLocation( j, _fv);
						if(!targetPointEmpty(j, _sv)){
							if(twoPointConnect(j, _fv, j, _sv)) {
								points[2] = actualLocation( j, _sv);
								if(twoPointConnect(j, _sv, _sl, _sv)) {
									points[3] = actualLocation( _sl, _sv);
									return true;
								}
							}
						}
					}
				}else {
					break ;
				}
			}
			return false;
		}
		
		/**
		 * 水平方向遍历
		 */
		private function horizonLoop(_fl:int, _fv:int, _sl:int, _sv:int):Boolean {
			points = new Array();
			points[0] = actualLocation( _fl, _fv);
			//第一点往左
			for(var i:int = _fv-1; i>=0; i--) {
				if(!targetPointEmpty(_fl, i)){
					if(twoPointConnect(_fl, _fv, _fl, i)) {
						points[1] = actualLocation( _fl, i);
						if(!targetPointEmpty(_sl, i)){
							if(twoPointConnect(_fl, i, _sl, i)) {
								points[2] = actualLocation( _sl, i);
								if(twoPointConnect(_sl, i, _sl, _sv)) {
									points[3] = actualLocation( _sl, _sv);
									return true;
								}							
							}
						}
					}
				}else {
					break ;
				}
			}
			
			//第一点往右
			for(var j:int = _fv+1; j <= xLineNum+1; j++) {
				if(!targetPointEmpty(_fl, j)){
					if(twoPointConnect(_fl, _fv, _fl, j)) {
						points[1] = actualLocation( _fl, j);
						if(!targetPointEmpty(_sl, j)){
							if(twoPointConnect(_fl, j, _sl, j)) {
								points[2] = actualLocation( _sl, j);
								if(twoPointConnect(_sl, j, _sl, _sv)) {
									points[3] = actualLocation( _sl, _sv);
									return true;
								}
							}
						}
					}
				}else {
					break ;
				}
			}
			return false;
		}
		
		/**
		 * 两条线
		 * */
		private function twoLineLoop(_fl:int, _fv:int, _sl:int, _sv:int):Boolean {
			points = new Array();
			points[0] = actualLocation( _fl, _fv);
			//横
			if(!targetPointEmpty(_fl, _sv)){
				if(twoPointConnect(_fl, _fv, _fl, _sv)) {
					points[1] = actualLocation( _fl, _sv);
					if(twoPointConnect(_fl, _sv, _sl, _sv)) {
						points[2] = actualLocation( _sl, _sv);
						return true;
					}
				}
			}
			
			//纵
			if(!targetPointEmpty(_sl, _fv)){
				if(twoPointConnect(_fl, _fv, _sl, _fv)) {
					points[1] = actualLocation( _sl, _fv);
					if(twoPointConnect(_sl, _fv, _sl, _sv)) {
						points[2] = actualLocation( _sl, _sv);
						return true;
					}
				}
			}
			
			return false;
		}
		
		//目标点是否为空，true不为空，false为空
		private function targetPointEmpty(_fl:int, _fv:int):Boolean {
			return (dimenShape[_fl][_fv] != 0) && (typeof(dimenShape[_fl][_fv]) != "undefined");
		}
		
		/**
		 * 一条线
		 * */
		private function twoPointConnect(_fl:int, _fv:int, _sl:int, _sv:int):Boolean {
			var max:int, min:int ;
			if( _fl == _sl ){
				if(_fv > _sv){
					max = _fv, min = _sv;
				}else{
					max = _sv, min = _fv;
				}
				var lCover:int = max - min - 1;
				if( 0 == lCover ) return true;
				for(var i:int = 1; i <= lCover; i++) {
					var lNum:int = min + i;
					var f:Boolean = (dimenShape[_fl][lNum] != 0) && (typeof(dimenShape[_fl][lNum]) != "undefined");
					if(f) return false; 
				}
			}else if( _fv == _sv ){
				if(_fl > _sl){
					max = _fl, min = _sl;
				}else{
					max = _sl, min = _fl;
				}
				var vCover:int = max - min - 1;
				if( 0 == vCover ) return true;
				for(var i:int = 1; i <= vCover; i++) {
					var vNum:int = min + i;
					var f:Boolean = (dimenShape[vNum][_fv] != 0) && (typeof(dimenShape[vNum][_fv]) != "undefined");
					if(f) return false; 
				}
			}
			return true;
		}
		
		/**
		 * 比较两个选中的对象
		 */
		private function compareShape(firstObj:Array, secondObj:Array):Boolean {
			var first:MovieClip = firstObj[0] as MovieClip;
			var second:MovieClip = secondObj[0] as MovieClip;
			if( first.constructor == second.constructor ){
				return true;
			}else{
				return false;
			}
		}
		
		/**
		 * 还原图片为最早形式
		 */
		private function returnShape(first:MovieClip, second:MovieClip):void{
			//还原第一个
			first.x = first.x + 5;
			first.y = first.y + 5;
			first.width = first.width - 5 ;
			first.height = first.height - 5 ;
			first.addEventListener( MouseEvent.MOUSE_OVER, overShape );
			first.addEventListener( MouseEvent.MOUSE_OUT, outShape );
			
			second.addEventListener( MouseEvent.MOUSE_OVER, overShape );
			second.addEventListener( MouseEvent.MOUSE_OUT, outShape );
		}
		
		/**
		 * 移除链接目标
		 */
		private function removeShape(firstObj:Array, secondObj:Array):void {
			var first:MovieClip = firstObj[0] as MovieClip;
			var second:MovieClip = secondObj[0] as MovieClip;
			
			var pointLen:int = points.length;
			var fx:int, fy:int, sx:int, sy:int;
			for(var i:int = 0; i<pointLen-1; i++){
				fx = points[i][0];
				fy = points[i][1];
				sx = points[i+1][0];
				sy = points[i+1][1];
				drawLine(fx, fy, sx, sy);
			}
			
			showFireOne(first);
			showFireTwo(second);
			setTimeout(function(){
				Global.stage.removeChild(fireOne);
				Global.stage.removeChild(fireTwo);
				Global.stage.removeChild(fireThree);
				
				Global.stage.removeChild(sfireOne);
				Global.stage.removeChild(sfireTwo);
				Global.stage.removeChild(sfireThree);
			},50);
			
			setTimeout(function(){
				gameScene.removeObject( first );  //移除显示
				gameScene.removeObject( second );
				trace("dimenShape["+firstObj[1]+"]["+firstObj[2]+"]=="+dimenShape[firstObj[1]][firstObj[2]]);
				trace("dimenShape["+secondObj[1]+"]["+secondObj[2]+"]=="+dimenShape[secondObj[1]][secondObj[2]]);
				dimenShape[firstObj[1]][firstObj[2]] = 0 ;	//修改二维数组
				dimenShape[secondObj[1]][secondObj[2]] = 0 ;
				
				for each(var obj in gameScene.lineShape){
					Global.stage.removeChild( obj );
				}
				gameScene.lineShape = new Array();
			},100);
			
			Global.stage.removeChild(Global.label);
			Global.count = Global.count + 2;
			
			var style:StyleSheet = new StyleSheet();
			var heading:Object = new Object();
			heading.fontWeight = "bold";
			heading.fontSize = 20;
			heading.color = "#FF0000";
			style.setStyle(".count", heading);
			
			Global.label = new TextField();
			Global.label.text = Global.count+"";
			Global.label.styleSheet = style ;
			Global.label.htmlText = "<p class='count'>" + Global.count + "</p>";
			Global.stage.addChild(Global.label);
			
			Global.label.x = 30;
			Global.label.y = 40;
			Global.label.width = 30;
			Global.label.height = 30;
			Global.stage.addChild(Global.label);
		}
		
		public function showFireOne(fobj:MovieClip):void {
			fireOne = new ShapeFireOne();
			fireOne.x = fobj.x;
			fireOne.y = fobj.y;
			
			fireTwo = new ShapeFireTwo();
			fireTwo.x = fobj.x;
			fireTwo.y = fobj.y;
			
			fireThree = new ShapeFireThree();
			fireThree.x = fobj.x;
			fireThree.y = fobj.y;
			
			Global.stage.addChild(fireOne);
			Global.stage.addChild(fireTwo);
			Global.stage.addChild(fireThree);
		}
		
		public function showFireTwo(fobj:MovieClip):void {
			sfireOne = new ShapeFireOne();
			sfireOne.x = fobj.x;
			sfireOne.y = fobj.y;
			
			sfireTwo = new ShapeFireTwo();
			sfireTwo.x = fobj.x;
			sfireTwo.y = fobj.y;
			
			sfireThree = new ShapeFireThree();
			sfireThree.x = fobj.x;
			sfireThree.y = fobj.y;
			
			Global.stage.addChild(sfireOne);
			Global.stage.addChild(sfireTwo);
			Global.stage.addChild(sfireThree);
		}
		
		
		/**
		 * 画线
		 */
		private function drawLine(fx, fy, sx, sy):void {
			var shape:Shape = new Shape();
			shape.graphics.beginFill(0x003366);
			var width:int = 5;
			if( fx==sx ) {
				shape.graphics.drawRect(fx, fy, width, sy - fy);
			}else{
				shape.graphics.drawRect(fx, fy, sx - fx, width);
			}
			gameScene.lineShape.push(shape);
			Global.stage.addChild( shape );			
		}
		
		/**
		 * 鼠标移入
		 */
		public function overShape(e:MouseEvent):void {
			var width:uint = e.currentTarget.width;
			var height:uint = e.currentTarget.height;
			var _x:uint = e.currentTarget.x;
			var _y:uint = e.currentTarget.y;
			
			e.currentTarget.x = _x - 5; //左移5像素
			e.currentTarget.y = _y -5;  //上移5像素
			e.currentTarget.width = width + 5 ; //宽变大5像素
			e.currentTarget.height = height + 5 ; //高变大5像素
		}
		
		/**
		 * 鼠标移出
		 */
		public function outShape(e:MouseEvent):void {
			var width:uint = e.currentTarget.width;
			var height:uint = e.currentTarget.height;
			var _x:uint = e.currentTarget.x;
			var _y:uint = e.currentTarget.y;
			
			e.currentTarget.x = _x + 5;
			e.currentTarget.y = _y + 5;
			e.currentTarget.width = width - 5 ;
			e.currentTarget.height = height - 5 ;
		}
		
		public function autoTips():void {
			//0 , 11
			var flag:Boolean = true;
			for(var l:int = 1; l<=yLineNum; l++){
				if(flag){
					var nv:int = 1, nl:int = l;
					var sameShapeFlag:Boolean = false;
					for(var v:int = nv; v<=xLineNum; v++){
						var obj:Object = dimenShape[nl][v];
						if(0==firstFocusShape.length){
							if(0!=obj){
								firstFocusShape[0] = obj;
								firstFocusShape[1] = nl;
								firstFocusShape[2] = v;
								continue;
							}
						}else if(v<=xLineNum){
							if(0!=obj){
								secondFucusShape[0] = dimenShape[nl][v];
								secondFucusShape[1] = nl;
								secondFucusShape[2] = v;
								sameShapeFlag = compareShape(firstFocusShape, secondFucusShape); //比较两个对象是否同种类型
							}
						}
						
						if(xLineNum==v&&!sameShapeFlag){
							
							if(nl<yLineNum) {
								nl++ ;
								v = 0;	
							}else if(firstFocusShape[2]!=xLineNum-1){
								v = firstFocusShape[2] ;
								firstFocusShape = new Array();
								secondFucusShape = new Array();
							}
							
						}
						
						if(sameShapeFlag){
							flag = detectConnect(firstFocusShape, secondFucusShape); //判断是否能够连通
							if(flag) {
								coverOneTarget(firstFocusShape[0] as MovieClip);
								coverTwoTarget(secondFucusShape[0] as MovieClip);
								
//								var pointLen:int = points.length;
//								var fx:int, fy:int, sx:int, sy:int;
//								for(var i:int = 0; i<pointLen-1; i++){
//									fx = points[i][0];
//									fy = points[i][1];
//									sx = points[i+1][0];
//									sy = points[i+1][1];
//									drawLine(fx, fy, sx, sy);
//								}
								flag = false;
//								firstFocusShape = new Array();
//								secondFucusShape = new Array();
								break;
							}
						}
					}
				}else {
					break ;
				}
			}
		}
		
		/**
		 * 添加遮罩
		 */
		private function coverOneTarget(obj:MovieClip):void {
			//选中遮罩层
			coverThree.width = obj.width - 5;
			coverThree.height = obj.height - 3;
			coverThree.x = obj.x;
			coverThree.y = obj.y;
			Global.stage.addChild( coverThree );
			coverThree.addEventListener( MouseEvent.MOUSE_OVER, changeOneTargetShape );
			coverThree.addEventListener( MouseEvent.MOUSE_OUT, returnOneTargetShape );
			coverThree.addEventListener( MouseEvent.CLICK, clickOneShape );
		}
		
		public function changeOneTargetShape(e:MouseEvent):void {
			coverThree.x = coverThree.x - 5;
			coverThree.y = coverThree.y - 5;
			coverThree.width = coverThree.width + 5 ;
			coverThree.height = coverThree.height + 5 ;
			
			var target:MovieClip = firstFocusShape[0] as MovieClip;
			target.x = target.x - 5;
			target.y = target.y - 5;
			target.width = target.width + 5 ;
			target.height = target.height + 5 ;
		}
		
		public function returnOneTargetShape(e:MouseEvent):void {
			coverThree.x = coverThree.x + 5;
			coverThree.y = coverThree.y + 5;
			coverThree.width = coverThree.width - 5 ;
			coverThree.height = coverThree.height - 5 ;
			
			var target:MovieClip = firstFocusShape[0] as MovieClip;
			target.x = target.x + 5;
			target.y = target.y + 5;
			target.width = target.width - 5 ;
			target.height = target.height - 5 ;
		}
		
		/**
		 * 点击遮罩层时候去掉遮罩，还原大小
		 */
		private function clickOneShape( e:MouseEvent ):void {
			coverThree.removeEventListener( MouseEvent.MOUSE_OVER, changeOneTargetShape );
			coverThree.removeEventListener( MouseEvent.MOUSE_OUT, returnOneTargetShape );
			coverTwo.removeEventListener( MouseEvent.MOUSE_OVER, changeTwoTargetShape );
			coverTwo.removeEventListener( MouseEvent.MOUSE_OUT, returnTwoTargetShape );
			Global.stage.removeChild( coverThree as MovieClip );//移除遮罩
			Global.stage.removeChild( coverTwo as MovieClip);
			
			var mouseX:Number = e.stageX - 65; //鼠标点中的位置
			var mouseY:Number = e.stageY ;
			var line:int = Math.ceil((mouseY-43.85)/43.85) ;
			var ver:int = Math.ceil((mouseX-34.80)/34.80) ;
			var target:MovieClip = dimenShape[line][ver] as MovieClip; 
			
			target.x = target.x + 5;
			target.y = target.y + 5;
			target.width = target.width - 5 ;
			target.height = target.height - 5 ;
			target.addEventListener( MouseEvent.MOUSE_OVER, overShape );
			target.addEventListener( MouseEvent.MOUSE_OUT, outShape );
			
			firstFocusShape = new Array(); //重置
			secondFucusShape = new Array();
		}
		
		
		/**
		 * 添加遮罩
		 */
		private function coverTwoTarget(obj:MovieClip):void {
			//选中遮罩层
			coverTwo.width = obj.width - 5;
			coverTwo.height = obj.height - 3;
			coverTwo.x = obj.x;
			coverTwo.y = obj.y;
			Global.stage.addChild( coverTwo );
			coverTwo.addEventListener( MouseEvent.MOUSE_OVER, changeTwoTargetShape );
			coverTwo.addEventListener( MouseEvent.MOUSE_OUT, returnTwoTargetShape );
			coverTwo.addEventListener( MouseEvent.CLICK, clickTwoShape );
		}
		
		public function changeTwoTargetShape(e:MouseEvent):void {
			coverTwo.x = coverTwo.x - 5;
			coverTwo.y = coverTwo.y - 5;
			coverTwo.width = coverTwo.width + 5 ;
			coverTwo.height = coverTwo.height + 5 ;
			
			var target:MovieClip = secondFucusShape[0] as MovieClip;
			target.x = target.x - 5;
			target.y = target.y - 5;
			target.width = target.width + 5 ;
			target.height = target.height + 5 ;
		}
		
		public function returnTwoTargetShape(e:MouseEvent):void {
			coverTwo.x = coverTwo.x + 5;
			coverTwo.y = coverTwo.y + 5;
			coverTwo.width = coverTwo.width - 5 ;
			coverTwo.height = coverTwo.height - 5 ;
			
			var target:MovieClip = secondFucusShape[0] as MovieClip;
			target.x = target.x + 5;
			target.y = target.y + 5;
			target.width = target.width - 5 ;
			target.height = target.height - 5 ;
		}
		
		/**
		 * 点击遮罩层时候去掉遮罩，还原大小
		 */
		private function clickTwoShape( e:MouseEvent ):void {
			coverOne.removeEventListener( MouseEvent.MOUSE_OVER, changeOneTargetShape );
			coverOne.removeEventListener( MouseEvent.MOUSE_OUT, returnOneTargetShape );
			coverTwo.removeEventListener( MouseEvent.MOUSE_OVER, changeTwoTargetShape );
			coverTwo.removeEventListener( MouseEvent.MOUSE_OUT, returnTwoTargetShape );
			Global.stage.removeChild( coverThree );//移除遮罩
			Global.stage.removeChild( coverTwo );
			
			var mouseX:Number = e.stageX - 65; //鼠标点中的位置
			var mouseY:Number = e.stageY ;
			var line:int = Math.ceil((mouseY-43.85)/43.85) ;
			var ver:int = Math.ceil((mouseX-34.80)/34.80) ;
			var target:MovieClip = dimenShape[line][ver] as MovieClip; 
			
			target.x = target.x + 5;
			target.y = target.y + 5;
			target.width = target.width - 5 ;
			target.height = target.height - 5 ;
			target.addEventListener( MouseEvent.MOUSE_OVER, overShape );
			target.addEventListener( MouseEvent.MOUSE_OUT, outShape );
			
			firstFocusShape = new Array(); //重置
			secondFucusShape = new Array();
		}
		
		/**
		 * 转换
		 */
		public function changeShapes():void {
			totalShapeNum = 0;
			xLine = 1, yLine =1;
			createTotalShape();
			dimenShape = new Array();
			for(var i:int = 0; i<totalShape.length; i++){
				drawShapes();
			}
		}
		
	}
}