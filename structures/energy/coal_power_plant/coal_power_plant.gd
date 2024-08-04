class_name CoalPowerPlant extends PowerPlant


static var GRID_SIZE: Vector2i = Vector2i(1, 1)
func get_grid_size() -> Vector2i:
	return GRID_SIZE

func _get_energy_rate() -> int:
	return 5

func _ready():
	super._ready()

func can_accept_material(material: RawMaterial):
	if material.get_material_id() != Coal.MATERIAL_ID:
		return false
	return true
