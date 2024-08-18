class_name OutputSelectUI extends BaseUI

const MATERIAL_SELECT = preload("res://ui/structure_menu/material_select_menu/material_select.tscn")

@onready var container: Container = $Control/PanelContainer/ScrollContainer/MarginContainer/Container

func get_rect() -> Rect2:
	return Rect2(Vector2.ZERO, get_root_control().size)

func create_material_selections(material_models: Array[MaterialModel], currently_selected: MaterialModel) -> void:
	for material in material_models:
		var material_ui := _create_material_ui(material)
		if currently_selected:
			material_ui.set_selected(material.material_id == currently_selected.material_id)


func _create_material_ui(model: MaterialModel) -> MaterialSelect:
	var material_ui = MATERIAL_SELECT.instantiate() as MaterialSelect
	container.add_child(material_ui)
	material_ui.set_model(model)
	material_ui.set_root_ui_node(self)
	return material_ui

func update_material_selections(material_models: Array[MaterialModel], currently_selected: MaterialModel) -> void:
	for material_select in container.get_children():
		material_select.queue_free()
	create_material_selections.call_deferred(material_models, currently_selected)

func destroy():
	hide()
