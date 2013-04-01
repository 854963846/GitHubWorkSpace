package
{
	import com.ethan.TileView;

	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;


	[SWF(backgroundColor="#ffffff", width="1200", height="800", frameRate="60")]
	public class Main extends Sprite
	{

		private var _camera:Sprite;

		/**64×64象素一块**/
		public static const TileSize:uint=64;


		/**拖动的容器***/
		private var _container:Sprite;
		private var _startPoint:Point;
		private var _endPoint:Point;
		private var _dispNodes:Vector.<TileView>;

		private var _startPointX:Number;
		private var _startPointY:Number;

		public var _cols:int=1920 / 64;
		public var _rows:int=1280 / 64;

		private var _mask:Sprite;


		public function Main()
		{
			initCamera();
			initGrid();
			initContainer();
			init();

		}

		private function initCamera():void
		{
			const W:Number=800;
			const H:Number=600;
			const X:Number=200;
			const Y:Number=100;

			_mask=new Sprite();
			_mask.graphics.beginFill(0x000000, 1);
			_mask.graphics.drawRect(0, 0, W, H);
			_mask.graphics.endFill();
			this.addChild(_mask);

			_camera=new Sprite();
			var _g:Graphics=_camera.graphics;
			_g.lineStyle(3, 0x000000);
			_g.drawRect(0, 0, W, H);
			_g.endFill();
			_mask.x=_camera.x=X;
			_mask.y=_camera.y=Y;
			this.addChild(_camera);

			_camera.mouseEnabled=false;
			_startPoint=new Point(_camera.x, _camera.y);
			_endPoint=new Point(_camera.x + _camera.width, _camera.y + _camera.height);

		}

		private function initGrid():void
		{
			_dispNodes=new Vector.<TileView>();
		}

		private function initContainer():void
		{
			_container=new Sprite();
			_container.mouseChildren=false;
			this.addChildAt(_container, 0);
			_container.mask=_mask;

			_container.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);

		}


		private function init():void
		{
			var _sx:uint=Math.abs((_container.x - _camera.x) / TileSize) >> 0;
			var _sy:uint=Math.abs((_container.y - _camera.y) / TileSize) >> 0;

			var _lx:uint=Math.abs(((_container.x - (_camera.x + _camera.width)) / TileSize) >> 0);
			var _ly:uint=Math.abs(((_container.y - (_camera.y + _camera.height)) / TileSize) >> 0);

			var _sp:Point=new Point(_sx, _sy);
			var _lp:Point=new Point(_lx, _ly);

			_startPoint=_sp;
			_endPoint=_lp;
			for (var _i:uint=_sx; _i <= _lx; _i+=1)
			{

				for (var _j:uint=_sy; _j <= _ly; _j+=1)
				{
					var _node:TileView=new TileView(_i, _j);
					_node.x=TileSize * _i;
					_node.y=TileSize * _j;
					_node.idX=_i;
					_node.idY=_j;
					_container.addChild(_node);
					_dispNodes.push(_node);
				}
			}


		}

		protected function onMouseDownHandler(event:MouseEvent):void
		{

			this.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			_container.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);

			_startPointX=_container.mouseX;
			_startPointY=_container.mouseY;

		}

		protected function onMouseMoveHandler(event:MouseEvent):void
		{

			var _distanceX:Number=_container.mouseX - _startPointX;
			var _distanceY:Number=_container.mouseY - _startPointY;

			if (Math.abs(_container.x + _distanceX) > TileSize * _cols - _camera.x - _camera.width)
			{
				_container.x=-TileSize * _cols + _camera.x + _camera.width;
			}
			else if (_container.x + _distanceX > _camera.x)
			{
				_container.x=_camera.x;
			}
			else
			{
				_container.x+=_distanceX;
			}

			if (Math.abs(_container.y + _distanceY) > TileSize * _rows - _camera.y - _camera.height)
			{
				_container.y=-TileSize * _rows + _camera.y + _camera.height;
			}
			else if (_container.y + _distanceY > _camera.y)
			{
				_container.y=_camera.y;
			}
			else
			{
				_container.y+=_distanceY;
			}



			var _sx:uint=Math.abs((_container.x - _camera.x) / TileSize) >> 0;
			var _sy:uint=Math.abs((_container.y - _camera.y) / TileSize) >> 0;

			var _lx:uint=Math.abs(((_container.x - (_camera.x + _camera.width)) / TileSize) >> 0);
			if (_lx > _cols - 1)
			{
				_lx=_cols - 1;
			}

			var _ly:uint=Math.abs(((_container.y - (_camera.y + _camera.height)) / TileSize) >> 0);
			if (_ly > _rows - 1)
			{
				_ly=_rows - 1;
			}

			var _sp:Point=new Point(_sx, _sy);
			var _lp:Point=new Point(_lx, _ly);

			if (!_startPoint.equals(_sp) || !_endPoint.equals(_lp))
			{
				_startPoint=_sp;
				_endPoint=_lp;
				//减去超出部分
				hideNodeView(_startPoint, _endPoint);
				//增加
				showNodeView(_startPoint, _endPoint);

			}
		}

		private function showNodeView(spoint:Point, lpoint:Point):void
		{
			var _sx:uint=spoint.x;
			var _sy:uint=spoint.y;
			var _lx:uint=lpoint.x;
			var _ly:uint=lpoint.y;
			for (var _i:uint=_sx; _i <= _lx; _i+=1)
			{
				for (var _j:uint=_sy; _j <= _ly; _j+=1)
				{
					if (checkNodes(_i, _j))
					{
						var _node:TileView=new TileView(_i, _j);
						_node.x=TileSize * _i;
						_node.y=TileSize * _j;
						_node.idX=_i;
						_node.idY=_j;
						_container.addChild(_node);
						_dispNodes.push(_node);
					}
				}
			}
		}

		private function checkNodes(_i:uint, _j:uint):Boolean
		{

			var _l:int=0;

			while (_l < _dispNodes.length)
			{

				if (_dispNodes[_l].idX == _i && _dispNodes[_l].idY == _j)
				{
					return false;
				}

				_l++;
			}

			return true;
		}

		/**隐藏不要的**/
		private function hideNodeView(_startPoint:Point, _endPoint:Point):void
		{

			var _l:int=0;

			while (_l < _dispNodes.length)
			{
				var _node:TileView=_dispNodes[_l];
				if (_node.idX < _startPoint.x || _node.idX > _endPoint.x || _node.idY < _startPoint.y || _node.idY > _endPoint.y)
				{
					_container.removeChild(_node);
					_dispNodes.splice(_l, 1);

				}
				else
				{

					_l++;
				}
			}
		}


		protected function onMouseUpHandler(event:MouseEvent):void
		{
			_container.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			//_container.stopDrag();


		}
	}
}
