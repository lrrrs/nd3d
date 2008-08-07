﻿package de.nulldesign.nd3d.objects 
{
	import de.nulldesign.nd3d.geom.Vertex;
	
	/**
	* ...
	* @author DefaultUser (Tools -> Custom Arguments...)
	*/
	public class Cube extends Mesh
	{
		public function Cube(materialList:Array, size:Number = 100, steps:Number = 3) 
		{
			super();
			createCube(materialList, size, steps);
		}
		
		private function createCube(materialList:Array, size:Number = 100, steps:Number = 3):void
		{
			var i:Number;
			var curVertex:Vertex;
			var x1:Number;
			var y1:Number;
			var z1:Number;
			
			// front
			var tmpMesh:Mesh = new Plane(size, size, steps, steps, materialList[0]);
			var vList:Array = tmpMesh.vertexList;
			for(i = 0; i < vList.length; i++)
			{
				vList[i].z += -size / 1;
			}

			vertexList = vertexList.concat(tmpMesh.vertexList);
			faceList = faceList.concat(tmpMesh.faceList);

			// right
			tmpMesh = new Plane(size, size, steps, steps, materialList[1]);
			vList = tmpMesh.vertexList;
			for(i = 0; i < vList.length; i++)
			{
				curVertex = vList[i];
				
				x1 = curVertex.x * Math.cos(Object3D.deg2rad(90)) - curVertex.z * Math.sin(Object3D.deg2rad(90));
				z1 = curVertex.z * Math.cos(Object3D.deg2rad(90)) + curVertex.x * Math.sin(Object3D.deg2rad(90));
				
				curVertex.x = x1;
				curVertex.z = z1;
				curVertex.x += size / 1;
			}

			vertexList = vertexList.concat(tmpMesh.vertexList);
			faceList = faceList.concat(tmpMesh.faceList);

			// left
			tmpMesh = new Plane(size, size, steps, steps, materialList[2]);
			vList = tmpMesh.vertexList;
			for(i = 0; i < vList.length; i++)
			{
				curVertex = vList[i];
				
				x1 = curVertex.x * Math.cos(Object3D.deg2rad(-90)) - curVertex.z * Math.sin(Object3D.deg2rad(-90));
				z1 = curVertex.z * Math.cos(Object3D.deg2rad(-90)) + curVertex.x * Math.sin(Object3D.deg2rad(-90));
				
				curVertex.x = x1;
				curVertex.z = z1;
				curVertex.x += -size / 1;
			}
			
			vertexList = vertexList.concat(tmpMesh.vertexList);
			faceList = faceList.concat(tmpMesh.faceList);

			// back
			tmpMesh = new Plane(size, size, steps, steps, materialList[3]);
			vList = tmpMesh.vertexList;
			for(i = 0; i < vList.length; i++)
			{
				
				curVertex = vList[i];
				
				x1 = curVertex.x * Math.cos(Object3D.deg2rad(180)) - curVertex.z * Math.sin(Object3D.deg2rad(180));
				z1 = curVertex.z * Math.cos(Object3D.deg2rad(180)) + curVertex.x * Math.sin(Object3D.deg2rad(180));
				
				curVertex.x = x1;
				curVertex.z = z1;
				curVertex.z += size / 1;
			}
			
			vertexList = vertexList.concat(tmpMesh.vertexList);
			faceList = faceList.concat(tmpMesh.faceList);

			// bottom
			tmpMesh = new Plane(size, size, steps, steps, materialList[4]);
			vList = tmpMesh.vertexList;
			for(i = 0; i < vList.length; i++)
			{
				
				curVertex = vList[i];
				
				y1 = curVertex.y * Math.cos(Object3D.deg2rad(90)) - curVertex.z * Math.sin(Object3D.deg2rad(90));
				z1 = curVertex.z * Math.cos(Object3D.deg2rad(90)) + curVertex.y * Math.sin(Object3D.deg2rad(90));
				
				curVertex.y = y1;
				curVertex.z = z1;
				curVertex.y += size / 1;
			}
			
			vertexList = vertexList.concat(tmpMesh.vertexList);
			faceList = faceList.concat(tmpMesh.faceList);

			// top
			tmpMesh = new Plane(size, size, steps, steps, materialList[5]);
			vList = tmpMesh.vertexList;
			
			for(i = 0; i < vList.length; i++)
			{
				curVertex = vList[i];
				
				y1 = curVertex.y * Math.cos(Object3D.deg2rad(-90)) - curVertex.z * Math.sin(Object3D.deg2rad(-90));
				z1 = curVertex.z * Math.cos(Object3D.deg2rad(-90)) + curVertex.y * Math.sin(Object3D.deg2rad(-90));
				
				curVertex.y = y1;
				curVertex.z = z1;
				curVertex.y += -size / 1;
			}
			
			vertexList = vertexList.concat(tmpMesh.vertexList);
			faceList = faceList.concat(tmpMesh.faceList);
			weldVertices();
			
			vertexList.push(positionAsVertex);
		}
		
	}
	
}