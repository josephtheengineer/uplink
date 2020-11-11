# Render tags

const DEFAULT_CHUNK = {
	meta = {
		system = "chunk",
		type = "chunk",
		id = str(Vector3(0, 0, 0)),
		seen = false,
		in_range = false,
		blocked = false
	},
	position = {
		world = Vector3(0, 0, 0),
		address = 0
	},
	mesh = {
		rendered = false,
		disabled = false,
		details = false,
		vertices = Array(),
		blocks = Dictionary(),
		blocks_loaded = 0
	},
	generator = {
		seed = 0
	}
}
