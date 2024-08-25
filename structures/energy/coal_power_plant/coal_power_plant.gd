class_name CoalPowerPlant extends PowerPlant

static var COST := [[IronIngot.MATERIAL_ID, 5], [StoneBrick.MATERIAL_ID, 5]]

static var GRID_SIZE: Vector2i = Vector2i(1, 1)
func get_grid_size() -> Vector2i:
	return GRID_SIZE

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var smoke_animation_active := false

func _get_energy_rate() -> int:
	return 5

func _play_operate_animation():
	if not smoke_animation_active:
		smoke_animation_active = true
		animated_sprite_2d.play("smoke")
		if animated_sprite_2d.animation_looped.is_connected(_on_smoke_looped):
			animated_sprite_2d.animation_looped.disconnect(_on_smoke_looped)

func _stop_operate_animation():
	if smoke_animation_active:
		smoke_animation_active = false
		animated_sprite_2d.animation_looped.connect(_on_smoke_looped)

func _on_smoke_looped():
	animated_sprite_2d.play("default")
	if animated_sprite_2d.animation_looped.is_connected(_on_smoke_looped):
		animated_sprite_2d.animation_looped.disconnect(_on_smoke_looped)

func can_accept_material(material: RawMaterial):
	if material.get_material_id() != Coal.MATERIAL_ID:
		return false
	return true
