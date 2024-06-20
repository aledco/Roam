class_name Structure extends StaticBody2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@onready var structure_manager := get_node("/root/World/StructureManager") as StructureManager
@onready var material_node := get_node("/root/World/Materials")

const BUILD_UI = preload("res://ui/build/build_ui.tscn")

var materials: Array[RawMaterial] = []
var inputs: Array[InOutNode] = []
var outputs: Array[InOutNode] = []

var direction := Vector2i(0, 1)

# BEGIN abstract functions
func _is_placeholder() -> bool:
	return false

func _get_build_list() -> Array[StructureModel]:
	return []

func get_grid_size() -> Vector2i:
	return Vector2i.ZERO

func produce():
	pass
# END abstract functions


func _process(delta):
	produce()


func _create_build_ui():
	var build_list := _get_build_list()
	if build_list == []:
		return
	
	var build_ui := BUILD_UI.instantiate() as BuildUI;
	add_child(build_ui)
	build_ui.create_structure_selections(build_list)
	var structure_size := collision_shape_2d.shape.get_rect().size
	var ui_size := build_ui.get_ui_size()
	build_ui.set_position(Vector2(-structure_size.x / 2, -structure_size.y)  - ui_size)


func _input_event(viewport, event, shape_idx):
	if _is_placeholder():
		return
	
	if event is InputEventMouseButton and event.is_action_released("left_click"):
		_create_build_ui()


func get_grid_index() -> Vector2i:
	"""
	Gets the top left index of the structure.
	"""
	var grid_size := get_grid_size()
	var x := int((position.x - ((grid_size.x  * 32) / 2)) / 32)
	var y := int((position.y - ((grid_size.y  * 32) / 2)) / 32)
	return Vector2i(x, y)


func add_material(material: RawMaterial):
	material.reparent(self)
	material.set_position(Vector2.ZERO)


func set_direction(new_direction: Vector2i):
	var angle := Vector2(direction).angle_to(Vector2(new_direction))
	rotate(angle)
	direction = new_direction


func has_input() -> bool:
	return inputs.size() > 0


func has_output() -> bool:
	return outputs.size() > 0
