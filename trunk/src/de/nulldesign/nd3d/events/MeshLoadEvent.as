package de.nulldesign.nd3d.events 
{
	import flash.events.Event;

	import de.nulldesign.nd3d.objects.Mesh;	

	public class MeshLoadEvent extends Event 
	{

		public static const TYPE:String = "onMeshLoaded";
		public var mesh:Mesh;

		public function MeshLoadEvent(mesh:Mesh) 
		{
			
			super(TYPE);
			this.mesh = mesh;
		}
	}	
}
