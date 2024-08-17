class_name OutputSelect extends StaticBody2D

const OUTPUT_SELECT_UI = preload("res://ui/structure_menu/output_select/output_select_ui.tscn")

var storage: Storage
var current_material: MaterialModel

func set_current_material(model: MaterialModel):
	current_material = model

func setup(storage: Storage):
	self.storage = storage

func update():
	for child in get_children():
		if child is OutputSelectUI:
			var output_select_ui = child as OutputSelectUI
			output_select_ui.update_material_selections(_get_material_models(), current_material)
	
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		var mouse_event = event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT:
			_create_material_select()

func _create_material_select():
	var output_select_ui := OUTPUT_SELECT_UI.instantiate() as OutputSelectUI
	add_child(output_select_ui)
	output_select_ui.create_material_selections(_get_material_models(), current_material)

func _get_material_models() -> Array[MaterialModel]:
	var models: Array[MaterialModel] = []
	var material_ids = storage.get_stored_material_ids()
	for material_id in material_ids:
		var model = RawMaterialManager.get_model(material_id, self)
		models.append(model)
	return models
