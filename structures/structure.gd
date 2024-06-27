class_name Structure extends StaticBody2D

@onready var structure_manager := get_node("/root/World/StructureManager") as StructureManager
@onready var material_node := get_node("/root/World/Materials")

const BUILD_UI: Resource = preload("res://ui/build/build_ui.tscn")
const MATERIAL_SELECT_UI: Resource = preload("res://ui/material_select/material_select_ui.tscn")

var materials: Array[RawMaterial] = []
var inputs: Array[InputNode] = []
var outputs: Array[OutputNode] = []

var direction := Vector2i(0, 1)

# TODO add errors to abstract functions
# TODO comment functions

# BEGIN abstract functions
func _is_placeholder() -> bool:
	return false

func _get_build_list() -> Array[StructureModel]:
	return []


func _get_material_list() -> Array[MaterialModel]:
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
	var ui_size := build_ui.get_ui_size()
	build_ui.set_position(position - ui_size)


func _create_material_select_ui():
	var material_list := _get_material_list()
	if material_list == []:
		return
	
	var material_select_ui := MATERIAL_SELECT_UI.instantiate() as MaterialSelectUI
	add_child(material_select_ui)
	material_select_ui.create_material_selections(material_list)
	var ui_size := material_select_ui.get_ui_size()
	material_select_ui.set_position(position - ui_size)


func _input_event(viewport, event, shape_idx):
	if _is_placeholder():
		return
	
	if event is InputEventMouseButton:
		if event.is_action_released("left_click"):
			_create_build_ui()
		elif event.is_action_released("right_click"):
			_create_material_select_ui()


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
