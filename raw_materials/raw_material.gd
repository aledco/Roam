class_name RawMaterial extends AnimatableBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

const MATERIALS_COLLISION_LAYER = 3
const UNDERGROUND_COLLISION_LAYER = 5

var at_exit_node: bool = false
var mock_follow_node: PathFollow2D
var is_moving: bool = false

func get_material_id() -> int:
	push_error("abstract function")
	return -1


func try_move(speed: float) -> bool:
	mock_follow_node.progress += speed
	var velocity := (mock_follow_node.global_position - global_position).normalized() * speed
	var collision := move_and_collide(velocity, true)
	if collision == null:
		move_and_collide(velocity)
		is_moving = true
		return true
	is_moving = false
	return false


func start_tunnel():
	set_collision_mask_value(UNDERGROUND_COLLISION_LAYER, true)


func toggle_underground(hidden: bool):
	sprite_2d.visible = not hidden
	if hidden:
		set_collision_layer_value(UNDERGROUND_COLLISION_LAYER, true)
		set_collision_layer_value(MATERIALS_COLLISION_LAYER, false)
		set_collision_mask_value(MATERIALS_COLLISION_LAYER, false)
	else:
		set_collision_layer_value(MATERIALS_COLLISION_LAYER, true)
		set_collision_mask_value(MATERIALS_COLLISION_LAYER, true)


func finish_tunnel():
	set_collision_layer_value(UNDERGROUND_COLLISION_LAYER, false)
	set_collision_mask_value(UNDERGROUND_COLLISION_LAYER, false)

