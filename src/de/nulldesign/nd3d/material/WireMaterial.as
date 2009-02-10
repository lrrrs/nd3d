package de.nulldesign.nd3d.material 
{
	public class WireMaterial extends Material 
	{
		public function WireMaterial(color:Number = 0x00FF00, alpha:Number = 1, doubleSided:Boolean = false) 
		{
			super(color, alpha, false, doubleSided, false);
		}
	}
}