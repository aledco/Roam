class_name TreeCutter extends MaterialProducer

func get_grid_size() -> Vector2i:
	return Vector2i(1, 2)


func _get_production_material_id() -> int:
	return Wood.MATERIAL_ID


func _ready():
	super._ready()
	input.setup(self, Vector2i(0, 1), 0)
	
	assert(outputs.size() == 1)
	outputs[0].setup(self, Vector2i(0, 1), 0)


static func get_model(parent: Structure) -> StructureModel:
	return StructureModel.create(
		parent, 
		"Saw", 
		1, 
		preload("res://structures/tree/tree_cutter/tree_cutter.tscn"), 
		preload("res://robots/saw_robot/saw_robot_display.png"))
