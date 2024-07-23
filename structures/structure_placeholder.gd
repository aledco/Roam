class_name StructurePlaceholder extends Structure

const TRANPARENT := Color(1, 1, 1, 1)
const RED := Color(2, 0, 0, 2)

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var is_valid: bool = true

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
	z_index = 5
	animated_sprite_2d.play("blink")
	SignalManager.player_input.connect(_on_player_input)
	player.is_placing = true


func _on_player_input(input_type: Player.InputType):
	destroy()


func destroy():
	player.is_placing = false
	queue_free()


func get_grid_position() -> Vector2:
	var absolute_position := _calculate_position_from_mouse()
	var grid_position := StructureManager.get_next_grid_multiple(absolute_position) as Vector2
	return grid_position


func get_grid_index_from_position(grid_position: Vector2) -> Vector2i:
	var grid_size = get_grid_size()
	if direction.y == 1:
		pass
	elif direction.y == -1:
		grid_position.x += (grid_size.x - 1) * 32
		grid_position.y += (grid_size.y - 1) * 32
	elif direction.x == 1:
		grid_position.y += (grid_size.x - 1) * 32
	elif direction.x == -1:
		grid_position.x += (grid_size.x - 1) * 32
	return Vector2i(grid_position / 32)


func _process(delta):
	var grid_position := get_grid_position()
	position = StructureManager.get_structure_position(grid_position, get_grid_size(), direction)
	var grid_index = get_grid_index_from_position(grid_position)
	is_valid = structure_manager.can_place_structure(grid_index, get_grid_size(), false, direction)
	if is_valid:
		animated_sprite_2d.self_modulate = TRANPARENT
	else:
		animated_sprite_2d.self_modulate = RED


func _input(event):
	if event is InputEventMouseButton:
		if event.is_action_released("left_click") and is_valid:
			_create_structure_from_placeholder()
			if _destroy_after_placement():
				destroy()
		if StructureManager.DEBUG_GRID and event.is_action_released("right_click"):
			var gp = get_grid_position()
			print(self.name, ".grid_position ", gp)
			print(self.name, ".grid_index ", get_grid_index_from_position(gp))
	elif event is InputEventKey:
		if _can_rotate() and event.is_action_pressed("rotate"):
			rotate(-PI/2)
			direction = Vector2i(direction.y, -direction.x)


func _create_structure_from_placeholder() -> Structure:
	var structure = _get_structure().instantiate() as Structure
	get_parent().add_child(structure)
	structure.set_position(position)
	structure.set_direction(direction)
	structure.delay_input()
	structure_manager.add_structure(structure)
	return structure


func _calculate_position_from_mouse() -> Vector2:
	var absolute_position := get_global_mouse_position()
	if absolute_position.x < 0:
		absolute_position.x -= 32
	if absolute_position.y < 0:
		absolute_position.y -= 32
	return absolute_position
