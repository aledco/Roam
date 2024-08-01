class_name OutputSelect extends Control

const OUTPUT_SELECT_UI = preload("res://ui/output_select/output_select_ui.tscn")

@onready var button = $Button
@onready var texture_rect = $Buton/TextureRect

var storage: Storage
var current_material: MaterialModel

func set_current_material(model: MaterialModel):
	current_material = model
	texture_rect.texture = model.image
	texture_rect.scale = Vector2(0.5, 0.5)

func _ready():
	button.pressed.connect(_create_material_select)

func setup(storage: Storage):
	self.storage = storage

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
