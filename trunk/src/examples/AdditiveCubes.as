package examples {
	
	import de.nulldesign.nd3d.material.Material;
	import de.nulldesign.nd3d.objects.SimpleCube;
	import de.nulldesign.nd3d.objects.PointCamera;
	import de.nulldesign.nd3d.geom.Face;
	import de.nulldesign.nd3d.objects.Mesh;
	import de.nulldesign.nd3d.renderer.Renderer;
	import de.nulldesign.nd3d.objects.Sprite3D;
	import de.nulldesign.nd3d.geom.UV;
	import de.nulldesign.nd3d.geom.Vertex;
	import flash.display.GradientType;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.ui.Keyboard;
	
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;

	public class AdditiveCubes extends Sprite {
		
		private var cam:PointCamera;
		private var renderer:Renderer;
		private var renderList:Array;

		[Embed("./assets/cube_texture.png")]
		private var MyTexture:Class;	
		
		public function AdditiveCubes() {

			var m:Matrix = new Matrix();
			m.rotate(Math.PI / 2);
			graphics.beginGradientFill(GradientType.LINEAR, [0x000000, 0xFFFFFF], [100, 100], [125, 255], m);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			graphics.endFill();
			
			renderer = new Renderer(Sprite(addChild(new Sprite())));
			renderer.additiveMode = true;
			
			cam = new PointCamera(600, 400);
			cam.zOffset = 2000;
			
			renderList = [];

			var texture1:BitmapData = new MyTexture().bitmapData;
			texture1.colorTransform(texture1.rect, new ColorTransform(0.3, 0.5, 0.6, 1, 0, 0, 0, 0));
			var texture2:BitmapData = new MyTexture().bitmapData;
			texture2.colorTransform(texture2.rect, new ColorTransform(1, 0.5, 1, 1, 0, 0, 0, 0));
			var texture3:BitmapData = new MyTexture().bitmapData;
			texture3.colorTransform(texture3.rect, new ColorTransform(1, 1, 0.5, 1, 0, 0, 0, 0));
			var texture4:BitmapData = new MyTexture().bitmapData;
			texture4.colorTransform(texture4.rect, new ColorTransform(0, 1, 1, 1, 0, 0, 0, 0));
			var texture5:BitmapData = new MyTexture().bitmapData;
			texture5.colorTransform(texture5.rect, new ColorTransform(1, 1, 0, 1, 0, 0, 0, 0));
			
			var c1:Mesh = new SimpleCube(new Material(0xFF9900, 1, texture1, true, false, true), 200);
			var c2:Mesh = new SimpleCube(new Material(0xFF9900, 1, texture2, true, false, true), 300);
			var c3:Mesh = new SimpleCube(new Material(0xFF9900, 1, texture3, true, false, true), 400);
			var c4:Mesh = new SimpleCube(new Material(0xFF9900, 1, texture4, true, false, true), 500);
			var c5:Mesh = new SimpleCube(new Material(0xFF9900, 1, texture5, true, false, true), 600);

			renderList.push(c1, c2, c3, c4, c5);
			
			addEventListener(Event.ENTER_FRAME, onRenderScene);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
		}

		private function onKeyPress(evt:KeyboardEvent):void {
			renderer.additiveMode = !renderer.additiveMode;
		}
		
		private function onRenderScene(evt:Event):void {

			Mesh(renderList[0]).angleX += (mouseY - cam.vpY) * .0005;
			Mesh(renderList[0]).angleY += (mouseX - cam.vpX) * .0005;
			
			for(var i:uint = 1; i < renderList.length; i++) {
				Mesh(renderList[i]).angleX += (Mesh(renderList[i-1]).angleX - Mesh(renderList[i]).angleX) * 0.2;
				Mesh(renderList[i]).angleY += (Mesh(renderList[i-1]).angleY - Mesh(renderList[i]).angleY) * 0.2;
			}
			
			renderer.render(renderList, cam);
		}
	}
}
