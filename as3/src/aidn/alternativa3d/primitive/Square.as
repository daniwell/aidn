package aidn.alternativa3d.primitive
{
	import alternativa.engine3d.core.VertexAttributes;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.resources.Geometry;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	public class Square extends Mesh
	{
		public function Square ( vertices :Vector.<Vector3D>, uvs:Vector.<Point>, twoSide :Boolean = false, reverse :Boolean = false )
		{
			var geometry :Geometry = new Geometry();	
			var pos      :int      = VertexAttributes.POSITION;
			var tex      :int      = VertexAttributes.TEXCOORDS[0];
			geometry.addVertexStream([pos, pos, pos, tex, tex]);
			
			var indices   :Vector.<uint>   = new Vector.<uint>();
			var positions :Vector.<Number> = new Vector.<Number>();
			var texcoords :Vector.<Number> = new Vector.<Number>();
			
			if (twoSide || ! reverse) _createSquare(vertices, uvs, indices, positions, texcoords, false);
			if (twoSide ||   reverse) _createSquare(vertices, uvs, indices, positions, texcoords, true);
			
			geometry.numVertices = positions.length / 3;
			geometry.setAttributeValues(VertexAttributes.POSITION,     positions);
			geometry.setAttributeValues(VertexAttributes.TEXCOORDS[0], texcoords);
			geometry.indices = indices;
			
			this.geometry = geometry;
			this.addSurface(null, 0, indices.length / 3);			
		}
		
		private function _createSquare ( vertices :Vector.<Vector3D>, uvs:Vector.<Point>, indices :Vector.<uint>, 
										 positions :Vector.<Number>, texcoords:Vector.<Number>, reverse :Boolean ) :void
		{
			if (reverse == false)
			{
				positions.push(	vertices[0].x, vertices[0].y, vertices[0].z,
								vertices[3].x, vertices[3].y, vertices[3].z,
								vertices[1].x, vertices[1].y, vertices[1].z);
				positions.push(	vertices[1].x, vertices[1].y, vertices[1].z,
								vertices[3].x, vertices[3].y, vertices[3].z,
								vertices[2].x, vertices[2].y, vertices[2].z);	
			}
			else
			{
				positions.push(	vertices[0].x, vertices[0].y, vertices[0].z,
								vertices[1].x, vertices[1].y, vertices[1].z,
								vertices[3].x, vertices[3].y, vertices[3].z);
				positions.push(	vertices[1].x, vertices[1].y, vertices[1].z,
								vertices[2].x, vertices[2].y, vertices[2].z,
								vertices[3].x, vertices[3].y, vertices[3].z);	
			}
			
			if (reverse == false)
			{
				texcoords.push(uvs[0].x, uvs[0].y, uvs[3].x, uvs[3].y, uvs[1].x, uvs[1].y);
				texcoords.push(uvs[1].x, uvs[1].y, uvs[3].x, uvs[3].y, uvs[2].x, uvs[2].y);
			}
			else
			{
				texcoords.push(uvs[0].x, uvs[0].y, uvs[1].x, uvs[1].y, uvs[3].x, uvs[3].y);
				texcoords.push(uvs[1].x, uvs[1].y, uvs[2].x, uvs[2].y, uvs[3].x, uvs[3].y);
			}
			
			var start:uint = indices.length;
			indices.push(start + 0, start + 1, start + 2, start + 3, start + 4, start + 5);
		}
	}
}