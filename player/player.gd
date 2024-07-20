class_name Player extends CharacterBody2D


const SPEED = 100.0
const BUILD_MENU = preload("res://ui/build/build_menu.tscn")

enum State { Idle, Run, Saw, Drill }

@onready var inventory: Inventory = $Inventory
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var current_state = State.Idle
@onready var camera_2d: Camera2D = $Camera2D

var build_menu: BuildMenu = null
var map_active: bool = false
var is_mining: bool = false
var minable_structure: MinableStructure
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
		escape()
		build_menu.visible = not build_menu.visible
	elif Input.is_action_just_pressed("map"):
		escape(true)
		if map_active:
			camera_2d.zoom = Vector2.ONE
		else:
			camera_2d.zoom *= Vector2(0.1, 0.1)
		map_active = not map_active
	elif Input.is_action_just_pressed("delete"):
		escape(true, true)
		StructureManager.set_delete_mode(not StructureManager.get_delete_mode())
	elif Input.is_action_just_pressed("escape"):
		escape()


func escape(ignore_map = false, ignore_delete_mode = false):
	current_state = State.Idle
		
	if is_mining:
		collision_shape_2d.disabled = false
		minable_structure.end_player_mining()
		is_mining = false
	
	if not ignore_map and map_active:
		camera_2d.zoom = Vector2.ONE
	if not ignore_delete_mode:
		StructureManager.set_delete_mode(false)


func _physics_process(delta):
	player_idle()
	player_run()
	move_and_slide()
	player_animations()


## Sets the player in an idle state.
func player_idle():
	if current_state != State.Saw and current_state != State.Drill:
		current_state = State.Idle


## Controls player movement.
func player_run():
	var x_direction := Input.get_axis("move_left", "move_right")
	var y_direction := Input.get_axis("move_up", "move_down")
	
	if x_direction or y_direction:
		escape()
	
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
		animated_sprite_2d.flip_h = sign(velocity.x) == -1
	else:
		direction = Vector2i(0, sign(velocity.y))
		animated_sprite_2d.flip_h = false


## Manages player animations.
func player_animations():
	match current_state:
		State.Idle:
			animated_sprite_2d.play("idle")
		State.Run:
			match direction:
				Vector2i(0, 1):
					animated_sprite_2d.play("run_front")
				Vector2i(0, -1):
					animated_sprite_2d.play("run_back")
				_:
					animated_sprite_2d.play("run_side")
		State.Saw:
			animated_sprite_2d.play("saw")
		State.Drill:
			animated_sprite_2d.play("drill")


func _mine(target: MinableStructure, state: State):
	current_state = state
	is_mining = true
	minable_structure = target
	collision_shape_2d.disabled = true
	global_position = target.get_player_position()
	target.begin_player_mining()
	
func saw(target: MinableStructure):
	_mine(target, State.Saw)
	
func drill(target: MinableStructure):
	_mine(target, State.Drill)
