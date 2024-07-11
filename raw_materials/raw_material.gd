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

## Gets the material resource by material id.
static func get_material_by_id(material_id: int) -> Resource:
	match material_id:
		Wood.MATERIAL_ID:
			return preload("res://raw_materials/wood/wood.tscn")
		Stone.MATERIAL_ID:
			return preload("res://raw_materials/stone/stone.tscn")
		Box.MATERIAL_ID:
			return preload("res://raw_materials/box/box.tscn")
		Plank.MATERIAL_ID:
			return preload("res://raw_materials/plank/plank.tscn")
		_:
			push_error("material has not been registered")
			return null


## Gets the ids of the materials needed to produce the given material.
static func get_materials_for_production(material_id: int) -> Array:
	match material_id:
		Wood.MATERIAL_ID:
			return []
		Stone.MATERIAL_ID:
			return []
		Box.MATERIAL_ID:
			return [[Plank.MATERIAL_ID, 2]]
		Plank.MATERIAL_ID:
			return [[Wood.MATERIAL_ID, 2]]
		_:
			push_error("material has not been registered")
			return []


## Determines if a material is an ingredient for another.
static func is_ingredient(ingredient: int, product: int) -> bool:
	var materials_needed = get_materials_for_production(product)
	for config in materials_needed:
		if ingredient == config[0]:
			return true
	return false


static func get_models_for_workshop(workshop: BaseWorkshop) -> Array[MaterialModel]:
	match workshop.get_num_inputs():
		1:
			return [
				Plank.get_model(workshop)
			]
		2:
			return [
				Box.get_model(workshop)
			]
		3:
			return []
		_:
			push_error("workshop has not been registered")
			return []


## Handles the event when a player clicks on the material.
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_action_released("left_click") and not player.inventory.is_full(get_material_id()):
			var index = parent.materials.find(self)
			parent.materials.remove_at(index)
			player.inventory.add_material(self)
			queue_free()


## Gets the material id.
func get_material_id() -> int:
	push_error("abstract function")
	return -1


## Gets the material image.
func get_material_image() -> Texture2D:
	push_error("abstract function")
	return null


## Attempts to move the material along a path.
func try_move(speed: float) -> bool:
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
