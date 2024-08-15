class_name MaterialSelect extends Control

@onready var button: Button = $Button
@onready var texture: TextureRect = $Button/Texture
@onready var overlay: ColorRect = $Overlay
@onready var hover_text: HoverText = $HoverText

var model: MaterialModel
var ui_root: Node

func _ready():
	hover_text.set_hover_target(button)


func set_model(model: MaterialModel) -> void:
	self.model = model
	
	texture.texture = model.image
	texture.scale = Vector2(16, 16) / model.image.get_size()
	
	_add_all_hover_text()
	
	button.pressed.connect(_set_material)


func _add_all_hover_text():
	hover_text.add_hover_text(model.name, Color.DARK_SLATE_BLUE)
	var ingredients = RawMaterialManager.get_material_ingredients(model.material_id)
	for ingredient in ingredients:
		var ingredient_id = ingredient[0]
		var amount = ingredient[1]
		hover_text.add_hover_text("%s x%s" % [RawMaterialManager.get_material_name(ingredient_id), amount])


func set_root_ui_node(root: Node):
	ui_root = root


func _set_material():
	model.parent.set_current_material(model)
	ui_root.queue_free()

func set_selected(selected: bool):
	overlay.visible = selected
