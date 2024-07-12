class_name MaterialSelectUI extends BaseUI

@onready var main_container: Container = $Control/ScrollContainer
@onready var container: Container = $Control/ScrollContainer/Container

const MATERIAL_UI = preload("res://ui/material_select/material_ui.tscn")

func get_rect() -> Rect2:
	return main_container.get_rect()


func create_material_selections(materials: Array[MaterialModel]) -> void:
	for material in materials:
		_create_material_ui(material)


func _create_material_ui(model: MaterialModel):
	var material_ui = MATERIAL_UI.instantiate() as MaterialUI
	container.add_child(material_ui)
	material_ui.set_model(model)
	material_ui.set_root_ui_node(self)
