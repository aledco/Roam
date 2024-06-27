class_name RawMaterial extends AnimatableBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

const MATERIALS_COLLISION_LAYER = 3
const UNDERGROUND_COLLISION_LAYER = 5

var at_exit_node: bool = false
var mock_follow_node: PathFollow2D
var is_moving: bool = false

static func get_material_by_id(material_id: int) -> Resource:
	match material_id:
		Wood.MATERIAL_ID:
			return preload("res://raw_materials/wood/wood.tscn")
		Box.MATERIAL_ID:
			return preload("res://raw_materials/box/box.tscn")
		_:
			push_error("material has not been registered")
			return null


static func get_materials_for_production(material_id: int) -> Array[int]:
	match material_id:
		Wood.MATERIAL_ID:
			return []
		Box.MATERIAL_ID:
			return [Wood.MATERIAL_ID]
		_:
			push_error("material has not been registered")
			return []


func get_material_id() -> int:
	push_error("abstract function")
	return -1


func try_move(speed: float) -> bool:
	mock_follow_node.progress += speed
	var velocity := (mock_follow_node.global_position - global_position).normalized() * speed
	var collision := move_and_collide(velocity, true)
	if collision == null or not _is_collision_blocking(collision, velocity):
		move_and_collide(velocity)
		is_moving = true
		return true
	is_moving = false
	return false


func _is_collision_blocking(collision: KinematicCollision2D, velocity: Vector2) -> bool:
	return true # TODO fix this function
	#var cpos := collision.get_position().normalized()
	#var angle := velocity.normalized().dot(cpos)
	#return angle >= 0.5 and angle <= 1.0
	#
	#var cpos := collision.get_position()
	#var direction := velocity.normalized()
	#var mpos := (global_position + direction * 8)
	#var rect := Rect2(mpos, direction * 16)
	#return rect.has_point(cpos)


func start_tunnel():
	set_collision_mask_value(UNDERGROUND_COLLISION_LAYER, true)


func toggle_underground(underground: bool):
	sprite_2d.visible = not underground
	if underground:
		set_collision_layer_value(UNDERGROUND_COLLISION_LAYER, true)
		set_collision_layer_value(MATERIALS_COLLISION_LAYER, false)
		set_collision_mask_value(MATERIALS_COLLISION_LAYER, false)
	else:
		set_collision_layer_value(MATERIALS_COLLISION_LAYER, true)
		set_collision_mask_value(MATERIALS_COLLISION_LAYER, true)


func finish_tunnel():
	set_collision_layer_value(UNDERGROUND_COLLISION_LAYER, false)
	set_collision_mask_value(UNDERGROUND_COLLISION_LAYER, false)
