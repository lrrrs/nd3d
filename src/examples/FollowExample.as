package examples {
	
	import de.nulldesign.nd3d.objects.Cube;
	import de.nulldesign.nd3d.utils.ASEParser;
	import de.nulldesign.nd3d.material.Material;
	import de.nulldesign.nd3d.utils.MeshLoader;
	import de.nulldesign.nd3d.events.MeshLoadEvent;
	import de.nulldesign.nd3d.objects.Object3D;
	import de.nulldesign.nd3d.objects.PointCamera;
	import de.nulldesign.nd3d.geom.Face;
	import de.nulldesign.nd3d.objects.Mesh;
	import de.nulldesign.nd3d.geom.Quaternion;
	import de.nulldesign.nd3d.renderer.Renderer;
	import de.nulldesign.nd3d.objects.Sprite3D;
	import de.nulldesign.nd3d.geom.Vertex;
	import flash.display.Bitmap;
	import flash.events.KeyboardEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.ui.Keyboard;
	
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.display.Sprite;

	public class FollowExample extends Sprite {
		
		private var cam:PointCamera;
		private var renderer:Renderer;
		private var renderList:Array;
		
		private var meshLoader:MeshLoader;
		private var meshLoader2:MeshLoader;
		private var meshLoader3:MeshLoader;
		
		private var texture:BitmapData;
		private var spaceShip:Mesh;
		private var spaceShip2:Mesh;
		private var spaceShip3:Mesh;
		
		private var lookAtSprite:Sprite3D;
		private var lookAtX:Number = 0;
		private var lookAtY:Number = 0;
		
		private var skyBox:Mesh;
		
		private var followRef:Mesh;
		
		private var myTimer:Number = 0;
		
		[Embed("./assets/space1.jpg")]
		private var Space1:Class;	
		[Embed("./assets/space2.jpg")]
		private var Space2:Class;	
		[Embed("./assets/space3.jpg")]
		private var Space3:Class;	
		[Embed("./assets/space4.jpg")]
		private var Space4:Class;	
		
		function FollowExample() {

			renderer = new Renderer(this);
			
			cam = new PointCamera(600, 400);
			cam.x = -2000;
			cam.y = -2000;
			cam.zOffset = -100;
			
			renderList = [];
			
			var space1:BitmapData = new Space1().bitmapData;
			var space2:BitmapData = new Space2().bitmapData;
			var space3:BitmapData = new Space3().bitmapData;
			var space4:BitmapData = new Space4().bitmapData;
			
			var spaceMat1:Material = new Material(0, 1, space1);
			var spaceMat2:Material = new Material(0, 1, space2);
			var spaceMat3:Material = new Material(0, 1, space3);
			var spaceMat4:Material = new Material(0, 1, space4);
			
			skyBox = new Cube([spaceMat1, spaceMat2, spaceMat3, spaceMat4, spaceMat3, spaceMat2], 3000, 4);
			skyBox.flipNormals();
			renderList.push(skyBox);

			// fighter test
			var mat:Material = new Material(0xFF9900, 1);
			var textures:Array = [];
			textures.push("./textures/page3.jpg");
			textures.push("./textures/page1.jpg");
			textures.push("./textures/page4.jpg");
			textures.push("./textures/page0.jpg");
			textures.push("./textures/page2.jpg");

			meshLoader = new MeshLoader();
			meshLoader.addEventListener(MeshLoadEvent.TYPE, onMeshLoaded);
			meshLoader.loadMesh("./models/fighter.ASE", textures, mat);
			
			// minelayercorvette
			var mat2:Material = new Material(0xFF9900, 1);
			var textures2:Array = [];

			textures2.push("./textures/minelayer_page0.jpg");
			textures2.push("./textures/minelayer_top.jpg");
			textures2.push("./textures/minelayer_page0.jpg");

			meshLoader2 = new MeshLoader();
			meshLoader2.addEventListener(MeshLoadEvent.TYPE, onMeshLoaded2);
			meshLoader2.loadMesh("./models/minelayercorvette.ASE", textures2, mat2);
			
			// swarmer test
			var mat3:Material = new Material(0xFF9900, 1);
			var textures3:Array = [];

			textures3.push("./textures/swarmer_page0.jpg");
			textures3.push("./textures/swarmer_page0.jpg");
			textures3.push("./textures/swarmer_fronthatch.jpg");
			textures3.push("./textures/swarmer_underhatch.jpg");
			textures3.push("./textures/swarmer_toprear.jpg");
			textures3.push("./textures/swarmer_page0.jpg");
			textures3.push("./textures/swarmer_top.jpg");
			textures3.push("./textures/swarmer_tailsidesrear.jpg");
			textures3.push("./textures/swarmer_bottemtail.jpg");

			meshLoader3 = new MeshLoader();
			meshLoader3.addEventListener(MeshLoadEvent.TYPE, onMeshLoaded3);
			meshLoader3.loadMesh("./models/p2advanceswarmer.ASE", textures3, mat3);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			stage.addEventListener(MouseEvent.CLICK, onMouseClick);
			
			addEventListener(Event.ENTER_FRAME, onRenderScene);
		}
		
		private function onMeshLoaded3(evt:MeshLoadEvent):void {
			renderList.push(evt.mesh);
			
			spaceShip = evt.mesh;
			spaceShip.direction = new Vertex(Math.random() - Math.random(), Math.random() - Math.random(), Math.random() - Math.random());
			spaceShip.xPos = (Math.random() - Math.random()) * 200;
			spaceShip.yPos = (Math.random() - Math.random()) * 200;
			spaceShip.zPos = (Math.random() - Math.random()) * 200;

			followRef = spaceShip;
		}
		
		private function onMeshLoaded2(evt:MeshLoadEvent):void {
			renderList.push(evt.mesh);
			
			spaceShip2 = evt.mesh;
			spaceShip2.direction = new Vertex(Math.random() - Math.random(), Math.random() - Math.random(), Math.random() - Math.random());
			spaceShip2.xPos = (Math.random() - Math.random()) * 200;
			spaceShip2.yPos = (Math.random() - Math.random()) * 200;
			spaceShip2.zPos = (Math.random() - Math.random()) * 200;
		}
		
		private function onMeshLoaded(evt:MeshLoadEvent):void {
			renderList.push(evt.mesh);
			
			spaceShip3 = evt.mesh;
			spaceShip3.direction = new Vertex(0, 1, 0);
			spaceShip3.xPos = (Math.random() - Math.random()) * 200;
			spaceShip3.yPos = (Math.random() - Math.random()) * 200;
			spaceShip3.zPos = (Math.random() - Math.random()) * 200;
		}

		private function onMouseWheel(evt:MouseEvent):void {
			cam.zOffset -= evt.delta * 10;
		}
		
		private function onMouseClick(evt:MouseEvent):void {
			followRef = followRef == spaceShip ? spaceShip2 : spaceShip;
		}
		
		private function onKeyPress(evt:KeyboardEvent):void {
			if(evt.keyCode == Keyboard.LEFT) {
				lookAtY -= 0.05;
			}
			if(evt.keyCode == Keyboard.RIGHT) {
				lookAtY += 0.05;
			}
			if(evt.keyCode == Keyboard.UP) {
				lookAtX -= 0.05;
			}
			if(evt.keyCode == Keyboard.DOWN) {
				lookAtX += 0.05;
			}
		}
		
		private function onRenderScene(evt:Event):void {

			myTimer += 0.01
			
			// no free movement, just 2 axes
			lookAtX -= (mouseY - cam.vpY) * .0005;
			lookAtY += (mouseX - cam.vpX) * .0005;
/**/
			if(lookAtX >= Object3D.deg2rad(90)) {
				lookAtX = Object3D.deg2rad(89);
			}
			if(lookAtX <= -Object3D.deg2rad(90)) {
				lookAtX = -Object3D.deg2rad(89);
			}

/*
			cam.angleX += (mouseY - cam.vpY) * .0005;
			cam.angleY += (mouseX - cam.vpX) * .0005;
			
			// TEST LOOKAT
			lookAtSprite.rotateAround(spaceShip, lookAtX, lookAtY);
			spaceShip.lookAtTarget(lookAtSprite);
*/			
			// TEST MOEVEMTN
/**/

			try {
				
				spaceShip.direction.x += (spaceShip3.xPos - spaceShip.xPos) * 0.00005;
				spaceShip.direction.y += (spaceShip3.yPos - spaceShip.yPos) * 0.00005;
				spaceShip.direction.z += (spaceShip3.zPos - spaceShip.zPos) * 0.00005;
				spaceShip.direction.normalize();

				spaceShip2.direction.x += (spaceShip3.xPos - spaceShip2.xPos) * 0.00005;
				spaceShip2.direction.y += (spaceShip3.yPos - spaceShip2.yPos) * 0.00005;
				spaceShip2.direction.z += (spaceShip3.zPos - spaceShip2.zPos) * 0.00005;
				spaceShip2.direction.normalize();

				spaceShip.lookAtDirection();
				spaceShip2.lookAtDirection();

				spaceShip.moveToDirection(5);
				spaceShip2.moveToDirection(5);

				//spaceship 3 movement
				spaceShip3.direction.rotateAround(lookAtX, lookAtY);
				spaceShip3.lookAtDirection();
				spaceShip3.moveToDirection(3);
				
				cam.follow(spaceShip3, 1, 0.1);
				
				skyBox.xPos = cam.x;
				skyBox.yPos = cam.y;
				skyBox.zPos = cam.z;
				
				renderer.render(renderList, cam);

			} catch(e:Error) {
				// blah...
			}
		}
	}
}
