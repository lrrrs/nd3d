package de.nulldesign.nd3d.objects 
{
	import de.nulldesign.nd3d.geom.Quaternion;
	import de.nulldesign.nd3d.geom.Vertex;	

	import flash.display.Sprite;

	public class Object3D 
	{
		public var name:String;
		public var userData:*;

		public var hidden:Boolean = false;
		public var container:Sprite;

		public var faceList:Array;
		public var vertexList:Array;
		public var positionAsVertex:Vertex;

		public var direction:Vertex;

		public var xPos:Number = 0;
		public var yPos:Number = 0;
		public var zPos:Number = 0;

		public var isInteractive:Boolean = false;

		private var _angleX:Number = 0;

		public function set angleX(angle:Number):void 
		{
			deltaAngleX = angle - _angleX;
			_angleX = angle;
		}

		public function get angleX():Number 
		{
			return _angleX;
		}

		private var _angleY:Number = 0;

		public function set angleY(angle:Number):void 
		{
			deltaAngleY = angle - _angleY;
			_angleY = angle;
		}

		public function get angleY():Number 
		{
			return _angleY;
		}

		private var _angleZ:Number = 0;

		public function set angleZ(angle:Number):void 
		{
			deltaAngleZ = angle - _angleZ;
			_angleZ = angle;
		}

		public function get angleZ():Number 
		{
			return _angleZ;
		}

		public var deltaAngleX:Number = 0;
		public var deltaAngleY:Number = 0;
		public var deltaAngleZ:Number = 0;

		public var scaleX:Number = 1;
		public var scaleY:Number = 1;
		public var scaleZ:Number = 1;

		public var quaternion:Quaternion;

		public function Object3D() 
		{
			faceList = [];
			vertexList = [];
			direction = new Vertex(1, 0, 0);
			quaternion = new Quaternion();
			positionAsVertex = new Vertex(0, 0, 0);
			vertexList.push(positionAsVertex);
		}

		public function scale(x:Number = 1, y:Number = 1, z:Number = 1):void 
		{
			scaleX = x;
			scaleY = y;
			scaleZ = z;
		}

		public function lookAtTarget(target:Object3D):void 
		{
			
			var dx:Number = (target.xPos - xPos);
			var dy:Number = (target.yPos - yPos);
			var dz:Number = (target.zPos - zPos);
			
			angleZ = -Math.atan2(-dy, Math.sqrt(dx * dx + dz * dz));
			angleY = Math.atan2(dz, dx);
		}

		public function lookAtDirection():void 
		{
			
			var dx:Number = ((xPos + direction.x) - xPos);
			var dy:Number = ((yPos + direction.y) - yPos);
			var dz:Number = ((zPos + direction.z) - zPos);
			
			angleZ = -Math.atan2(-dy, Math.sqrt(dx * dx + dz * dz));
			angleY = Math.atan2(dz, dx);
		}

		public function moveToDirection(speed:Number):void 
		{
			xPos += direction.x * speed;
			yPos += direction.y * speed;
			zPos += direction.z * speed;
		}

		public function rotateAround(origin:Object3D, angleX:Number = 0, angleY:Number = 0):void 
		{

			// koords rotieren noch nicht mit?? komische bewegung wenn nase weit oben/unten

			var sx:Number = Math.sin(angleX);
			var cx:Number = Math.cos(angleX);
			var sy:Number = Math.sin(angleY);
			var cy:Number = Math.cos(angleY);

			xPos = origin.xPos + 300 * sy * cx;
			yPos = origin.yPos + 300 * -sx;
			zPos = origin.zPos + 300 * cy * cx;
		}

		public function getAngles():String 
		{
			return "Angles: X:" + Math.round(rad2deg(angleX)) + " Y:" + Math.round(rad2deg(angleY)) + " Z: " + Math.round(rad2deg(angleZ));
		}

		public static function rad2deg(rad:Number):Number 
		{
			return rad * (180 / Math.PI);
		}

		public static function deg2rad(deg:Number):Number 
		{
			return deg * (Math.PI / 180);
		}

		public function toString():String
		{
			return "[Object3D " + name + " x: " + xPos + ", y: " + yPos + ", z: " + zPos + ", angleX: " + angleX + ", angleY: " + angleY + ", angleZ: " + angleZ + "]";
		}
	}
}
