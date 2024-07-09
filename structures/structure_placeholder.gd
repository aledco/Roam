class_name StructurePlaceholder extends Structure

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# BEGIN abstract functions
func _get_structure() -> Resource:
	return null
# END abstract functions


func _is_placeholder() -> bool:
	return true
 

func _can_rotate() -> bool:
	return true


func _ready():
	animated_sprite_2d.play("blink")


func _process(delta):
	var absolute_position := _calculate_position_from_mouse()
	var grid_position := StructureManager.get_next_grid_multiple(absolute_position) as Vector2
	var grid_index = Vector2i(grid_position / 32)
	if structure_manager.can_place_structure(grid_index, get_grid_size()):
		position = StructureManager.get_structure_position(grid_position, get_grid_size())

 
func _input(event):
	if event is InputEventMouseButton and event.is_action_released("left_click"):
		_create_structure()
	elif event is InputEventKey and event.is_action_pressed("escape"):
		queue_free()
		
	if _can_rotate() and event.is_action_pressed("rotate"):
		rotate(-PI/2)
		direction = Vector2i(direction.y, -direction.x)


func _create_structure():
	var structure = _get_structure().instantiate() as Structure
	get_parent().add_child(structure)
	structure.set_position(position)
	structure.set_direction(direction)
	structure_manager.add_structure(structure)
	#queue_free()


func _calculate_position_from_mouse() -> Vector2:
	var absolute_position := get_global_mouse_position()
	if absolute_position.x < 0:
		absolute_position.x -= 32
	if absolute_position.y < 0:
		absolute_position.y -= 32
	return absolute_position
