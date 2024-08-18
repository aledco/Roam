class_name StructureSelect extends Control

@onready var button: Button = $Button
@onready var texture: TextureRect = $Button/Texture
@onready var hover_text: HoverText = $HoverText

@onready var structure_manager := get_node("/root/World/StructureManager") as StructureManager
@onready var player := get_node("/root/World/Player") as Player

const TEXT_LABEL = preload("res://ui/shared/text_label/text_label_small/text_label_small.tscn")

var model: StructureModel
var ui_root: Node

var material_labels = {}

func _ready():
	hover_text.set_hover_target(button)

func set_model(model: StructureModel) -> void:
	self.model = model
	texture.texture = model.image
	_add_all_hover_text()
	button.pressed.connect(_create_structure)
	if Debug.debug_structures():
		model.cost = []

func _add_all_hover_text():
	hover_text.add_hover_text(model.name, Color.DARK_SLATE_BLUE)
	if not model.cost:
		return
	
	for val in model.cost:
		var material_id = val[0]
		var amount = val[1]
		material_labels[material_id] = hover_text.add_hover_text("%s x%s" % [RawMaterialManager.get_material_name(material_id), amount])


func set_root_ui_node(root: Node):
	ui_root = root


func _get_materials_needed() -> Array[int]:
	var materials: Array[int] = []
	for val in model.cost:
		var material_id = val[0]
		var amount = val[1]
		if not player.has_material_in_inventory(material_id, amount):
			materials.append(material_id)
	return materials


func _clear_text_colors():
	for material_id in material_labels:
		var label := material_labels[material_id] as RichTextLabel
		var text = label.get_parsed_text()
		label.clear()
		label.push_color(Color.WHITE)
		label.add_text(text)


func _create_structure(): # TODO this function will only be called for structure placeholders at the moment, make that more clear
	var materials_needed := _get_materials_needed()
	if materials_needed.is_empty():
		player.pay_for_structure(model.cost)
	else:
		for material_id in materials_needed:
			var label := material_labels[material_id] as RichTextLabel
			var text = label.get_parsed_text()
			label.clear()
			label.push_color(Color.RED)
			label.add_text(text)
		Clock.invoke(0.5, _clear_text_colors)
		return
				
	if model.structure_resource:
		var structure = model.structure_resource.instantiate()
		structure.set_position(player.position)
		structure_manager.add_child(structure)

	model.on_selected.call()
	ui_root.hide()
