class_name WorldTileMap extends Node2D

const GROUND_TILE_SET_ID = 0

@onready var ground: TileMapLayer = $Ground

func set_cell(coords: Vector2i, tile_type: Variant):
	var atlas_coords := WorldTileType.get_atlas_coords(tile_type)
	ground.set_cell(coords, 	GROUND_TILE_SET_ID, atlas_coords)

func map_to_local(map_position: Vector2i) -> Vector2:
	return ground.map_to_local(map_position)
