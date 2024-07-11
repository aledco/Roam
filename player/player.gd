class_name Player extends CharacterBody2D


const SPEED = 100.0
const BUILD_MENU = preload("res://ui/build/build_menu.tscn")

enum State { Idle, Run }

@onready var inventory: Inventory = $Inventory
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var current_state = State.Idle
@onready var camera_2d: Camera2D = $Camera2D

var build_menu: BuildMenu = null
var map_active: bool = false
var direction := Vector2i(0, 1)

func _ready():
	build_menu = BUILD_MENU.instantiate() as BuildMenu
	add_child(build_menu)
	build_menu.hide()

		
func _process(delta):
	player_input()


## Manages player input such as opening the build menu or map.
func player_input():
	if Input.is_action_just_pressed("build_menu"):
		build_menu.visible = not build_menu.visible
	if Input.is_action_just_pressed("map"): # TODO better map system
		if map_active:
			camera_2d.zoom = Vector2.ONE
		else:
			camera_2d.zoom *= Vector2(0.05, 0.05)
		map_active = not map_active


func _physics_process(delta):
	player_idle()
	player_run()
	move_and_slide()
	player_animations()


## Sets the player in an idle state.
func player_idle():
	current_state = State.Idle


## Controls player movement.
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
	
	if abs(velocity.x) > abs(velocity.y):
		direction = Vector2i(sign(velocity.x), 0)
	else:
		direction = Vector2i(0, sign(velocity.y))


## Manages player animations.
func player_animations():
	match current_state:
		State.Idle:
			animated_sprite_2d.play("idle")
		State.Run:
			animated_sprite_2d.play("run")
