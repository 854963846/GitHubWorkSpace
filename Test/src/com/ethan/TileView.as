package com.ethan
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;

	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;

	/**
	 *
	 * @author ethan
	 */
	public class TileView extends Sprite
	{
		public var idY:uint;
		public var idX:uint;
		private var _loader:Loader;

		/**
		 *
		 */
		public function TileView(x:int, y:int)
		{
			var _tf:TextField=new TextField();
			_tf.text="x=" + x + " y=" + y;
			_tf.x=10;
			_tf.y=23;

			this.addChild(_tf);
			this.mouseChildren=false;
			var _g:Graphics=this.graphics;
			_g.lineStyle(0, 0x133445, .6);
			_g.beginFill(0x133445, .5);
			_g.drawRect(0, 0, Main.TileSize, Main.TileSize);
			_g.endFill();


		/*_loader=new Loader();
		_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler);
		_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
		_loader.load(new URLRequest("image/one_1000_" + y + "_" + x + ".png"));*/

		}

		protected function onErrorHandler(event:IOErrorEvent):void
		{
			trace(event);

		}

		protected function onCompleteHandler(event:Event):void
		{
			this.addChild(_loader);
			TweenLite.from(this, .3, {alpha: .5, ease: Back.easeIn});
		}

	}
}
