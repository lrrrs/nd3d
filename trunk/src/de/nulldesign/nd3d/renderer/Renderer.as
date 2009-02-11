package de.nulldesign.nd3d.renderer 
{
	import de.nulldesign.nd3d.events.Mouse3DEvent;
	import de.nulldesign.nd3d.material.LineMaterial;
	import de.nulldesign.nd3d.material.PixelMaterial;
	import de.nulldesign.nd3d.material.WireMaterial;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.utils.Dictionary;

	import de.nulldesign.nd3d.geom.Face;
	import de.nulldesign.nd3d.geom.Vertex;
	import de.nulldesign.nd3d.material.Material;
	import de.nulldesign.nd3d.objects.Object3D;
	import de.nulldesign.nd3d.objects.PointCamera;
	import de.nulldesign.nd3d.renderer.TextureRenderer;	

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
	public class Renderer extends EventDispatcher
	{
		private var stage:Sprite;
		private var drawStage:Sprite;
		private var interactiveStage:Sprite;

		public var wireFrameMode:Boolean = false;
		public var dynamicLighting:Boolean = false;
		public var ambientColor:uint = 0x000000;
		public var ambientColorCorrection:Number = 0.0;
		public var additiveMode:Boolean = false;
		public var distanceBlur:Number = 20;
		public var blurMode:Boolean = false;

		public var facesRendered:int = 0;
		public var facesTotal:int = 0;
		public var meshesTotal:int = 0;
		public var verticesProcessed:int = 0;

		private var meshToStage:Dictionary;
		
		private var lastHighlightMesh:Object3D;
		private var lastHighlightFace:Face;
		private var currentHighlightMesh:Object3D;
		private var currentHighlightedFace:Face;
		
		/**
		 * Constructor of class Renderer
		 * @param all geometry is renderes to the graphichs object of this sprite
		 */
		public function Renderer(stage:Sprite) 
		{
			this.stage = stage;
			drawStage = this.stage.addChild(new Sprite()) as Sprite; // draw area
			interactiveStage = this.stage.addChild(new Sprite()) as Sprite; // interactive overlay
			interactiveStage.buttonMode = true;
			interactiveStage.useHandCursor = true;
			interactiveStage.addEventListener(MouseEvent.CLICK, interactiveMouseClick);
			
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

			var i:int = meshList.length;
			var j:int;
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
			var curStageGfx:Graphics;
			var curFace:Face;
			var curMaterial:Material;
			var curColor:uint;
			var faceIndex:int = 0;
			var defaultTexRenderer:TextureRenderer = new TextureRenderer();
			
			var thickness:Number;
			
			clearStage(drawStage);
			clearStage(interactiveStage);
			
			currentHighlightedFace = null;
			currentHighlightMesh = null;
			
			facesTotal = faceList.length;
			
			// render faces
			for(faceIndex = 0;faceIndex < facesTotal; faceIndex++) 
			{
				
				curFace = faceList[faceIndex];
				curMaterial = curFace.material;
				
				// face needs to be doublesided OR not backfacing AND not out of screen
				if((wireFrameMode || curMaterial.doubleSided || curMaterial.isSprite || 
					!isBackFace(curFace.v1, curFace.v2, curFace.v3)) && 
					(curFace.v1.z3d > -cam.fl - cam.zOffset && curFace.v2.z3d > -cam.fl - cam.zOffset && curFace.v3.z3d > -cam.fl - cam.zOffset)) 
				{
					++facesRendered;
				   
					curStageGfx = getStage(curFace, curMaterial, faceIndex).graphics;
					
					// simple dynamic lighting
					if(dynamicLighting && curMaterial.calculateLights)
					{
						curColor = getMatColor(curMaterial.color, curFace.v1, curFace.v2, curFace.v3, cam);
					}
					else
					{
						curColor = curMaterial.color;
					}
					
					// pixel material
					if(curMaterial is PixelMaterial)
					{
						thickness = PixelMaterial(curMaterial).thickness;

						curStageGfx.beginFill(curMaterial.color, curMaterial.alpha);
						curStageGfx.drawCircle(curFace.v1.screenX, curFace.v1.screenY, thickness);
						curStageGfx.drawCircle(curFace.v2.screenX, curFace.v2.screenY, thickness);
						curStageGfx.drawCircle(curFace.v3.screenX, curFace.v3.screenY, thickness);
					}
					else if(curMaterial is LineMaterial) // render line
					{
						var v0:Vertex;
						var v1:Vertex;
						var length:uint 		= curFace.vertexList.length;
						thickness = LineMaterial(curMaterial).thickness;
						var alpha:Number 		= curMaterial.alpha;
						
						curStageGfx.lineStyle(thickness, curColor, alpha);
						
						for(var i:uint = 0; i < length - 1; i++)
						{
							v0 = curFace.vertexList[i];
							v1 = curFace.vertexList[i+1];
							curStageGfx.moveTo(v0.screenX, v0.screenY);
							curStageGfx.lineTo(v1.screenX, v1.screenY);
							curStageGfx.endFill();
						}
					}
					else if(curMaterial.texture == null || wireFrameMode || curMaterial is WireMaterial) // render solid or wire
					{ 
						if(wireFrameMode)
						{
							curStageGfx.lineStyle(1, 0xFFFFFF, 1);
						}
						else
						{
							if(curMaterial is WireMaterial)
							{
								curStageGfx.lineStyle(1, curMaterial.color, curMaterial.alpha);
							}
							else
							{
								curStageGfx.lineStyle();
								curStageGfx.beginFill(curColor, curMaterial.alpha);
							}
						}
						
						curStageGfx.moveTo(curFace.v1.screenX, curFace.v1.screenY);
						curStageGfx.lineTo(curFace.v2.screenX, curFace.v2.screenY);
						curStageGfx.lineTo(curFace.v3.screenX, curFace.v3.screenY);
						curStageGfx.lineTo(curFace.v1.screenX, curFace.v1.screenY);
						curStageGfx.endFill();
					}
					else
					{
						curStageGfx.lineStyle();
						
						// render texture
						var texRenderer:TextureRenderer = curMaterial.customRenderer || defaultTexRenderer;
						
						if(curMaterial.isSprite) // draw normal 2d sprite
						{ 
							texRenderer.render2DSprite(curStageGfx, curMaterial.texture, curFace.v1);
						}
						else // texture mapping
						{ 
							texRenderer.renderUV(curStageGfx, curMaterial, curFace.v1, curFace.v2, curFace.v3, curFace.uvMap, (curColor / curMaterial.color) + ambientColorCorrection, ambientColor);
						}
					}
					
					// check for mouse interaction
					if(curMaterial.isInteractive || curFace.meshRef.isInteractive)
					{
						if(checkMouse(curFace))
						{
							interactiveStage.graphics.beginFill(0xffffff, 0.0);
							interactiveStage.graphics.moveTo(curFace.v1.screenX, curFace.v1.screenY);
							interactiveStage.graphics.lineTo(curFace.v2.screenX, curFace.v2.screenY);
							interactiveStage.graphics.lineTo(curFace.v3.screenX, curFace.v3.screenY);
							interactiveStage.graphics.lineTo(curFace.v1.screenX, curFace.v1.screenY);
							interactiveStage.graphics.endFill();
						
							currentHighlightedFace = curFace;
							currentHighlightMesh = curFace.meshRef;
						}
					}
				}
			}
			
			if(currentHighlightedFace && currentHighlightMesh != lastHighlightMesh)
			{
				dispatchEvent(new Mouse3DEvent(Mouse3DEvent.MOUSE_OVER, currentHighlightMesh, currentHighlightedFace));
				lastHighlightMesh = currentHighlightMesh;
				lastHighlightFace = currentHighlightedFace;
			}
			else if(!currentHighlightedFace && lastHighlightFace)
			{
				dispatchEvent(new Mouse3DEvent(Mouse3DEvent.MOUSE_OUT, lastHighlightMesh, lastHighlightFace));
				lastHighlightFace = null;
				lastHighlightMesh = null;
			}
		}

		private function interactiveMouseClick(e:MouseEvent):void 
		{
			if(currentHighlightMesh)
			{
				dispatchEvent(new Mouse3DEvent(Mouse3DEvent.MOUSE_CLICK, currentHighlightMesh, currentHighlightedFace));
			}
		}

		private function checkMouse(face:Face):Boolean
		{
			// algorithm from http://www.blackpawn.com/texts/pointinpoly/default.html
			// Compute vectors    
			var v0:Vertex = new Vertex(face.v3.screenX - face.v1.screenX, face.v3.screenY - face.v1.screenY, 0);
			var v1:Vertex = new Vertex(face.v2.screenX - face.v1.screenX, face.v2.screenY - face.v1.screenY, 0);
			var v2:Vertex = new Vertex(drawStage.mouseX - face.v1.screenX, drawStage.mouseY - face.v1.screenY, 0);
			// Compute dot products
			var dot00:Number = v0.dot(v0);
			var dot01:Number = v0.dot(v1);
			var dot02:Number = v0.dot(v2);
			var dot11:Number = v1.dot(v1);
			var dot12:Number = v1.dot(v2);
			// Compute barycentric coordinates
			var invDenom:Number = 1 / (dot00 * dot11 - dot01 * dot01);
			var u:Number = (dot11 * dot02 - dot01 * dot12) * invDenom;
			var v:Number = (dot00 * dot12 - dot01 * dot02) * invDenom;
			// Check if point is in triangle
			return (u > 0) && (v > 0) && (u + v < 1);
		}

		/**
		 * retrieves the right clip for the given face
		 * @param current face
		 * @param face material
		 * @param depth of the face
		 * @return sprite
		 */
		private function getStage(face:Face, mat:Material, faceIndex:int):Sprite 
		{
			var tmpStage:Sprite = drawStage;
			var newStage:Sprite;
			
			// resolve/create container sprite
			if(face.meshRef.container)
			{
				if (!face.meshRef.container.parent) tmpStage.addChild(face.meshRef.container);
				meshToStage[face.meshRef] = tmpStage = face.meshRef.container;
				// bring to front
				drawStage.addChild(tmpStage);
			}
			else if(blurMode || additiveMode)
			{
				if (meshToStage[face.meshRef] == null) 
				{ 
					newStage = new Sprite();
					tmpStage.addChild(newStage);
					meshToStage[face.meshRef] = tmpStage = newStage;
				}
				else tmpStage = meshToStage[face.meshRef];
				// bring to front
				if (!additiveMode) drawStage.addChild(tmpStage);
			}
			
			// apply blur
			if(blurMode) 
			{
				var avgDistance:Number = 1 - (face.v1.scale + face.v2.scale + face.v3.scale) / 3;
				var blur:BlurFilter = (tmpStage.filters && tmpStage.filters.length) ? 
					tmpStage.filters[0] : new BlurFilter(1, 1, 2);
				blur.blurX = blur.blurY = (distanceBlur * avgDistance);
				tmpStage.filters = [blur];
			}
			
			// apply blend mode
			if(additiveMode) 
			{
				tmpStage.blendMode = mat.additive ? BlendMode.ADD : BlendMode.NORMAL;
			}
			
			return tmpStage;
		}

		private function clearStage(tmpStage:Sprite):void 
		{
			tmpStage.graphics.clear();
			for(var i:int = 0;i < tmpStage.numChildren; i++) 
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
		private function getMatColor(color:Number, fv1:Vertex, fv2:Vertex, fv3:Vertex, cam:PointCamera):uint
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
			return (za > zb) ? -1 : 1;
		}
	}
}
