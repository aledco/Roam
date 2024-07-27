class_name RawMaterial extends AnimatableBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sensor: Area2D = $Sensor
@onready var player := get_node("/root/World/Player") as Player

static var MATERIAL_SIZE = 16

static var MATERIALS_COLLISION_LAYER = 3
static var UNDERGROUND_COLLISION_LAYER = 5

var parent: Structure = null

var at_exit_node: bool = false
var mock_follow_node: PathFollow2D
var is_moving: bool = false


## Determines if a material is an ingredient for another.
static func is_ingredient(ingredient: int, product: int) -> bool:
	var materials_needed = RawMaterialManager.get_material_ingredients(product)
	for config in materials_needed:
		if ingredient == config[0]:
			return true
	return false


static func get_models_for_workshop(workshop: BaseWorkshop) -> Array[MaterialModel]:
	var models: Array[MaterialModel] = []
	for mat_id in RawMaterialManager.material_ids:
		if RawMaterialManager.get_amount_of_ingredients(mat_id) == workshop.get_num_inputs():
			models.append(RawMaterialManager.get_model(mat_id, workshop))
	return models


## Handles the event when a player clicks on the material.
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_action_released("left_click"):
			add_to_player_inventory(true, false)


func add_to_player_inventory(remove_from_materials=false, destroy_if_full=true):
	if not player.inventory.is_full(get_material_id()):
		if remove_from_materials:
			var index = parent.materials.find(self)
			parent.materials.remove_at(index)
		
		player.inventory.add_material(self)
		queue_free()
	elif destroy_if_full:
		queue_free()


## Gets the material id.
func get_material_id() -> int:
	push_error("abstract function")
	return -1


## Gets the material image.
func get_material_image() -> Texture2D:
	push_error("abstract function")
	return null


func get_fuel_value() -> int:
	return 0

func is_fuel() -> bool:
	return get_fuel_value() > 0

func is_smeltable() -> bool:
	return false

func _get_smelted_material_id() -> int:
	push_error("abstract function")
	return -1
	
func get_smelted_material() -> RawMaterial:
	var mat_id = _get_smelted_material_id()
	return RawMaterialManager.instantiate_material(mat_id)

## Attempts to move the material along a path.
func try_move(speed: float) -> bool:
	if not mock_follow_node:
		return false
	
	mock_follow_node.progress += speed
	var velocity := (mock_follow_node.global_position - global_position).normalized() * speed
	_align_sensor(velocity)
	var collision := move_and_collide(velocity, true)
	if collision == null or not _is_collision_blocking(collision):
		move_and_collide(velocity)
		is_moving = true
		return true
	else:
		mock_follow_node.progress -= speed
		is_moving = false
		return false


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
