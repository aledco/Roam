class_name TreeCutter extends MaterialProducer

func get_grid_size() -> Vector2i:
	return Vector2i(1, 2)


func _get_production_material() -> Resource:
	return preload("res://raw_materials/wood/wood.tscn")


func _ready():
	super._ready()
	input.setup(self, Vector2i(0, 1), 0)
	
	assert(outputs.size() == 1)
	outputs[0].setup(self, Vector2i(0, 1), 0)