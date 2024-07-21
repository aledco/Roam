class_name StructurePlaceholder extends Structure

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

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
	animated_sprite_2d.play("blink")
	SignalManager.structure_clicked.connect(_on_structure_clicked)
	SignalManager.delete_mode_enabled.connect(queue_free)


func _on_structure_clicked(structure: Structure):
	var resource := _get_structure()
	var rpath = resource.resource_path
	var rname = rpath.split("/")[-1].replace(".tscn", "")
	var spath = structure.get_script().resource_path
	var sname = spath.split("/")[-1].replace(".gd", "")
	if rname != sname:
		queue_free()


func get_grid_position() -> Vector2:
	var absolute_position := _calculate_position_from_mouse()
	var grid_position := StructureManager.get_next_grid_multiple(absolute_position) as Vector2
	return grid_position


func get_grid_index() -> Vector2i:
	var grid_position := get_grid_position()
	var grid_index = Vector2i(grid_position / 32)
	return grid_index


func _process(delta):
	var grid_position := get_grid_position()
	var grid_index = Vector2i(grid_position / 32)
	if structure_manager.can_place_structure(grid_index, get_grid_size()):
		position = StructureManager.get_structure_position(grid_position, get_grid_size())


func _input(event):
	if event is InputEventMouseButton:
		if event.is_action_released("left_click"):
			var structure = _create_structure_from_placeholder()
			if _destroy_after_placement():
				queue_free()
	elif event is InputEventKey:
		if _can_rotate() and event.is_action_pressed("rotate"):
				rotate(-PI/2)
				direction = Vector2i(direction.y, -direction.x)
		if event.is_action_pressed("escape") or event.is_action_pressed("build_menu"):
			queue_free()


func _create_structure_from_placeholder() -> Structure: # TODO update overrides
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
