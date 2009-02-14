package de.nulldesign.nd3d.objects 
{
	import flash.utils.Dictionary;

	import de.nulldesign.nd3d.geom.Face;
	import de.nulldesign.nd3d.geom.UV;
	import de.nulldesign.nd3d.geom.Vertex;
	import de.nulldesign.nd3d.material.Material;
	import de.nulldesign.nd3d.objects.Object3D;	

	public class Mesh extends Object3D 
	{

		public function Mesh() 
		{
			super();
		}

		public function addFace(v1:Vertex, v2:Vertex, v3:Vertex, material:Material = null, uvList:Array = null):void 
		{
			faceList.push(new Face(this, v1, v2, v3, material, uvList));
			if(!vertexInList(v1)) vertexList.push(v1);
			if(!vertexInList(v2)) vertexList.push(v2);
			if(!vertexInList(v3)) vertexList.push(v3);
		}

		public function vertexInList(v:Vertex):Boolean 
		{
			for(var i:Number = 0;i < vertexList.length; i++) 
			{
				if(vertexList[i] == v) 
				{
					return true;
				}
			}
			return false;
		}

		public function weldVertices(tolerance:Number = 1):void	
		{
			//trace("before: " + vertexList.length);

			var i:uint;
			var uniqueList:Dictionary = new Dictionary();
			var v:Vertex;
			var uniqueV:Vertex;
			var f:Face;
			
			// fill unique listing
			for(i = 0;i < vertexList.length; i++) 
			{
				v = vertexList[i];
				uniqueList[v] = v;
			}
			
			// step through vertices and find duplicates vertices
			for(i = 0;i < vertexList.length; i++) 
			{
				
				v = vertexList[i];
				
				for each(uniqueV in uniqueList) 
				{
					
					if(	Math.abs(v.x - uniqueV.x) <= tolerance && Math.abs(v.y - uniqueV.y) <= tolerance && Math.abs(v.z - uniqueV.z) <= tolerance) 
					{
						
						uniqueList[v] = uniqueV; // replace vertice with unique one
					}
				}
			}
			
			vertexList = [];
			
			for each(f in faceList)	
			{
				f.v1 = uniqueList[f.v1];
				f.v2 = uniqueList[f.v2];
				f.v3 = uniqueList[f.v3];
				
				if(!vertexInList(f.v1)) vertexList.push(f.v1);
				if(!vertexInList(f.v2)) vertexList.push(f.v2);
				if(!vertexInList(f.v3)) vertexList.push(f.v3);
			}
			
			//trace("after: " + vertexList.length);
		}

		public function flipNormals():void 
		{
			
			var curFace:Face;
			
			for(var i:Number = 0;i < faceList.length; i++) 
			{
				curFace = faceList[i];
				
				var tmpVertex:Vertex = curFace.v1;
				curFace.v1 = curFace.v2;
				curFace.v2 = tmpVertex;

				var tmpUV:UV = curFace.uvMap[0];
				curFace.uvMap[0] = curFace.uvMap[1];
				curFace.uvMap[1] = tmpUV;
				/*
				for (var j:uint = 0; j < curFace.uvMap.length; j++)
				{
					tmpUV = curFace.uvMap[j];
					tmpUV.u = 1 - tmpUV.u;
					//tmpUV.v = 1 - tmpUV.v;
				}*/
			}
		}

		public function clone():Mesh 
		{

			var m:Mesh = new Mesh();

			m.angleX = angleX;
			m.angleY = angleY;
			m.angleZ = angleZ;
			m.deltaAngleX = deltaAngleX;
			m.deltaAngleY = deltaAngleY;
			m.deltaAngleZ = deltaAngleZ;
			m.direction = direction.clone();
			m.quaternion = quaternion.copy();
			m.xPos = xPos;
			m.yPos = yPos;
			m.zPos = zPos;
			m.vertexList = [];
			m.faceList = [];
			
			for(var i:uint = 0;i < faceList.length; i++) 
			{
				var tmpFace:Face = faceList[i];
				
				var tmpV1:Vertex = tmpFace.v1.clone();
				var tmpV2:Vertex = tmpFace.v2.clone();
				var tmpV3:Vertex = tmpFace.v3.clone();
				
				if(!m.vertexInList(tmpV1)) 
				{
					m.vertexList.push(tmpV1);
				}
				if(!m.vertexInList(tmpV2)) 
				{
					m.vertexList.push(tmpV2);
				}
				if(!m.vertexInList(tmpV3)) 
				{
					m.vertexList.push(tmpV3);
				}

				//uv
				var tmpUVMap:Array = [];
				for(var j:uint = 0;j < tmpFace.uvMap.length; j++) 
				{
					var tmpUV:UV = tmpFace.uvMap[j];
					tmpUVMap.push(tmpUV.clone());
				}
				
				var newFace:Face = new Face(m, tmpV1, tmpV2, tmpV3, tmpFace.material.clone(), tmpUVMap);
				m.faceList.push(newFace);
			}

			return m;
		}

		/**
		 * Translate vertices coordinates
		 */
		public function translateVertices(tx:Number, ty:Number, tz:Number):void
		{
			for each(var curVertex:Vertex in vertexList)
			{
				curVertex.x += tx;
				curVertex.y += ty;
				curVertex.z += tz;
			}
		}

		/**
		 * Rotate vertices coordinates around X axis
		 * @param	angle	In radian
		 */
		public function rotateVerticesX(angle:Number):void
		{
			for each(var curVertex:Vertex in vertexList)
			{
				var y1:Number = curVertex.y * Math.cos(angle) - curVertex.z * Math.sin(angle);
				var z1:Number = curVertex.z * Math.cos(angle) + curVertex.y * Math.sin(angle);
				
				curVertex.y = y1;
				curVertex.z = z1;
			}
		}

		/**
		 * Rotate vertices coordinates around Y axis
		 * @param	angle	In radian
		 */
		public function rotateVerticesY(angle:Number):void
		{
			for each(var curVertex:Vertex in vertexList)
			{
				var x1:Number = curVertex.x * Math.cos(angle) - curVertex.z * Math.sin(angle);
				var z1:Number = curVertex.z * Math.cos(angle) + curVertex.x * Math.sin(angle);
				
				curVertex.x = x1;
				curVertex.z = z1;
			}
		}

		/**
		 * Rotate vertices coordinates around Z axis
		 * @param	angle	In radian
		 */
		public function rotateVerticesZ(angle:Number):void
		{
			for each(var curVertex:Vertex in vertexList)
			{
				var x1:Number = curVertex.x * Math.cos(angle) - curVertex.y * Math.sin(angle);
				var y1:Number = curVertex.y * Math.cos(angle) + curVertex.x * Math.sin(angle);
				
				curVertex.x = x1;
				curVertex.y = y1;
			}
		}
	}
}
