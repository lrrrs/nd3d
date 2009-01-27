package de.nulldesign.nd3d.utils
{
	import de.nulldesign.nd3d.material.Material;
	import de.nulldesign.nd3d.utils.MD2;
	import de.nulldesign.nd3d.objects.Mesh;
	
	import flash.utils.ByteArray;
	
    public class MD2Parser
    { 	
		public var mesh:Mesh;
		
        /**
         * @author katopz@sleepydesign.com
         */		
        public function MD2Parser(data:ByteArray, mat:Material)
        {
            mesh = new MD2(mat,data);
        }
	
		public static function parseFile(data:ByteArray, mat:Material, defaultMaterial:Material = null):Mesh 
        {
			if(defaultMaterial == null) 
			{
				defaultMaterial = new Material(0xFF9900, 1);
			}
			
            return new MD2Parser(data, mat ? mat : defaultMaterial).mesh;
        }
    }
}