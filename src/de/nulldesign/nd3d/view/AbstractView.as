package de.nulldesign.nd3d.view 
{
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
		
	}
	
}