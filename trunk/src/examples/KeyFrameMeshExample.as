package examples
{
	import de.nulldesign.nd3d.events.MeshLoadEvent;
	import de.nulldesign.nd3d.material.Material;
	import de.nulldesign.nd3d.objects.Mesh;
	import de.nulldesign.nd3d.objects.Object3D;
	import de.nulldesign.nd3d.objects.PointCamera;
	import de.nulldesign.nd3d.objects.SimpleCube;
	import de.nulldesign.nd3d.renderer.Renderer;
	import de.nulldesign.nd3d.utils.MeshLoader;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;

	[SWF(backgroundColor="#FFFFFF")]
	public class KeyFrameMeshExample extends Sprite 
	{
		private var cam:PointCamera;
		private var renderer:Renderer;
		private var renderList:Array;
		private var meshLoader:MeshLoader;

		function KeyFrameMeshExample() 
		{

			renderer = new Renderer(this);
			renderer.dynamicLighting = true;
			renderer.ambientColor = 0x000000;
			renderer.ambientColorCorrection = 0.6; 

			cam = new PointCamera(600, 400);
			cam.zOffset = 500;
			
			renderList = [];
			
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			addEventListener(Event.ENTER_FRAME, onRenderScene);

			var mat:Material = new Material(0x7b7b7b, 1, null, false, true, false, true);

			meshLoader = new MeshLoader();
			meshLoader.addEventListener(MeshLoadEvent.TYPE, onMeshLoaded);
			meshLoader.loadMesh("models/pg.md2", ["textures/pg.png"], mat);
		}

		private function onMouseWheel(evt:MouseEvent):void 
		{
			cam.zOffset -= evt.delta * 5;
		}

		private function onMeshLoaded(evt:MeshLoadEvent):void 
		{
			evt.mesh.scale(20,20, 20);
			renderList.push(evt.mesh);
		}

		private function onRenderScene(evt:Event):void 
		{
			//cam.angleX += (mouseY - cam.vpY) * .0005;
			//cam.angleY += (mouseX - cam.vpX) * .0005;
			cam.angleX = Object3D.deg2rad(80);
			cam.angleZ = Object3D.deg2rad(45);
			
			renderer.render(renderList, cam);
		}
	}
}
