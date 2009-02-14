package de.nulldesign.nd3d.material 
{

	public class WireMaterial extends Material 
	{
		public var fillColor:Number;
		public var fillAlpha:Number;

		public function WireMaterial(color:Number = 0x00FF00, alpha:Number = 1, doubleSided:Boolean = false, fillColor:Number = 0, fillAlpha:Number = 0) 
		{
			super(color, alpha, false, doubleSided, false);
			this.fillAlpha = fillAlpha;
			this.fillColor = fillColor;
		}
	}
}