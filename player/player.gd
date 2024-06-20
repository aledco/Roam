class_name Player extends CharacterBody2D


const SPEED = 100.0
const BUILD_MENU = preload("res://ui/build/build_menu.tscn")

enum State { Idle, Run }

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var current_state = State.Idle

var build_menu: BuildMenu = null

func _process(delta):
	if Input.is_action_just_pressed("menu"):
		if is_instance_valid(build_menu):
			build_menu.queue_free()
		else:
			build_menu = BUILD_MENU.instantiate() as BuildMenu
			add_child(build_menu)


func _physics_process(delta):
	player_idle()
	player_run()
	move_and_slide()
	player_animations()


func player_idle():
	current_state = State.Idle


func player_run():
	var x_direction := Input.get_axis("move_left", "move_right")
	var y_direction := Input.get_axis("move_up", "move_down")
	
	if x_direction:
		velocity.x = x_direction * SPEED
		current_state = State.Run
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if y_direction:
		velocity.y = y_direction * SPEED
		current_state = State.Run
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)


func player_animations():
	match current_state:
		State.Idle:
			animated_sprite_2d.play("idle")
		State.Run:
			animated_sprite_2d.play("run")
