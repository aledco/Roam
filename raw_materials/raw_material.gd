class_name RawMaterial extends AnimatableBody2D

signal destroyed(material: RawMaterial)

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sensor: Area2D = $Sensor
@onready var sensor_collision_shape_2d: CollisionShape2D = $Sensor/CollisionShape2D
@onready var player := get_node("/root/World/Player") as Player


static var MATERIAL_SIZE = 16

static var MATERIALS_COLLISION_LAYER = 3
static var UNDERGROUND_COLLISION_LAYER = 5
static var DISABLED_MATERIAL_COLLISION_LAYER = 8

var parent_structure: Structure = null

var at_exit_node: bool = false
var mock_follow_node: PathFollow2D
var is_moving: bool = false
var collision_enabled := true

## Determines if a material is an ingredient for another.
static func is_ingredient(ingredient: int, product: int) -> bool:
	var materials_needed = RawMaterialManager.get_material_ingredients(product)
	return materials_needed.any(func(x): return x[0] == ingredient)


static func get_models_for_workshop(parent_structure: Structure) -> Dictionary:
	var models = {}
	for mat_id in RawMaterialManager.material_ids:
		var n_ingredients = RawMaterialManager.get_amount_of_ingredients(mat_id)
		if n_ingredients > 0:
			if n_ingredients in models:	
				models[n_ingredients].append(RawMaterialManager.get_model(mat_id, parent_structure))
			else:
				models[n_ingredients] = [RawMaterialManager.get_model(mat_id, parent_structure)]
	return models

func destroy():
	destroyed.emit(self)
	queue_free()

## Handles the event when a player clicks on the material.
func _input_event(viewport, event, shape_idx):
	if not sprite_2d.visible or (parent_structure and is_instance_valid(parent_structure) and not parent_structure.are_materials_grabable()) or player.is_busy():
		return
	if event is InputEventMouseButton:
		if event.is_action_released("left_click"):
			add_to_player_inventory(true, false)


func add_to_player_inventory(remove_from_materials=false, destroy_if_full=true):
	if not player.inventory.is_full(get_material_id()):
		if remove_from_materials and parent_structure and is_instance_valid(parent_structure):
			Helpers.remove(parent_structure.materials, self)
		
		player.inventory.add_material(self)
		destroy()
	elif destroy_if_full:
		destroy()


## Gets the material id.
func get_material_id() -> int:
	push_error("abstract function")
	return -1


## Gets the material image.
func get_material_image() -> Texture2D:
	return RawMaterialManager.get_material_image(get_material_id())

func get_fuel_value() -> int:
	return RawMaterialManager.get_material_fuel_value(get_material_id())

func is_fuel() -> bool:
	return RawMaterialManager.is_material_fuel(get_material_id())

func is_smeltable() -> bool:
	return RawMaterialManager.is_material_smeltable(get_material_id())

func _get_smelted_material_id() -> int:
	return RawMaterialManager.get_smelt_target_id(get_material_id())
	
func get_smelted_material() -> RawMaterial:
	var mat_id = _get_smelted_material_id()
	return RawMaterialManager.instantiate_material(mat_id)

## Attempts to move the material along a path.
func try_move(speed: float) -> bool:
	if not mock_follow_node or not is_instance_valid(mock_follow_node) or not mock_follow_node.get_parent():
		return false
	
	mock_follow_node.progress += speed
	var velocity := (mock_follow_node.global_position - global_position).normalized() * speed
	_align_sensor(velocity)
	if collision_enabled:
		var collision := move_and_collide(velocity, true)
		if collision and _is_collision_blocking(collision):
			mock_follow_node.progress -= speed
			is_moving = false
			return false
	move_and_collide(velocity)
	is_moving = true
	return true


## Aligns the materials sensor using its velocity.
func _align_sensor(velocity: Vector2):
	if abs(velocity.x) > abs(velocity.y):
		if velocity.x < 0:
			sensor.rotation = PI
		else:
			sensor.rotation = 0
	else:
		if velocity.y < 0:
			sensor.rotation = 3 * PI / 2
		else:
			sensor.rotation = PI / 2


## Determines if a collision with another material should halt movement.
func _is_collision_blocking(collision: KinematicCollision2D) -> bool:
	return collision.get_collider() in sensor.get_overlapping_bodies()


## Called when the material enters a tunnel.
func start_tunnel():
	set_collision_mask_value(UNDERGROUND_COLLISION_LAYER, true)


## Toggles the material in and out of the underground state.
func toggle_underground(underground: bool):
	sprite_2d.visible = not underground
	if underground:
		set_collision_layer_value(UNDERGROUND_COLLISION_LAYER, true)
		set_collision_layer_value(MATERIALS_COLLISION_LAYER, false)
		set_collision_mask_value(MATERIALS_COLLISION_LAYER, false)
	else:
		set_collision_layer_value(MATERIALS_COLLISION_LAYER, true)
		set_collision_mask_value(MATERIALS_COLLISION_LAYER, true)


## Called when the material exits a tunnel.
func finish_tunnel():
	set_collision_layer_value(UNDERGROUND_COLLISION_LAYER, false)
	set_collision_mask_value(UNDERGROUND_COLLISION_LAYER, false)


func enable_collision():
	collision_enabled = true
	set_collision_layer_value(MATERIALS_COLLISION_LAYER, true)
	set_collision_layer_value(DISABLED_MATERIAL_COLLISION_LAYER, false)
	set_collision_mask_value(MATERIALS_COLLISION_LAYER, true)

func disable_collision():
	collision_enabled = false
	set_collision_layer_value(MATERIALS_COLLISION_LAYER, false)
	set_collision_layer_value(DISABLED_MATERIAL_COLLISION_LAYER, true)
	set_collision_mask_value(MATERIALS_COLLISION_LAYER, false)
