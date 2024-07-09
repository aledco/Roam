class_name BuildUI extends CanvasLayer

@onready var control: Control = $Control
@onready var main_container: Container = $Control/ScrollContainer
@onready var container: Container = $Control/ScrollContainer/Container


const STRUCTURE_UI = preload("res://ui/build/structure_ui.tscn")

func get_ui_size() -> Vector2:
	return main_container.size


func create_structure_selections(structures: Array[StructureModel]) -> void:
	for structure in structures:
		_create_structure_ui(structure)


func _create_structure_ui(model: StructureModel):
	var structure_ui = STRUCTURE_UI.instantiate()
	container.add_child(structure_ui)
	structure_ui.set_model(model)
	structure_ui.set_root_ui_node(self)


func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var ev_local = control.make_input_local(event)
		if !Rect2(Vector2(0,0), main_container.size).has_point(ev_local.position):
			queue_free()
