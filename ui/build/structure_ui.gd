class_name StructureUI extends Control

@onready var button: Button = $Button
@onready var texture: TextureRect = $Button/Texture
@onready var hover_container: Container = $ColorRect/HoverContainer
@onready var color_rect: ColorRect = $ColorRect

@onready var structure_manager := get_node("/root/World/StructureManager") as StructureManager
@onready var player := get_node("/root/World/Player") as Player

const TEXT_LABEL = preload("res://ui/text_label/text_label.tscn")

var model: StructureModel
var ui_root: Node

var material_labels = {}

func set_model(model: StructureModel) -> void:
	self.model = model
	texture.texture = model.image
	
	_add_all_hover_text()
	
	button.pressed.connect(_create_structure)
	button.mouse_entered.connect(color_rect.show)
	button.mouse_exited.connect(color_rect.hide)
	
	if Debug.debug_structures():
		model.cost = []

func _add_all_hover_text():
	_add_hover_text(model.name)
	if not model.cost:
		return
	
	for val in model.cost:
		var material_id = val[0]
		var amount = val[1]
		material_labels[material_id] = _add_hover_text("%s x%s" % [RawMaterialManager.get_material_name(material_id), amount])


func _add_hover_text(text: String) -> RichTextLabel:
	if not text:
		return null
	
	var label = TEXT_LABEL.instantiate() as RichTextLabel
	hover_container.add_child(label)
	label.clear()
	label.add_text(text)
	color_rect.size.y += label.get_content_height() + 2
	return label

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


func _create_structure():
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
		structure_manager.add_child(structure)
		if model.parent:
			model.parent.queue_free()
			structure.set_position(model.parent.position)
			structure_manager.add_structure(structure)
		else:
			structure.set_position(player.position)

	model.on_selected.call()
	ui_root.hide()
