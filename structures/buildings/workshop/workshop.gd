class_name Workshop extends Building

static var GRID_SIZE: Vector2i = Vector2i(1, 1)
func get_grid_size() -> Vector2i:
	return GRID_SIZE

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var material_models: Dictionary
var current_material: MaterialModel

func set_current_material(material_model: MaterialModel) -> void:
	current_material = material_model

func _get_conveyor_piece_reference_position() -> Vector2:
	return Vector2(0, 15)

func _play_default_animation():
	if animated_sprite_2d.animation != "default":
		animated_sprite_2d.animation_looped.connect(_play_default_animation_delayed)

func _play_default_animation_delayed():
	animated_sprite_2d.play("default")
	animated_sprite_2d.animation_looped.disconnect(_play_default_animation_delayed)

func _play_operate_animation():
	animated_sprite_2d.play("operate")

func _setup_io():
	inputs[0].setup(self, Vector2i.ZERO, PI, true)
	inputs[0].path = paths[0]
	inputs[1].setup(self, Vector2i.ZERO, -PI / 2, true)
	inputs[1].path = paths[1]
	inputs[2].setup(self, Vector2i.ZERO, 0, true)
	inputs[2].path = paths[2]
	inputs[3].setup(self, Vector2i.ZERO, PI / 2, true)
	inputs[3].path = paths[3]
	
	outputs[0].setup(self, Vector2i.ZERO, PI, true)
	outputs[0].path = paths[4]
	outputs[1].setup(self, Vector2i.ZERO, -PI / 2, true)
	outputs[1].path = paths[5]
	outputs[2].setup(self, Vector2i.ZERO, 0, true)
	outputs[2].path = paths[6]
	outputs[3].setup(self, Vector2i.ZERO, PI / 2, true)
	outputs[3].path = paths[7]


func _ready():
	super._ready()
	material_models = RawMaterial.get_models_for_test_workshop(self)
	current_material = material_models[1][0]

func _create_special_ui():
	var material_select_ui := MATERIAL_SELECT_UI.instantiate() as MaterialSelectUI
	add_child(material_select_ui)
	material_select_ui.create_material_selections(material_models, current_material)

func can_accept_material(material: RawMaterial):
	if not super.can_accept_material(material):
		return false
	
	var material_id = material.get_material_id()
	if not RawMaterial.is_ingredient(material_id, current_material.material_id):
		return false
	return true

func _process_material_in_building(material: RawMaterial, ingredients: Array[RawMaterial]):
	var material_id = material.get_material_id()
	if RawMaterial.is_ingredient(material_id, current_material.material_id):
		ingredients.append(material)
	else:
		materials.remove_at(materials.find(material))
		material.queue_free()

func _process_materials_in_building(ingredients: Array[RawMaterial], operational_outputs: Array[OutputNode]):
	var result = RawMaterialManager.has_sufficient_ingredients(current_material.material_id, ingredients)
	if result[0]:
		var used = result[1]
		for material in used:
			materials.remove_at(materials.find(material))
			material.queue_free()
		
		if len(operational_outputs) == 0:
			return
		
		var operational_output = get_next_output(operational_outputs)
		if operational_output == null:
			return
		
		var new_mat := RawMaterialManager.instantiate_material(current_material.material_id)
		material_node.add_child(new_mat)
		new_mat.mock_follow_node = PathFollow2D.new()
		new_mat.mock_follow_node.loop = false
		new_mat.parent = self
		new_mat.disable_collision() # TODO skip full outputs
		operational_output.path.add_child(new_mat.mock_follow_node)
		new_mat.global_position = new_mat.mock_follow_node.global_position
		materials_for_output.append(new_mat)
		materials.append(new_mat)
