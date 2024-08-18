class_name StructurePlaceholder extends Structure

const TRANPARENT := Color(1, 1, 1, 1)
const RED := Color(2, 0, 0, 2)

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var _is_valid: bool = true
var has_placed := false

# BEGIN abstract functions
func _get_structure() -> Resource:
	return null
	
func _destroy_after_placement() -> bool:
	return false
# END abstract functions


func _is_placeholder() -> bool:
	return true
 

func _can_rotate() -> bool:
	var grid_index = get_grid_index()
	var grid_size = get_grid_size()
	return true


func _ready():
	super._ready()
	z_index = 5
	animated_sprite_2d.play("blink")
	SignalManager.player_input.connect(_on_player_input)
	player.is_placing_structure = true


func _on_player_input(input_type: Player.InputType):
	destroy()


func destroy():
	player.is_placing_structure = false
	queue_free()


func get_grid_position() -> Vector2:
	var mouse_grid_index = structure_manager.get_mouse_grid_index()
	var grid_position = mouse_grid_index * 32
	return grid_position


func _process(delta):
	var grid_position := get_grid_position()
	position = StructureManager.get_structure_position(grid_position, get_grid_size(), direction)
	var grid_index = get_grid_index()
	_is_valid = structure_manager.can_place_structure(grid_index, get_grid_size(), direction)
	_set_valid_overlay()


func _set_valid_overlay():
	if is_valid():
		animated_sprite_2d.self_modulate = TRANPARENT
	else:
		animated_sprite_2d.self_modulate = RED

func is_valid():
	return _is_valid

func _input(event):
	if event is InputEventMouseButton:
		if event.is_action_released("left_click") and is_valid():
			_create_structure_from_placeholder()
			has_placed = true
			if _destroy_after_placement():
				destroy()
		if Debug.debug_grid() and event.is_action_released("right_click"):
			var gp = get_grid_position()
			print(self.name, ".grid_position ", gp)
			print(self.name, ".grid_index ", get_grid_index())
	elif event is InputEventKey:
		if _can_rotate() and event.is_action_pressed("rotate"):
			rotate(-PI/2)
			direction = Vector2i(direction.y, -direction.x)


func _create_structure_from_placeholder() -> Structure:
	var structure = _get_structure().instantiate() as Structure
	structure.set_position(position)
	structure.set_direction(direction)
	structure.delay_input()
	structure_manager.add_structure(structure)
	return structure
