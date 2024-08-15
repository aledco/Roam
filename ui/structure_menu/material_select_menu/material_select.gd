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
	
	hover_text.add_hover_text(model.name, Color.DARK_SLATE_BLUE)
	# TODO add ingredients to hover text
	
	button.pressed.connect(_set_material)


func set_root_ui_node(root: Node):
	ui_root = root


func _set_material():
	model.parent.set_current_material(model)
	ui_root.queue_free()

func set_selected(selected: bool):
	overlay.visible = selected
