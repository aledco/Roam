class_name StructurePlaceholder extends Structure

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

enum PlacementMode { Free, Restricted }

var mode: PlacementMode = PlacementMode.Free
var parent: TreeStructure = null

# BEGIN abstract functions
func _get_structure() -> Resource:
	return null
	
func _destroy_after_placement() -> bool:
	return false
# END abstract functions


func _is_placeholder() -> bool:
	return true
 

func _can_rotate() -> bool:
	return true

func _ready():
	animated_sprite_2d.play("blink")
	SignalManager.structure_clicked.connect(_on_structure_clicked)
	SignalManager.delete_mode_enabled.connect(queue_free)


func rotate_until_free():
	var structure_grid_index := parent.get_grid_index()
	var structure_grid_size := parent.get_grid_size()
	var grid_index := structure_grid_index + Vector2i(0, structure_grid_size.y)
	var grid_size := get_grid_size()
	var dir := Vector2i(1, 0)
	
	var at_corner = func(grid_index: Vector2i):
		if grid_index == structure_grid_index + Vector2i(-1, -1):
			return true
		if grid_index == structure_grid_index + Vector2i(-1, structure_grid_size.y):
			return true
		if grid_index == structure_grid_index + structure_grid_size:
			return true
		if grid_index == structure_grid_index + Vector2i(structure_grid_size.x, -1):
			return true
		return false
	
	var set_pos = func(grid_index: Vector2i):
		var grid_position = StructureManager.get_grid_position(grid_index)
		global_position = StructureManager.get_structure_position(grid_position, grid_size)
	
	while not structure_manager.can_place_structure(grid_index, grid_size):
		grid_index += dir
		set_pos.call(grid_index)
		if at_corner.call(grid_index):
			dir = Vector2i(dir.y, -dir.x)
			grid_index += dir
			set_pos.call(grid_index)
			rotate(-PI/2)
	set_pos.call(grid_index)


func set_restricted(structure: TreeStructure): # TODO
	mode = PlacementMode.Restricted
	parent = structure
	rotate_until_free()


func _on_structure_clicked(structure: Structure):
	if mode != PlacementMode.Free:
		return
	
	var resource := _get_structure()
	var rpath = resource.resource_path
	var rname = rpath.split("/")[-1].replace(".tscn", "")
	var spath = structure.get_script().resource_path
	var sname = spath.split("/")[-1].replace(".gd", "")
	if rname != sname:
		queue_free()


func _process(delta):
	if mode != PlacementMode.Free:
		return
	
	var absolute_position := _calculate_position_from_mouse()
	var grid_position := StructureManager.get_next_grid_multiple(absolute_position) as Vector2
	var grid_index = Vector2i(grid_position / 32)
	if structure_manager.can_place_structure(grid_index, get_grid_size()):
		position = StructureManager.get_structure_position(grid_position, get_grid_size())


func _input(event):
	if event is InputEventMouseButton:
		if event.is_action_released("left_click"):
			var structure = _create_structure_from_placeholder()
			if mode == PlacementMode.Restricted:
				parent.on_conveyor_placed(structure)
				queue_free()
			if _destroy_after_placement():
				queue_free()
	elif event is InputEventKey:
		if _can_rotate() and event.is_action_pressed("rotate"):
			match mode:
				PlacementMode.Free:
					rotate(-PI/2)
					direction = Vector2i(direction.y, -direction.x)
				PlacementMode.Restricted:
					rotate_until_free()
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
