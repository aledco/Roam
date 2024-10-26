class_name Player extends CharacterBody2D


const SPEED = 100.0

enum State { Idle, Run, Saw, Drill }
enum InputType { BuildMenu, StructureMenu, StructureSpecialMenu, Map, DeleteMode, Escape, None }

@onready var player_menu: PlayerMenu = $PlayerMenu
@onready var inventory: Inventory = player_menu.get_inventory()
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var current_state = State.Idle
@onready var camera_2d: Camera2D = $Camera2D

var map_active: bool = false
var is_mining: bool = false
var minable_structure: NaturalStructure
var pos_before_mine: Vector2
var direction := Vector2i(0, 1)

var has_menu_open := false
var is_placing_structure := false
var is_deleting_structure := false
var is_placing_wire := false
var is_dragging_stack := false


func is_busy() -> bool:
	return has_menu_open \
		or is_placing_structure \
		or is_placing_wire \
		or is_mining \
		or is_dragging_stack \
		or map_active

func _ready():
	pass

		
func _process(delta):
	player_input()


## Manages player input such as opening the build menu or map.
func player_input():
	if Input.is_action_just_pressed("build_menu"):
		SignalManager.player_input.emit(InputType.BuildMenu)
		escape()
		player_menu.visible = not player_menu.visible
	elif Input.is_action_just_pressed("map"):
		SignalManager.player_input.emit(InputType.Map)
		if not map_active:
			escape()
			map_active = true
			camera_2d.zoom *= Vector2(0.1, 0.1)	
		else:
			escape()
	elif Input.is_action_just_pressed("delete"):
		SignalManager.player_input.emit(InputType.DeleteMode)
		if not is_deleting_structure:
			escape()
			is_deleting_structure = true
			Input.set_custom_mouse_cursor(preload("res://ui/cursor/shovel.png"))
		else:
			escape()
	elif Input.is_action_just_pressed("escape"):
		SignalManager.player_input.emit(InputType.Escape)
		escape()


func escape():
	current_state = State.Idle
		
	if is_mining:
		collision_shape_2d.disabled = false
		minable_structure.end_player_mining()
		global_position = pos_before_mine
		is_mining = false
	
	if map_active:
		camera_2d.zoom = Vector2.ONE
		map_active = false
	
	is_deleting_structure = false
	Input.set_custom_mouse_cursor(null)


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
	if is_mining:
		return
	
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


func _mine(target: NaturalStructure, state: State):
	escape()
	
	current_state = state
	is_mining = true
	minable_structure = target
	collision_shape_2d.disabled = true
	pos_before_mine = global_position
	global_position = target.get_player_position()
	target.begin_player_mining()
	
func saw(target: NaturalStructure):
	_mine(target, State.Saw)

func drill(target: NaturalStructure):
	_mine(target, State.Drill)

func has_material_in_inventory(material_id: int, amount: int = 1) -> bool:
	return inventory.contains_material(material_id, amount)

func pay_for_structure(cost: Array):
	for val in cost:
		var material_id = val[0]
		var amount = val[1]
		inventory.remove_material(material_id, amount)

func set_menu_delayed(value: bool):
	Clock.invoke(0.1, func(): has_menu_open = value)

func set_placing_wire_delayed(value: bool):
	Clock.invoke(0.1, func(): is_placing_wire = value)
