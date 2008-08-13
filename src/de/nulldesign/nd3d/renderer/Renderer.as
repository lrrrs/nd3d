package de.nulldesign.nd3d.renderer 
{
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.utils.Dictionary;

	import de.nulldesign.nd3d.geom.Face;
	import de.nulldesign.nd3d.geom.Vertex;
	import de.nulldesign.nd3d.material.Material;
	import de.nulldesign.nd3d.objects.Object3D;
	import de.nulldesign.nd3d.objects.PointCamera;
	import de.nulldesign.nd3d.renderer.Texture;	

	/**
	 * The heart of the engine. The renderer takes a list of meshes, transforms the geometry into screen coordinates and draws the triangles (faces) on the screen. 
	 * There are several options you can set:<br/><br/>
	 * 
	 * <b>wireFrameMode:</b> Switches the renderer to wireframe mode, only the outlines of faces are drawn<br/>
	 * <b>dynamicLighting:</b> Turns on/off dynamic lighting<br/>
	 * <b>ambientColor:</b> Defines the ambient light color. The dynamic lighting color is mixed against this color.<br/>
	 * <b>ambientColorCorrection:</b> Use if your scene is too bright / dark when using dynamic lighting (0-1).<br/>
	 * <b>additiveMode:</b> Turns on/off additive blending of materials. All materials that have additiveblending enabled are drawn additive<br/>
	 * <b>blurMode:</b> Turns on/off distanceblur. Meshes are blurred in relation of distance to the camera<br/>
	 * <b>distanceBlur:</b> Sets the amount of blurring<br/>
	 * <br/>
	 * <b>facesRendered:</b> Render statistics, calculated every frame<br/>
	 * <b>facesTotal:</b> Render statistics, calculated every frame<br/>
	 * <b>meshesTotal:</b> Render statistics, calculated every frame <br/>
	 * <b>verticesProcessed:</b> Render statistics, calculated every frame<br/> 
	 * 
	 * @author Lars Gerckens (www.nulldesign.de)
	 */
	public class Renderer 
	{

		private var stage:Sprite;

		public var wireFrameMode:Boolean = false;
		public var dynamicLighting:Boolean = false;
		public var ambientColor:uint = 0x000000;
		public var ambientColorCorrection:Number = 0.0;
		public var additiveMode:Boolean = false;
		public var distanceBlur:Number = 20;
		public var blurMode:Boolean = false;

		public var facesRendered:Number = 0;
		public var facesTotal:Number = 0;
		public var meshesTotal:Number = 0;
		public var verticesProcessed:Number = 0;

		private var meshToStage:Dictionary;

		/**
		 * Constructor of class Renderer
		 * @param all geometry is renderes to the graphichs object of this sprite
		 */
		public function Renderer(stage:Sprite) 
		{
			this.stage = stage;
			meshToStage = new Dictionary(true);
		}

		/**
		 * Calculates translations, rotations for every vertex in a mesh, does depth sorting of faces and finally calculates the screencoordinates.
		 * (Use this method only if you want to implement your own renderer and just need the transforms!)
		 * @param a list of meshes
		 * @param a camera instance
		 * @return a depth sorted list of transformed faces
		 */
		public function project(meshList:Array, cam:PointCamera):Array 
		{
			
			facesRendered = 0;
			verticesProcessed = 0;
			facesTotal = 0;
			meshesTotal = meshList.length;
			
			// cam rotation
			var cosZ:Number = Math.cos(cam.angleZ);
			var sinZ:Number = Math.sin(cam.angleZ);
			var cosY:Number = Math.cos(cam.angleY);
			var sinY:Number = Math.sin(cam.angleY);
			var cosX:Number = Math.cos(cam.angleX);
			var sinX:Number = Math.sin(cam.angleX);
			/*
			// the quarternion way...			
			var tmpQuat:Quaternion = new Quaternion();
			tmpQuat.eulerToQuaternion(-cam.deltaAngleX, -cam.deltaAngleY, -cam.deltaAngleZ);
			cam.quaternion.concat(tmpQuat);
			cam.deltaAngleX = 0;
			cam.deltaAngleY = 0;
			cam.deltaAngleZ = 0;
			 */
			// local rotation
			/**/
			var cosZMesh:Number;
			var sinZMesh:Number;
			var cosYMesh:Number;
			var sinYMesh:Number;
			var cosXMesh:Number;
			var sinXMesh:Number;

			var i:uint = meshList.length;
			var j:uint;
			var curMesh:Object3D;
			var curVertex:Vertex;
			var x:Number;
			var y:Number;
			var x1:Number;
			var x2:Number;
			var x3:Number;
			var x4:Number;
			var y1:Number;
			var y2:Number;
			var y3:Number;
			var y4:Number;
			var z1:Number;
			var z2:Number;
			var z3:Number;
			var z4:Number;
			var scale:Number;
			var faceList:Array = [];
			var vertexList:Array = [];
			
			while(--i > -1) 
			{ 
				// step through meshes

				curMesh = meshList[i];
				
				if(!curMesh.hidden) 
				{

					faceList = faceList.concat(curMesh.faceList);
					vertexList = curMesh.vertexList;
	
					j = vertexList.length;

					cosZMesh = Math.cos(curMesh.angleZ);
					sinZMesh = Math.sin(curMesh.angleZ);
					cosYMesh = Math.cos(curMesh.angleY);
					sinYMesh = Math.sin(curMesh.angleY);
					cosXMesh = Math.cos(curMesh.angleX);
					sinXMesh = Math.sin(curMesh.angleX);
					/*
					// rotation
					// the quarternion way...
					tmpQuat = new Quaternion();
					tmpQuat.eulerToQuaternion(curMesh.deltaAngleX, curMesh.deltaAngleY, curMesh.deltaAngleZ);
					curMesh.quaternion.concat(tmpQuat);
					curMesh.deltaAngleX = 0;
					curMesh.deltaAngleY = 0;
					curMesh.deltaAngleZ = 0;
					 */
					while(--j > -1) 
					{ 
						// step through vertexlist

						++verticesProcessed;
					
						curVertex = vertexList[j];
						/*					
						// the quarternion way...
						tmpVertex = curVertex.clone();
						tmpVertex = curVertex.rotatePoint(curMesh.quaternion);
						x2 = tmpVertex.x;
						y2 = tmpVertex.y;
						z2 = tmpVertex.z;
						 */					
						// local coordinate rotation x,y,z					
						// z axis
						x1 = (curVertex.x * curMesh.scaleX) * cosZMesh - (curVertex.y * curMesh.scaleY) * sinZMesh;
						y1 = (curVertex.y * curMesh.scaleY) * cosZMesh + (curVertex.x * curMesh.scaleX) * sinZMesh;
						// y axis
						x2 = x1 * cosYMesh - (curVertex.z * curMesh.scaleZ) * sinYMesh;
						z1 = (curVertex.z * curMesh.scaleZ) * cosYMesh + x1 * sinYMesh;
						// x axis
						y2 = y1 * cosXMesh - z1 * sinXMesh;
						z2 = z1 * cosXMesh + y1 * sinXMesh;

						// local coordinate movement
						x2 += curMesh.xPos;
						y2 += curMesh.yPos;
						z2 += curMesh.zPos;

						// camera movement -minus because we must get to 0,0,0
						x2 -= cam.x;
						y2 -= cam.y;
						z2 -= cam.z;
						
						// camera view rotation x,y,z
						x3 = x2 * cosZ - y2 * sinZ;
						y3 = y2 * cosZ + x2 * sinZ;

						x4 = x3 * cosY - z2 * sinY;
						z3 = z2 * cosY + x3 * sinY;
						
						y4 = y3 * cosX - z3 * sinX;
						z4 = z3 * cosX + y3 * sinX;
						/*
						// the quarternion way...
						tmpVertex = new Vertex(x2, y2, z2);
						tmpVertex = tmpVertex.rotatePoint(cam.quaternion);
						x4 = tmpVertex.x;
						y4 = tmpVertex.y;
						z4 = tmpVertex.z;
						 */					
						// final screen coordinates (3d to 2d)
						scale = cam.fl / (cam.fl + z4 + cam.zOffset);
						x = cam.vpX + x4 * scale;
						y = cam.vpY + y4 * scale;

						curVertex.screenX = x;
						curVertex.screenY = y;
						curVertex.scale = scale;
						
						// save rotated point, we need it later
						curVertex.x3d = x4;
						curVertex.y3d = y4;
						curVertex.z3d = z4;
					}
				}
			}
			
			// sort
			faceList = faceList.sort(faceZSort);
			
			return faceList;
		}

		/**
		 * Processes a list of meshes, and draws them on the screen
		 * @param a list of meshes
		 * @param a camera instance
		 */
		public function render(meshList:Array, cam:PointCamera):void 
		{
			
			var faceList:Array = project(meshList, cam); 
			// Mr.doob was here.
			drawToScreen(faceList, cam);
		}

		/**
		 * Takes a list of faces and draws them on the screen
		 * (Should not be used directly, but at least you could, if you calculated your faces in an other way...)
		 * @param a list of faces
		 * @param a camera instance
		 */
		public function drawToScreen(faceList:Array, cam:PointCamera):void 
		{

			clearStage(stage);
			
			var curStage:Sprite;
			var curFace:Face;
			var curMaterial:Material;
			var curColor:uint;
			var faceIndex:uint = 0;

			facesTotal = faceList.length;
			
			// render faces
			for(faceIndex = 0;faceIndex < facesTotal; faceIndex++) 
			{
				
				curFace = faceList[faceIndex];
				curMaterial = curFace.material;
				
				if((wireFrameMode || curMaterial.doubleSided || curMaterial.isSprite || !isBackFace(curFace.v1, curFace.v2, curFace.v3)) && (curFace.v1.z3d > -cam.fl - cam.zOffset && curFace.v2.z3d > -cam.fl - cam.zOffset && curFace.v3.z3d > -cam.fl - cam.zOffset)) 
				{ 
					// face needs to be doublesided OR not backfacing AND not out of screen

					++facesRendered;
				   
					curStage = getStage(curFace, curMaterial, faceIndex);
					
					// simple dynamic lighting
					if(dynamicLighting && curMaterial.calculateLights)
					{
						curColor = getMatColor(curMaterial.color, curFace.v1, curFace.v2, curFace.v3, cam);
					}
					else
					{
						curColor = curMaterial.color;
					}
					
					if(curFace.material.texture == null || wireFrameMode)
					{ 
						// render solid

						if(wireFrameMode)
						{
							curStage.graphics.lineStyle(1, 0xFFFFFF, 1);
						}
						else
						{
							curStage.graphics.beginFill(curColor, curMaterial.alpha);
						}
						
						curStage.graphics.moveTo(curFace.v1.screenX, curFace.v1.screenY);
						curStage.graphics.lineTo(curFace.v2.screenX, curFace.v2.screenY);
						curStage.graphics.lineTo(curFace.v3.screenX, curFace.v3.screenY);
						curStage.graphics.lineTo(curFace.v1.screenX, curFace.v1.screenY);
						curStage.graphics.endFill();
					}
					else
					{ 
						// render texture
						if(curMaterial.isSprite) // draw normal 2d sprite
						{ 
							Texture.render2DSprite(curStage, curMaterial.texture, curFace.v1);
						}
						else // texture mapping
						{ 
							Texture.renderUV(curStage, curMaterial, curFace.v1, curFace.v2, curFace.v3, curFace.uvMap, (curColor / curMaterial.color) + ambientColorCorrection, ambientColor);
						}
					}
				}
			}
		}

		/**
		 * retrieves the right clip for the given face
		 * @param current face
		 * @param face material
		 * @param depth of the face
		 * @return sprite
		 */
		private function getStage(face:Face, mat:Material, faceIndex:uint):Sprite 
		{
			
			var tmpStage:Sprite = stage;

			if(blurMode) 
			{
				if(meshToStage[face.meshRef] == null) 
				{ 
					var s:Sprite = new Sprite();
					s.filters = [new BlurFilter(1, 1, 2)];
					tmpStage.addChild(s);
					meshToStage[face.meshRef] = s;
				}

				tmpStage = meshToStage[face.meshRef];
				// bring to front
				stage.removeChild(tmpStage);
				stage.addChild(tmpStage);
				
				// apply blur
				var avgDistance:Number = 1 - (face.v1.scale + face.v2.scale + face.v3.scale) / 3;
				var blur:BlurFilter = tmpStage.filters[0];
				blur.blurX = blur.blurY = (distanceBlur * avgDistance);
				tmpStage.filters = [blur];
			}
			
			// check if we've got enough sprites to draw faces on, we need a sprite for every new face
			if(additiveMode) 
			{
				while(tmpStage.numChildren < facesTotal) 
				{
					tmpStage.addChild(new Sprite());
				}
				tmpStage = Sprite(tmpStage.getChildAt(faceIndex));
				tmpStage.blendMode = mat.additive ? BlendMode.ADD : BlendMode.NORMAL;
			}
			
			return tmpStage;
		}

		private function clearStage(tmpStage:Sprite):void 
		{
			tmpStage.graphics.clear();
			for(var i:uint = 0;i < tmpStage.numChildren; i++) 
			{
				clearStage(Sprite(tmpStage.getChildAt(i)));
			}
		}

		/**
		 * Calculates the current color of a given face. Simple angle to camera calculation
		 * @param facecolor
		 * @param vertex 1
		 * @param vertex 2
		 * @param vertex 3
		 * @param camera instance
		 * @return
		 */
		private function getMatColor(color:Number, fv1:Vertex, fv2:Vertex, fv3:Vertex, cam:PointCamera):Number 
		{

			// dynamic lighting
			var r:uint = color >> 16;
			var g:uint = color >> 8 & 0xFF;
			var b:uint = color & 0xFF;
			
			var lightVertex:Vertex = new Vertex(cam.x, cam.y, cam.z - cam.zOffset);
			
			var v1:Vertex = new Vertex(fv1.x3d - fv2.x3d, fv1.y3d - fv2.y3d, fv1.z3d - fv2.z3d);
			var v2:Vertex = new Vertex(fv2.x3d - fv3.x3d, fv2.y3d - fv3.y3d, fv2.z3d - fv3.z3d);
			
			var norm:Vertex = v1.cross(v2);
			
			var lightIntensity:Number = norm.dot(lightVertex);
			var normMag:Number = norm.length;
			var lightMag:Number = lightVertex.length;
			
			var factor:Number = (Math.acos(lightIntensity / (normMag * lightMag)) / Math.PI); 
			
			r *= factor;
			g *= factor;
			b *= factor;

			return (r << 16 | g << 8 | b);
		}

		/**
		 * Simple backface calculation
		 */
		private function isBackFace(pa:Vertex, pb:Vertex, pc:Vertex):Boolean 
		{
			/*
			var cax:Number = pc.screenX - pa.screenX;
			var cay:Number = pc.screenY - pa.screenY;
			var bcx:Number = pb.screenX - pc.screenX;
			var bcy:Number = pb.screenY - pc.screenY;
			return cax * bcy > cay * bcx;
			 */
			return (  (pc.screenX - pa.screenX) * (pb.screenY - pa.screenY) - (pc.screenY - pa.screenY) * (pb.screenX - pa.screenX) < 0);
		}

		/**
		 * Simple z-sort algorithm
		 */
		private function faceZSort(ta:Face, tb:Face):Number 
		{

			var za:Number = (ta.v1.z3d + ta.v2.z3d + ta.v3.z3d) / 3;
			var zb:Number = (tb.v1.z3d + tb.v2.z3d + tb.v3.z3d) / 3;
			/*	
			var za:Number = (ta.v1.scale + ta.v2.scale + ta.v3.scale) / 3;
			var zb:Number = (tb.v1.scale + tb.v2.scale + tb.v3.scale) / 3;
			 */
			if(za > zb) 
			{
				return -1;
			} else 
			{
				return 1;
			}
		}
	}
}