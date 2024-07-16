class_name MinableStructure extends Structure

var time: float = 2.0
var interval_id: int = -1

func _get_production_material_id() -> int:
	return -1


func get_player_position() -> Vector2:
	return Vector2.ZERO


func begin_mining():
	interval_id = Clock.interval(2.0, _produce_material.bind())

func end_mining():
	Clock.remove_interval(time, interval_id)
	interval_id = -1

func destroy():
	if interval_id != -1:
		Clock.remove_interval(time, interval_id)
	super.destroy()


func add_material(material: RawMaterial):
	material_node.add_child(material)
	material.global_position = global_position
	material.add_to_player_inventory()


func _produce_material():
	var material = RawMaterialManager.instantiate_material(_get_production_material_id())
	add_material(material)
