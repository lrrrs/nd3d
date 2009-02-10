package de.nulldesign.nd3d.material 
{
	import flash.display.BitmapData;		

	public class LineMaterial extends Material 
	{
		public var thickness:uint;
		
		public function LineMaterial(color:uint = 0x000000, alpha:Number = 1, thickness:uint = 1, additive:Boolean = false, calculateLights:Boolean = false) 
		{
			super(color, alpha, calculateLights, false, additive);
			this.thickness = thickness;
		}
	}
}