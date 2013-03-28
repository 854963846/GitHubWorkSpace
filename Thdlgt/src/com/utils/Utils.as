package com.utils
{
	import com.plane.enemy.FirstTypeEnemy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class Utils
	{
		public function Utils()
		{
		}
	
		/**
		 * 克隆位图
		 */
		public static function cloneBitMap(bmp:Bitmap):Bitmap
		{
			var bmpd:BitmapData = bmp.bitmapData;
			var b:BitmapData = bmpd.clone();
			return new Bitmap(b);
		}
		
		/**
		 * 克隆对象
		 */
		public static function cloneObject(_obj:Object):Object
		{
			var qClassName:String = getQualifiedClassName(_obj);
			var objectType:Class = getDefinitionByName(qClassName) as Class;
			registerClassAlias(qClassName, objectType);
			var ba:ByteArray = new ByteArray();
			ba.writeObject(_obj);
			ba.position=0;
			var b:Object;
			try
			{
				b = ba.readObject();
			} 
			catch(error:Error) 
			{
				
			}
			return b;
		}
	}
}