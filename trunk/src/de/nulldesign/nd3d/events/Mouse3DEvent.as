package de.nulldesign.nd3d.events 
{
	import de.nulldesign.nd3d.geom.Face;
	import de.nulldesign.nd3d.objects.Mesh;
	import de.nulldesign.nd3d.objects.Object3D;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Mouse3DEvent extends Event
	{
		static public const MOUSE_OVER:String = "onMouse3DOver";
		static public const MOUSE_OUT:String = "onMouse3DOut";
		static public const MOUSE_CLICK:String = "onMouse3DClick";
		
		public var mesh:Object3D;
		public var face:Face;
		
		public function Mouse3DEvent(type:String, mesh:Object3D, face:Face) 
		{
			super(type);
			this.mesh = mesh;
			this.face = face;
		}
	}
	
}