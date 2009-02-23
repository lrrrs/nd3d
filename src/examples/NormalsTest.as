package examples 
{
	import de.nulldesign.nd3d.geom.Face;
	import de.nulldesign.nd3d.geom.Vertex;
	import de.nulldesign.nd3d.material.LineMaterial;
	import de.nulldesign.nd3d.material.Material;
	import de.nulldesign.nd3d.material.WireMaterial;
	import de.nulldesign.nd3d.objects.Line3D;
	import de.nulldesign.nd3d.objects.SimpleCube;
	import de.nulldesign.nd3d.view.AbstractView;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Lars Gerckens (lars@nulldesign.de)
	 */
	public class NormalsTest extends AbstractView
	{
		public function NormalsTest() 
		{
			super(600, 400);
			
			renderer.dynamicLighting = true;
			
			var cube:SimpleCube = new SimpleCube(new WireMaterial(0xFFFFFF, 1, false, 0xFF9900, 1), 100);
			renderList.push(cube);
			
			// calc normal of faces
			var f:Face;
			var a:Vertex;
			var b:Vertex;
			var c:Vertex;
			var ab:Vertex;
			var ac:Vertex;
			var n:Vertex;
			var m:Vertex;
			
			for(var i:uint = 0; i < cube.faceList.length; i++)
			{
				f = cube.faceList[i];
				a = f.v1;
				b = f.v2;
				c = f.v3;
				
				m = new Vertex((a.x + b.x + c.x) / 3, (a.y + b.y + c.y) / 3, (a.z + b.z + c.z) / 3);
				
				ab = new Vertex(b.x - a.x, b.y - a.y, b.z - a.z);
				ac = new Vertex(c.x - a.x, c.y - a.y, c.z - a.z);
				
				n = ac.cross(ab);
				n.normalize();
				
				n.length = 30;
				
				n.x += m.x;
				n.y += m.y;
				n.z += m.z;
				
				var l:Line3D = new Line3D(m, n, new LineMaterial(0xFF0000, 1, 4));
				renderList.push(l);
			}
		}
		
		override protected function loop(e:Event):void
		{
			super.loop(e);
			
			cam.angleX += (mouseY - cam.vpY) * .001;
			cam.angleY += (mouseX - cam.vpX) * .001;
		}
		
	}
	
}