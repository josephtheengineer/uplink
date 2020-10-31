#include "voxel_mesh.hpp"
#include <Mesh.hpp>

using namespace godot;

void VoxelMesh::_register_methods() {
	godot::register_method("create_cube", &VoxelMesh::create_cube);
}

VoxelMesh::VoxelMesh() {
}

VoxelMesh::~VoxelMesh() {
	//free();
}

void VoxelMesh::_init() {
	// initialize any variables here
	//time_passed = 0.0;
	//amplitude = 10.0;
	//speed = 1.0;
}

void VoxelMesh::_process(float delta) {
/*	time_passed += speed * delta;

	Vector2 new_position = Vector2(
		amplitude + (amplitude * sin(time_passed * 2.0)),
		amplitude + (amplitude * cos(time_passed * 1.5))
	);

	set_position(new_position);

	time_emit += delta;
	if (time_emit > 1.0) {
		emit_signal("position_changed", this, new_position);

		time_emit = 0.0;
	}*/
}

//void VoxelMesh::set_speed(float p_speed) {
//	speed = p_speed;
//}

//float VoxelMesh::get_speed() {
//	return speed;
//}

godot::Dictionary VoxelMesh::can_be_seen(
		godot::Vector3 position,
		godot::Dictionary voxel_data,
		int *num
) const {
	godot::Dictionary dict;
	for (int i = 0; i < SURROUNDING_BLOCKS_SIZE; i++) {
		//if(voxel_data.has(position+SURROUNDING_BLOCKS[i])) {
		//	dict[SURROUNDING_BLOCKS[i]] = false;
		//} else {
		dict[SURROUNDING_BLOCKS[i]] = true;
		(*num)++;
 		//}
	}
	return dict;
}

godot::Dictionary VoxelMesh::block_can_be_seen(
		godot::Vector3 position,
		godot::Dictionary block_data
) const {
	godot::Dictionary dict;
	for (int i = 0; i < SURROUNDING_BLOCKS_SIZE; i++) {
		dict[SURROUNDING_BLOCKS[i]] = true;
	}
	return dict;
}

godot::Array VoxelMesh::create_cube(
		Vector3 position,
		Array voxel_positions,
		Dictionary voxel_data,
		int resolution
) const {
	godot::Dictionary sides_to_render;
	godot::Array mesh_arrays;
	mesh_arrays.resize(Mesh::ARRAY_MAX);

	int num_voxels = voxel_positions.size();
	int num_sides = 0;
	for (int i = 0; i < num_voxels; i++) {
		Vector3 voxel_position = position + ((Vector3)voxel_positions[i]/Vector3(16, 16, 16)) + Vector3(0, resolution, 0);
		sides_to_render[voxel_position] = can_be_seen(voxel_positions[i], voxel_data, &num_sides);
	}

	int num_verts = num_sides * VERT_SIZE;

	godot::PoolVector3Array normals;
	godot::PoolVector2Array uvs;
	godot::PoolVector3Array verts;

	normals.resize(num_verts);
	uvs.resize(num_verts);
	verts.resize(num_verts);
	
	int side_progress = 0;
	for (int i = 0; i < num_voxels; i++) {
		Vector3 voxel_position = position + ((Vector3)voxel_positions[i]/Vector3(16, 16, 16)) + Vector3(0, resolution, 0);
		Vector2 uv_offset = Vector2(-0.5, -0.5);
		//if (floor(rand_range(0, 3)) == 1)
		//	uv_offset = Vector2(0, 0)
		create_voxel (
			voxel_position,
			uv_offset,
			sides_to_render,
			&side_progress,
			&normals, &uvs, &verts, 
			Vector3(resolution, resolution, resolution)
		);
	}

	//godot::PoolVector3Array corner_verts = find_corner_pairs(verts);

	//construct_mesh_from_corners(corner_verts, &normals, &uvs, &verts);

	mesh_arrays[Mesh::ARRAY_NORMAL] = normals;
	mesh_arrays[Mesh::ARRAY_TEX_UV] = uvs;
	mesh_arrays[Mesh::ARRAY_VERTEX] = verts;

	return mesh_arrays;
}

