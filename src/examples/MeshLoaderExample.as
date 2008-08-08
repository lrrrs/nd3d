package examples {
	
	import de.nulldesign.nd3d.utils.ASEParser;
	import de.nulldesign.nd3d.material.Material;
	import de.nulldesign.nd3d.utils.MeshLoader;
	import de.nulldesign.nd3d.events.MeshLoadEvent;
	import de.nulldesign.nd3d.objects.PointCamera;
	import de.nulldesign.nd3d.geom.Face;
	import de.nulldesign.nd3d.objects.Mesh;
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
	import flash.ui.Keyboard;
	
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.display.Sprite;

	public class MeshLoaderExample extends Sprite {
		
		private var cam:PointCamera;
		private var renderer:Renderer;
		private var renderList:Array;
		private var meshLoader:MeshLoader;
		
		function MeshLoaderExample() {

			renderer = new Renderer(this);
			renderer.dynamicLighting = true;
			renderer.ambientColor = 0x000000;
			renderer.ambientColorCorrection = 0.6; // use this value if your mesh gehts to dark / bright
			
			cam = new PointCamera(600, 400);
			cam.zOffset = -100;
			
			renderList = [];
			
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			addEventListener(Event.ENTER_FRAME, onRenderScene);

			// minelayercorvette
			var mat:Material = new Material(0x7b7b7b, 1, null, false, true, false, true);
			var textures:Array = [];
			textures.push("textures/page3.jpg");
			textures.push("textures/page1.jpg");
			textures.push("textures/page4.jpg");
			textures.push("textures/page0.jpg");
			textures.push("textures/page2.jpg");

			meshLoader = new MeshLoader();
			meshLoader.addEventListener(MeshLoadEvent.TYPE, onMeshLoaded);
			meshLoader.loadMesh("models/fighter.ASE", textures, mat);
		}
		
		private function onMouseWheel(evt:MouseEvent):void {
			cam.zOffset -= evt.delta * 5;
		}
		
		private function onMeshLoaded(evt:MeshLoadEvent):void {
			evt.mesh.scale(3, 3, 3);
			renderList.push(evt.mesh);
		}
		
		private function onRenderScene(evt:Event):void {

			cam.angleX += (mouseY - cam.vpY) * .0005;
			cam.angleY += (mouseX - cam.vpX) * .0005;

			renderer.render(renderList, cam);
		}
	}
}
