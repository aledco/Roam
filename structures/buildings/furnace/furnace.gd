class_name Furnace extends Building

static var COST := [[IronIngot.MATERIAL_ID, 5], [StoneBrick.MATERIAL_ID, 5]]

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var glow_animation_frame_count := animated_sprite_2d.sprite_frames.get_frame_count("glow")

var fuel := 0
var is_full := false

var materials_waiting_for_output: Array[RawMaterial] = []

var glow_interval_id := -1
const glow_interval_time := 2.0
var glow_animation_active := false


static var GRID_SIZE: Vector2i = Vector2i(1, 1)
func get_grid_size() -> Vector2i:
	return GRID_SIZE


func can_accept_material(material: RawMaterial):
	if not super.can_accept_material(material):
		return false
	
	if not material.is_fuel() and not material.is_smeltable():
		return false 
	
	if material.is_smeltable() and fuel == 0:
		return false
	
	if is_full:
		return false
	return true

func _process_material_in_building(material: RawMaterial):
	if material.is_fuel():
		var mat_fuel = material.get_fuel_value()
		if mat_fuel > fuel:
			fuel = mat_fuel
		Helpers.remove_and_free(materials, material)
		
	elif material.is_smeltable():
		if fuel > 0 and material not in materials_waiting_for_output:
			fuel -= 1
			materials_waiting_for_output.append(material)
	else:
		push_error("Invalid material in furnace: ", str(material.get_material_id()))


func _get_interval_time() -> float:
	return 2.0

func _timed_action():
	if materials_waiting_for_output.is_empty():
		_stop_glow_animation()
		return
	
	var operational_outputs = _get_operational_outputs()
	if operational_outputs.is_empty():
		for material in materials_waiting_for_output:
			Helpers.remove(materials_waiting_for_output, material)
			Helpers.remove_and_free(materials, material)
		_stop_glow_animation()
		return
	
	var operational_output = get_next_output(operational_outputs)
	if operational_output == null:
		is_full = true
		_stop_glow_animation()
		return
	is_full = false
	
	var material = materials_waiting_for_output.pop_front()
	
	var new_mat = material.get_smelted_material()
	material_node.add_child(new_mat)
	new_mat.parent_structure = self
	new_mat.mock_follow_node = PathFollow2D.new()
	new_mat.mock_follow_node.loop = false
	operational_output.path.add_child(new_mat.mock_follow_node)
	new_mat.disable_collision()
	new_mat.global_position = new_mat.mock_follow_node.global_position
	materials_for_output.append(new_mat)
	materials.append(new_mat)
	Helpers.remove_and_free(materials, material)
	
	_play_glow_animation()

func _play_glow_animation():
	if not glow_animation_active:
		glow_animation_active = true
		animated_sprite_2d.animation = "glow"
		animated_sprite_2d.stop()
	elif animated_sprite_2d.frame < glow_animation_frame_count - 1:
		animated_sprite_2d.frame += 1

func _stop_glow_animation():
	if not glow_animation_active:
		return
	
	if animated_sprite_2d.frame == 0:
		glow_animation_active = false
		animated_sprite_2d.play("default")
	else:
		animated_sprite_2d.frame -= 1
