class_name MaterialSelectUI extends Control

@onready var main_container = $ScrollContainer
@onready var container = $ScrollContainer/Container

const MATERIAL_UI = preload("res://ui/material_select/material_ui.tscn")

func get_ui_size() -> Vector2:
	return main_container.size


func create_material_selections(materials: Array[MaterialModel]) -> void:
	for material in materials:
		_create_material_ui(material)


func _create_material_ui(model: MaterialModel):
	var material_ui = MATERIAL_UI.instantiate() as MaterialUI
	container.add_child(material_ui)
	material_ui.set_model(model)
	material_ui.set_root_ui_node(self)


func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var evLocal = make_input_local(event)
		if !Rect2(Vector2(0,0), main_container.size).has_point(evLocal.position):
			queue_free()
