package de.nulldesign.nd3d.view 
{
  import de.nulldesign.nd3d.material.LineMaterial;  
  import de.nulldesign.nd3d.objects.Line3D;  
  import de.nulldesign.nd3d.geom.Vertex;	
  import de.nulldesign.nd3d.objects.PointCamera;
	import de.nulldesign.nd3d.renderer.Renderer;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ...
	 */
	public class AbstractView extends Sprite
	{
		protected var cam:PointCamera;
		protected var renderer:Renderer;
		protected var renderList:Array;
		
		public function AbstractView(sceneWidth:int, sceneHeight:int) 
		{
			renderer = new Renderer(this);
			cam = new PointCamera(sceneWidth, sceneHeight);
			renderList = [];

			addEventListener(Event.ENTER_FRAME, loop);
		}
		
		protected function loop(e:Event):void 
		{
			renderer.render(renderList, cam);
		}
		
		protected function createDebugAxis():void
    {
      var p0:Vertex = new Vertex(0, 0, 0);
      var lineX:Line3D = new Line3D(p0, new Vertex(500, 0, 0), new LineMaterial(0xFF0000));
      var lineY:Line3D = new Line3D(p0, new Vertex(0, 500, 0), new LineMaterial(0x00FF00));
      var lineZ:Line3D = new Line3D(p0, new Vertex(0, 0, 500), new LineMaterial(0x0000FF));
      
      renderList.push(lineX, lineY, lineZ);
    }
	}
	
}