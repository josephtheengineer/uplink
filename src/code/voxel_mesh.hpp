#include <Godot.hpp>
#include <Object.hpp>

namespace godot {

class VoxelMesh : public godot::Object {
	GODOT_CLASS(VoxelMesh, godot::Object)

public:
	static const bool SHOW_UNSEEN_SIDES = false;
	static constexpr float BSIZE = 1.0;         // Block size       (1)
	static constexpr float VSIZE = BSIZE / 16;  // Voxel size       (0.0625)
	static constexpr float MVSIZE = VSIZE / 16; // Micro voxel size (0.00390625)
	static constexpr float CSIZE = BSIZE * 16;  // Chunk size       (16)

	static const int SURROUNDING_BLOCKS_SIZE = 6;
	const Vector3 SURROUNDING_BLOCKS[SURROUNDING_BLOCKS_SIZE] = {
		Vector3(0, 0, 1), Vector3(0, 1, 0),
		Vector3(1, 0, 0), Vector3(0, 0, -1), 
		Vector3(0, -1, 0), Vector3(-1, 0, 0)
	};

	static const int BOX_HIGHLIGHT_SIZE = 24;
	const Vector3 BOX_HIGHLIGHT[BOX_HIGHLIGHT_SIZE] = {
		Vector3(0, 0, 0), Vector3(1, 0, 0), // ______
		Vector3(1, 0, 0), Vector3(1, 1, 0), //      |
		Vector3(0, 1, 0), Vector3(0, 0, 0), // |
		Vector3(0, 0, 1), Vector3(1, 0, 1), // ------
		Vector3(1, 0, 1), Vector3(1, 1, 1), //       |
		Vector3(0, 1, 1), Vector3(0, 0, 1), // |
		Vector3(0, 1, 0), Vector3(0, 1, 1), // ^/
		Vector3(0, 0, 0), Vector3(0, 0, 1), // /
		Vector3(1, 1, 0), Vector3(1, 1, 1), //      ^/
		Vector3(1, 0, 0), Vector3(1, 0, 1), //        /
		Vector3(0, 1, 0), Vector3(1, 1, 0), // ^______
		Vector3(0, 1, 1), Vector3(1, 1, 1)  // ^------
	};

	static const int VERT_SIZE = 6;
	const Vector2 VPLANE_UVS[VERT_SIZE] = {
		Vector2(0, 1), Vector2(1, 1),
		Vector2(0, 0), Vector2(1, 0), 
		Vector2(0, 0), Vector2(1, 1)
	};

	const Vector3 VPLANE_VERTICES[VERT_SIZE] = {
		Vector3(0, 0, 0), Vector3(1, 0, 0),
		Vector3(0, -1, 0), Vector3(1, -1, 0),
		Vector3(0, -1, 0), Vector3(1, 0, 0)
	};

	const Vector2 VPLANE_UVS2[VERT_SIZE] = {
		Vector2(0, 1), Vector2(1, 1),
		Vector2(0, 0), Vector2(1, 0),
		Vector2(0, 0), Vector2(1, 1)
	};

	const Vector3 VPLANE_VERTICES2[VERT_SIZE] = {
		Vector3(0, 0, 0), Vector3(0, 0, 1),
		Vector3(0, -1, 0), Vector3(0, -1, 1),
		Vector3(0, -1, 0), Vector3(0, 0, 1)
	};

	const Vector2 HPLANE_UVS[VERT_SIZE] = {
		Vector2(0, 0), Vector2(1, 0),
		Vector2(0, 1), Vector2(1, 1), 
		Vector2(0, 1), Vector2(1, 0)
	};

	const Vector3 HPLANE_VERTICES[VERT_SIZE] = {
		Vector3(0, 0, 0), Vector3(VSIZE, 0, 0),
		Vector3(0, 0, 1), Vector3(1, 0, 1),
		Vector3(0, 0, 1), Vector3(1, 0, 0)
	};

	static void _register_methods();

	VoxelMesh();
	~VoxelMesh();

	void _init(); // our initializer called by Godot

	void _process(float delta);
	
	godot::Dictionary can_be_seen (
		Vector3 position,
		Dictionary voxel_data,
		int *num
	) const;
	
	godot::Dictionary block_can_be_seen (
		Vector3 position,
		Dictionary block_data
	) const;
	
	godot::Array create_cube (
		Vector3 position,
		Array voxel_positions,
		Dictionary voxel_data,
		int resolution
	) const;
	
	void create_voxel(
		godot::Vector3 position,
		godot::Vector2 uv_offset,
		godot::Dictionary sides_to_render,
		int *index,
		godot::PoolVector3Array *normals,
		godot::PoolVector2Array *uvs,
		godot::PoolVector3Array *verts,
		Vector3 size	
	) const;

	godot::PoolVector3Array find_corner_pairs (
		godot::PoolVector3Array vertices        	
	) const;

	void construct_mesh_from_corners (
		godot::PoolVector3Array corner_verts,
		godot::PoolVector3Array *normals,
		godot::PoolVector2Array *uvs,
		godot::PoolVector3Array *verts
	) const;
};

}
