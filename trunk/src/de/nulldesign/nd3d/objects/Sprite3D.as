package de.nulldesign.nd3d.objects {

	import de.nulldesign.nd3d.objects.Object3D;
	import de.nulldesign.nd3d.material.Material;
	import de.nulldesign.nd3d.geom.Vertex;
	import de.nulldesign.nd3d.geom.Face;
	import flash.display.BitmapData;

	public class Sprite3D extends Object3D {
		
		public var material:Material;
		
		public function Sprite3D(mat:Material, centerX:Number = 0, centerY:Number = 0, centerZ:Number = 0) {
			super();
			
			material = mat;
			material.isSprite = true;
			
			//var v1:Vertex = new Vertex(centerX, centerY, centerZ);
			
			positionAsVertex.x = centerX;
			positionAsVertex.y = centerY;
			positionAsVertex.z = centerZ;
			
			var face:Face = new Face(this, positionAsVertex, positionAsVertex, positionAsVertex, mat);
			faceList = [face];
			//vertexList.push(v1);
		}
	}
}
