class_name StoneCutter extends MaterialProducer

func get_grid_size() -> Vector2i:
	return BoulderStructure.GRID_SIZE


func _get_production_material() -> Resource:
	return preload("res://raw_materials/stone/stone.tscn")


func _ready():
	super._ready()
	input.setup(self, Vector2i(0, 0), 0)
	
	assert(outputs.size() == 1)
	outputs[0].setup(self, Vector2i(0, 0), 0)


static func get_model(parent: Structure) -> StructureModel:
	return StructureModel.create(
		parent, 
		"Stone Cutter", 
		1, 
		preload("res://structures/boulder/stone_cutter/stone_cutter.tscn"), 
		preload("res://structures/boulder/stone_cutter/stone_cutter.png"))