void VoxelMesh::create_voxel(
		godot::Vector3 position,
		godot::Vector2 uv_offset,
		godot::Dictionary sides_to_render,
		int *v,
		godot::PoolVector3Array *normals,
		godot::PoolVector2Array *uvs,
		godot::PoolVector3Array *verts,
		godot::Vector3 size
) const {
	Vector2 size2 = Vector2(size.x, size.y);
	if(((godot::Dictionary)sides_to_render[position])[Vector3(0, 1, 0)]) { // up
		for(int i = 0; i < VERT_SIZE; i++) {
			normals->set(*v, Vector3(0, 1, 0));
			uvs->set(*v,     HPLANE_UVS[i]*size2+ uv_offset);
			verts->set(*v,   HPLANE_VERTICES[i]*size + position);
			(*v)++;
		}
	}

	if(((godot::Dictionary)sides_to_render[position])[Vector3(0, -1, 0)]) { // down
		for(int i = VERT_SIZE-1; i >= 0; i--) {
			normals->set(*v, Vector3(0, -1, 0));
			uvs->set(*v,     HPLANE_UVS[i]*size2 + uv_offset);
			verts->set(*v,   HPLANE_VERTICES[i]*size + position + Vector3(0, -size.x, 0));
			(*v)++;
		}	
	}


	if(((godot::Dictionary)sides_to_render[position])[Vector3(0, 0, 1)]) { // west
		for(int i = 0; i < VERT_SIZE; i++) {
			normals->set(*v, Vector3(0, 0, 1));
			uvs->set(*v,     VPLANE_UVS[i]*size2 + uv_offset);
			verts->set(*v,   VPLANE_VERTICES[i]*size + position + Vector3(0, 0, size.x));
			(*v)++;
		}
	}

	if(((godot::Dictionary)sides_to_render[position])[Vector3(0, 0, -1)]) { // east
		for(int i = VERT_SIZE-1; i >= 0; i--) {
			normals->set(*v, Vector3(0, 0, -1));
			uvs->set(*v,     VPLANE_UVS[i]*size2 + uv_offset);
			verts->set(*v,   VPLANE_VERTICES[i]*size + position);
			(*v)++;
		}
	}

	if(((godot::Dictionary)sides_to_render[position])[Vector3(-1, 0, 0)]) { // north
		for(int i = 0; i < VERT_SIZE; i++) {
			normals->set(*v, Vector3(-1, 0, 0));
			uvs->set(*v,     VPLANE_UVS2[i]*size2 + uv_offset);
			verts->set(*v,   VPLANE_VERTICES2[i]*size + position);
			(*v)++;
		}
	}

	if(((godot::Dictionary)sides_to_render[position])[Vector3(1, 0, 0)]) { // south
		for(int i = VERT_SIZE-1; i >= 0; i--) {
			normals->set(*v, Vector3(1, 0, 0));
			uvs->set(*v,     VPLANE_UVS2[i]*size2 + uv_offset);
			verts->set(*v,   VPLANE_VERTICES2[i]*size + position + Vector3(size.x, 0, 0));
			(*v)++;
		}
	}
}

godot::PoolVector3Array VoxelMesh::find_corner_pairs (
		godot::PoolVector3Array vertices
) const {
	printf("Finding corner pairs...");
	godot::Array verts = Array(vertices);
	godot::PoolVector3Array edges;
	godot::Array points;

	if (!vertices.size() % 3) {
		return edges;
	}
	
	for (int i = 0; i < vertices.size(); i+=3) {
		PoolVector3Array tri;
		tri.append(vertices[i]);
		tri.append(vertices[i+1]);
		tri.append(vertices[i+2]);

		int touching = verts.count(tri[0]) + verts.count(tri[1]) + verts.count(tri[2]);

		if (touching == 17) {
			printf (
				"Triangle: %f,%f,%f + %f,%f,%f + %f,%f,%f\n",
				tri[0].x, tri[0].y, tri[0].z,
				tri[1].x, tri[1].y, tri[1].z,
				tri[2].x, tri[2].y, tri[2].z
			);
			edges.append(tri[0]);
			edges.append(tri[1]);
			edges.append(tri[2]);
		}
	}
/*
	// Get points from edge verts
	for (int i = 0; i < edges.size(); i+=15) {
		int min = Vector3(99999999999999999, 999999999999999, 999999999;		
		int max = -9999999999999999;
		for (int a = 0; a < 15; a++) {
			if (edges[i+a] > max) {
				edges
			}
		}
	}
*/
	return edges;
}

void VoxelMesh::construct_mesh_from_corners (
	godot::PoolVector3Array corner_verts,
	godot::PoolVector3Array *normals,
	godot::PoolVector2Array *uvs,
	godot::PoolVector3Array *verts
) const {
	godot::PoolVector3Array o_normals = *normals;
	godot::PoolVector2Array o_uvs = *uvs;
	//godot::PoolVector3Array o_verts = *verts;

	int size = corner_verts.size();
	printf("Corner size: %d\n", size);
	normals->resize(size);
	uvs->resize(size);
	verts->resize(size);
	
	*verts = corner_verts;

/*
	for (int i = 0; i < corner_verts.size()/15; i+=6) {
		verts->set(i,   verts[i] + verts[i+6]);
		verts->set(i+1, corner_verts[i+1] + verts[i+6]);
		verts->set(i+2, corner_verts[i+2] + verts[i+6]);

		verts->set(i+3, corner_verts[i+3] + verts[i+6]);
		verts->set(i+4, corner_verts[i+4] + verts[1+6]);
		verts->set(i+5, corner_verts[i+5] + verts[i+6]);
	}*/
}
