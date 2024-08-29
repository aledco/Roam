class_name CoalPowerPlant extends PowerPlant

static var COST := [[IronIngot.MATERIAL_ID, 5], [StoneBrick.MATERIAL_ID, 5]]

static var GRID_SIZE: Vector2i = Vector2i(1, 1)
func get_grid_size() -> Vector2i:
	return GRID_SIZE

@onready var smoke_node: Node2D = $Smoke
@onready var smoke_array: Array[AnimatedSprite2D] = []

var smoke_animation_active := false


func _get_energy_rate() -> int:
	return 5

func _ready():
	super._ready()
	for node in smoke_node.get_children():
		smoke_array.append(node as AnimatedSprite2D)

func _play_operate_animation():
	if not smoke_animation_active:
		smoke_animation_active = true
		for smoke in smoke_array:
			smoke.play("smoke")
			if smoke.animation_looped.is_connected(_on_smoke_looped):
				smoke.animation_looped.disconnect(_on_smoke_looped)

func _stop_operate_animation():
	if smoke_animation_active:
		smoke_animation_active = false
		for smoke in smoke_array:
			smoke.animation_looped.connect(_on_smoke_looped)

func _on_smoke_looped():
	for smoke in smoke_array:
		smoke.play("default")
		if smoke.animation_looped.is_connected(_on_smoke_looped):
			smoke.animation_looped.disconnect(_on_smoke_looped)

func _get_max_energy_stored() -> int:
	return 20

func can_accept_material(material: RawMaterial):
	if material.get_material_id() != Coal.MATERIAL_ID:
		return false
	return true
