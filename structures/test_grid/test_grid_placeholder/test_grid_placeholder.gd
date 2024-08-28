class_name TestGridPlaceholder extends StructurePlaceholder

@onready var sprite_2d: Sprite2D = $Sprite2D

var x: int
var y: int

func get_grid_size() -> Vector2i:
	return Vector2i(x, y)

func _ready():
	z_index = 5
	SignalManager.player_input.connect(_on_player_input)
	player.is_placing_structure = true

func _set_valid_overlay():
	if is_valid():
		sprite_2d.self_modulate = TRANPARENT
	else:
		sprite_2d.self_modulate = RED

func _get_structure() -> Resource:
	var grid_size_str = "%sx%s" % [x, y]
	return  load("res://structures/test_grid/test_grid_%s/test_grid_%s.tscn" % [grid_size_str, grid_size_str])

func setup(x: int, y: int):
	self.x = x
	self.y = y
	
	reparent(structure_manager)
	set_position(player.position)
	var grid_size_str = "%sx%s" % [x, y]
	sprite_2d.texture = load("res://structures/test_grid/test_grid_%s/test_grid_%s.png" % [grid_size_str, grid_size_str])

static func _create_structure(x: int, y: int):
	var resource = load("res://structures/test_grid/test_grid_placeholder/test_grid_placeholder.tscn")
	var structure = resource.instantiate()
	Debug.add_child(structure)
	structure.setup.call_deferred(x, y)

static func get_models() -> Array[StructureModel]:
	var arrays: Array[StructureModel] = []
	for x in range(1, 4):
		for y in range(1, 4):
			if x == 1 and y == 1:
				continue
			var grid_size_str = "%sx%s" % [x, y]
			arrays.append(StructureModel.create(
				"Test Grid %s" % grid_size_str,
				[[Wood.MATERIAL_ID, 1]], 
				null,
				 load("res://structures/test_grid/test_grid_%s/test_grid_%s.png" % [grid_size_str, grid_size_str]),
				_create_structure.bind(x, y)))
	return arrays
