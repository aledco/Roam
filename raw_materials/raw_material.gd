class_name RawMaterial extends AnimatableBody2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var at_exit_node: bool = false
var mock_follow_node: PathFollow2D


func try_move(speed: float):
	mock_follow_node.progress += speed
	var velocity := (mock_follow_node.global_position - global_position).normalized() * speed
	var collision := move_and_collide(velocity, true)
	if collision == null:
		move_and_collide(velocity)
