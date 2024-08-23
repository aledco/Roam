class_name WorldTileType
enum {
	Grass,
	Dirt,
	Sand,
	Gravel,
	Water
}

static func size() -> int:
	return 5

static func get_atlas_coords(tile_type: Variant) -> Vector2i:
	match tile_type:
		WorldTileType.Grass:
			return Vector2i(0, 0)
		WorldTileType.Dirt:
			return Vector2i(0, 1)
		WorldTileType.Sand:
			return Vector2i(0, 2)
		WorldTileType.Gravel:
			return Vector2i(0, 3)
		WorldTileType.Water:
			return Vector2i(0, 4)
		_:
			return Vector2i(0, 0)
