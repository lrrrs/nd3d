package de.nulldesign.nd3d.material 
{
	import flash.display.BitmapData;		

	public class Material 
	{

		public var color:Number;
		public var alpha:Number;
		public var texture:BitmapData;
		public var isSprite:Boolean;
		public var doubleSided:Boolean = false;
		public var smoothed:Boolean = false;
		public var additive:Boolean = false;
		public var calculateLights:Boolean = true;

		public function Material(color:Number, alpha:Number, texture:BitmapData = null, doubleSided:Boolean = false, smoothed:Boolean = false, additive:Boolean = false, calculateLights:Boolean = false) 
		{
			this.color = color;
			this.alpha = alpha;
			this.texture = texture;
			this.doubleSided = doubleSided;
			this.smoothed = smoothed;
			this.additive = additive;
			this.calculateLights = calculateLights;
		}

		public function clone():Material 
		{
			return new Material(color, alpha, texture, doubleSided, smoothed, additive, calculateLights);
		}
	}
}
