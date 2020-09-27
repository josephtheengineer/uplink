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
		godot::Dictionary voxel_data
) const {
	godot::Dictionary dict;
	for (int i = 0; i < SURROUNDING_BLOCKS_SIZE; i++) {
		if(voxel_data.has(position+SURROUNDING_BLOCKS[i])) {
			dict[SURROUNDING_BLOCKS[i]] = false;
		} else {
			dict[SURROUNDING_BLOCKS[i]] = true;
		}
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
		Dictionary voxel_data
) const {
	godot::Array mesh_arrays;
	mesh_arrays.resize(Mesh::ARRAY_MAX);
	
	int num_sides = 6;
	int num_voxels = voxel_positions.size();
	int num_verts = VERT_SIZE*num_sides*num_voxels;

	godot::PoolVector3Array normals;
	godot::PoolVector2Array uvs;
	godot::PoolVector3Array verts;

	normals.resize(num_verts);
	uvs.resize(num_verts);
	verts.resize(num_verts);
	
	for (int i = 0; i < num_voxels; i++) {
		Vector3 voxel_position = position + ((Vector3)voxel_positions[i]/Vector3(16, 16, 16)) + Vector3(0, VSIZE, 0);
		Vector2 uv_offset = Vector2(-0.5, -0.5);
		//if (floor(rand_range(0, 3)) == 1)
		//	uv_offset = Vector2(0, 0)
		create_voxel(voxel_position, uv_offset, can_be_seen(voxel_positions[i], voxel_data), &normals, &uvs, &verts);
	}
	
	mesh_arrays[Mesh::ARRAY_NORMAL] = normals;
	mesh_arrays[Mesh::ARRAY_TEX_UV] = uvs;
	mesh_arrays[Mesh::ARRAY_VERTEX] = verts;

	return mesh_arrays;
}

void VoxelMesh::create_voxel(
		godot::Vector3 position,
		godot::Vector2 uv_offset,
		godot::Dictionary sides_to_render,
		godot::PoolVector3Array *normals,
		godot::PoolVector2Array *uvs,
		godot::PoolVector3Array *verts
) const {
	if(sides_to_render[Vector3(0, 1, 0)]) { // up
		for(int i = 0; i < VERT_SIZE; i++) {
			normals->append(Vector3(0, 1, 0));
			uvs->append(HPLANE_UVS[i] + uv_offset);
			verts->append(HPLANE_VERTICES[i] + position + Vector3(0, 0, 0));
		}
	}

	if(sides_to_render[Vector3(0, -1, 0)]) { // down
		for(int i = VERT_SIZE-1; i >= 0; i--) {
			normals->append(Vector3(0, -1, 0));
			uvs->append(HPLANE_UVS[i] + uv_offset);
			verts->append(HPLANE_VERTICES[i] + position + Vector3(0, -VSIZE, 0));
		}	
	}


	if(sides_to_render[Vector3(0, 0, 1)]) { // west
		for(int i = 0; i < VERT_SIZE; i++) {
			normals->append(Vector3(0, 0, 1));
			uvs->append(VPLANE_UVS[i] + uv_offset);
			verts->append(VPLANE_VERTICES[i] + position + Vector3(0, 0, VSIZE));
		}
	}

	if(sides_to_render[Vector3(0, 0, -1)]) { // east
		for(int i = VERT_SIZE-1; i >= 0; i--) {
			normals->append(Vector3(0, 0, -1));
			uvs->append(VPLANE_UVS[i] + uv_offset);
			verts->append(VPLANE_VERTICES[i] + position + Vector3(0, 0, 0));
		}
	}

	if(sides_to_render[Vector3(-1, 0, 0)]) { // north
		for(int i = 0; i < VERT_SIZE; i++) {
			normals->append(Vector3(-1, 0, 0));
			uvs->append(VPLANE_UVS2[i] + uv_offset);
			verts->append(VPLANE_VERTICES2[i] + position + Vector3(0, 0, 0));
		}
	}

	if(sides_to_render[Vector3(1, 0, 0)]) { // south
		for(int i = VERT_SIZE-1; i >= 0; i--) {
			normals->append(Vector3(1, 0, 0));
			uvs->append(VPLANE_UVS2[i] + uv_offset);
			verts->append(VPLANE_VERTICES2[i] + position + Vector3(VSIZE, 0, 0));
		}
	}
}
