class_name World extends Node2D

const GROUND_LAYER = 0
const TILESET_ID = 0
const GRASS_ID = Vector2i(0, 0)
const DIRT_ID = Vector2i(1, 0)
const SAND_ID = Vector2i(2, 0)
const GRAVEL_ID = Vector2i(3, 0)
const WATER_ID = Vector2i(4, 0)
const TILE_ID_MAP = {
	0: DIRT_ID,
	1: GRASS_ID,
	2: GRAVEL_ID,
	3: SAND_ID,
	4: WATER_ID
}
const N_GENERATED_TILES = 5

var STRUCTURE_PROB_MAP = [
	{
		"data": {
			"resource": load("res://structures/tree/tree.tscn"),
			"grid_size": Vector2i(1, 2)
		},
		"probs": {
			0: 0.05,
			1: 0.05,
			2: 0.01,
			3: 0.01
		}
	},
	{
		"data": {
			"resource": load("res://structures/boulder/boulder.tscn"),
			"grid_size": Vector2i(2, 2)
		},
		"probs": {
			0: 0.005,
			1: 0.005,
			2: 0.03,
			3: 0.01
		}
	}
]

@export var world_seed: int = 1
@export var world_size: int = 100

@onready var tile_map: TileMap = $TileMap
@onready var structure_manager = $StructureManager
@onready var size = int(world_size / 2)

var tile_map_ids = {}

func _ready():
	_generate_tile_map()
	_generate_structures()


func _generate_tile_map(): # TODO generate lakes
	var noise := _create_noise()
	_generate_world_core(noise)
	_generate_land_outline()
	_fill_ocean()
	_generate_borders()

func _create_noise() -> FastNoiseLite:
	var noise := FastNoiseLite.new()
	noise.seed = world_seed
	noise.noise_type = FastNoiseLite.TYPE_CELLULAR
	noise.fractal_type = FastNoiseLite.FRACTAL_PING_PONG     
	noise.frequency = 0.02
	return noise

func _set_cell(x: int, y: int, tile_id: int, add_to_map: bool = true):
	tile_map.set_cell(GROUND_LAYER, Vector2i(x, y), TILESET_ID, TILE_ID_MAP[tile_id])
	if add_to_map:
		tile_map_ids[Vector2i(x, y)] = tile_id

func _get_tile_id(noise: FastNoiseLite, x: int, y: int) -> int:
	var rand = abs(noise.get_noise_2d(x, y)) * N_GENERATED_TILES
	var tile_id = int(rand)
	if tile_id > (N_GENERATED_TILES-1):
		tile_id = (N_GENERATED_TILES-1)
	return tile_id

func _generate_world_core(noise):
	for x in range(-size, size):
		for y in range(-size, size):
			var tile_id = _get_tile_id(noise, x, y)
			_set_cell(x, y, tile_id)

func _generate_land_outline():
	var water_dropoff = size * 0.8
	var sand_dropoff = size * 0.9
	for x in range(-size, size):
		for y in range(-size, size):
			var point = Vector2(x, y)
			if point.length() > (water_dropoff + (randi() % 2)):
				_set_cell(x, y, 3)
	
	for x in range(-size, size):
		for y in range(-size, size):
			var point = Vector2(x, y)
			if point.length() > (sand_dropoff + (randi() % 4)):
				_set_cell(x, y, 4)

func _fill_ocean():
	const OCEAN_MULTIPLIER = 2
	for x in range(-size * OCEAN_MULTIPLIER, -size):
		for y in range(-size * OCEAN_MULTIPLIER, size * OCEAN_MULTIPLIER):
			_set_cell(x, y, 4, false)
	for x in range(size, size * OCEAN_MULTIPLIER):
		for y in range(-size * OCEAN_MULTIPLIER, size * OCEAN_MULTIPLIER):
			_set_cell(x, y, 4, false)
	for x in range(-size * OCEAN_MULTIPLIER, size * OCEAN_MULTIPLIER):
		for y in range(-size * OCEAN_MULTIPLIER, -size):
			_set_cell(x, y, 4, false)
	for x in range(-size * OCEAN_MULTIPLIER, size * OCEAN_MULTIPLIER):
		for y in range(size, size * OCEAN_MULTIPLIER):
			_set_cell(x, y, 4, false)

func _is_land(x: int, y: int):
	var vec = Vector2i(x, y)
	if vec not in tile_map_ids:
		return false
	var tile_id = tile_map_ids[vec]
	return tile_id <= 3

func _is_water(x: int, y: int):
	var vec = Vector2i(x, y)
	if vec not in tile_map_ids:
		return true
	var tile_id = tile_map_ids[vec]
	return tile_id == 4

func _generate_borders():
	var borders_node = Node2D.new()
	tile_map.add_child(borders_node)
	borders_node.name = "Borders"
	
	var wall_id = 1
	for x in range(-size, size):
		for y in range(-size, size):
			if _is_land(x, y):
				var water_directions = []
				for coords in [Vector2i(0, 1), Vector2i(1, 0), Vector2i(0, -1), Vector2i(-1, 0)]:
					if _is_water(x + coords.x, y + coords.y):
						water_directions.append(coords)
				if len(water_directions) == 4: # ignore land tiles surrounded by water
					continue
				for coords in water_directions:
					var static_body = StaticBody2D.new()
					borders_node.add_child(static_body)
					static_body.name = "Wall" + str(wall_id)
					wall_id += 1
					
					var collision_shape = CollisionShape2D.new()
					static_body.add_child(collision_shape)
					var shape = RectangleShape2D.new()
					var is_half_wall: bool
					if coords.x != 0:
						shape.size = Vector2(16, 0)
					else:
						shape.size = Vector2(32, 0)
					collision_shape.shape = shape
					
					var offset = Vector2(coords) * Vector2(16, 16)
					if coords.y == -1:
						offset.y *= 2
					static_body.position = tile_map.map_to_local(Vector2i(x, y)) + offset
					if coords.x != 0:
						static_body.rotate(PI / 2)
						static_body.translate(Vector2(0, -8))


func _generate_structures():
	structure_manager.tile_map_ids = tile_map_ids
	for x in range(-size, size):
		for y in range(-size, size):
			if _is_water(x, y) or x == 0 and y == 0:
				continue
			
			var tile_id = tile_map_ids[Vector2i(x, y)]
			for config in STRUCTURE_PROB_MAP:
				var structure_data = config["data"]
				var grid_index = StructureManager.get_grid_index(Vector2(x, y) * 32, structure_data["grid_size"])
				if not structure_manager.can_place_structure(grid_index, structure_data["grid_size"]):
					continue
				
				if randf() < config["probs"][tile_id]:
					structure_manager.create_structure(structure_data["resource"], grid_index, structure_data["grid_size"])
