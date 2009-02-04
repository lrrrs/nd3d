package de.nulldesign.nd3d.material 
{
	import de.nulldesign.nd3d.renderer.TextureRenderer;
	import flash.display.BitmapData;

	public class Material 
	{
		protected var _color:uint = 0xffffff;
		protected var _alpha:Number = 1;
		protected var _texture:BitmapData = null;
		public var isSprite:Boolean;
		public var doubleSided:Boolean = false;
		public var smoothed:Boolean;
		public var additive:Boolean = false;
		public var calculateLights:Boolean = true;
		public var isInteractive:Boolean = false;
		public var customRenderer:TextureRenderer;

		public function Material(color:uint, alpha:Number = 1, calculateLights:Boolean = false, doubleSided:Boolean = false, additive:Boolean = false) 
		{
			this.color = color;
			this.alpha = alpha;
			this.doubleSided = doubleSided;
			this.additive = additive;
			this.calculateLights = calculateLights;
		}

		public function clone():Material 
		{
			return new Material(color, alpha, calculateLights, doubleSided, additive);
		}
		
		public function get color():uint { return _color; }
		public function set color(value:uint):void { _color = value; }
		
		public function get alpha():Number { return _alpha; }
		public function set alpha(value:Number):void { _alpha = value; }
		
		public function get texture():BitmapData { return _texture; }
		public function set texture(value:BitmapData):void  { _texture = value; }
	}
}
