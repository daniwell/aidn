package aidn.alternativa3d.primitive
{
	import alternativa.engine3d.core.VertexAttributes;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.resources.Geometry;
	import flash.geom.Vector3D;
	
	public class SimpleSquare extends Mesh
	{
		/// 単色(FillMaterial)のみ
		public function SimpleSquare ( vertices :Vector.<Vector3D>, twoSide :Boolean = false, reverse :Boolean = false )
		{
			var geometry :Geometry = new Geometry();	
			var pos      :int      = VertexAttributes.POSITION;
			geometry.addVertexStream([pos, pos, pos]);
			
			var indices   :Vector.<uint>   = new Vector.<uint>();
			var positions :Vector.<Number> = new Vector.<Number>();
			
			if (twoSide || ! reverse) _createSquare(vertices, indices, positions, false);
			if (twoSide ||   reverse) _createSquare(vertices, indices, positions, true);
			
			geometry.numVertices = positions.length / 3;
			geometry.setAttributeValues(VertexAttributes.POSITION, positions);
			geometry.indices = indices;
			
			this.geometry = geometry;
			this.addSurface(null, 0, indices.length / 3);			
		}
		
		private function _createSquare ( vertices :Vector.<Vector3D>, indices :Vector.<uint>, positions :Vector.<Number>, reverse :Boolean ) :void
		{
			if (reverse == false)
			{
				positions.push(	vertices[0].x, vertices[0].y, vertices[0].z,
								vertices[3].x, vertices[3].y, vertices[3].z,
								vertices[1].x, vertices[1].y, vertices[1].z);
				positions.push(	vertices[1].x, vertices[1].y, vertices[1].z,
								vertices[3].x, vertices[3].y, vertices[3].z,
								vertices[2].x, vertices[2].y, vertices[2].z);	
			} else {
				positions.push(	vertices[0].x, vertices[0].y, vertices[0].z,
								vertices[1].x, vertices[1].y, vertices[1].z,
								vertices[3].x, vertices[3].y, vertices[3].z);
				positions.push(	vertices[1].x, vertices[1].y, vertices[1].z,
								vertices[2].x, vertices[2].y, vertices[2].z,
								vertices[3].x, vertices[3].y, vertices[3].z);	
			}
			
			var start:uint = indices.length
			indices.push(start + 0, start + 1, start + 2,start + 3, start + 4, start + 5);
		}
	}
}