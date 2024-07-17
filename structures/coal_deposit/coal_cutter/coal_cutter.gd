class_name CoalCutter extends MaterialProducer

func get_grid_size() -> Vector2i:
	return CoalDeposit.GRID_SIZE


func _get_production_material_id()-> int:
	return Coal.MATERIAL_ID


func _ready():
	super._ready()
	input.setup(self, Vector2i(0, 0), 0)
	
	assert(outputs.size() == 1)
	outputs[0].setup(self, Vector2i(0, 0), 0)


static func get_model(parent: Structure) -> StructureModel:
	return StructureModel.create(
		parent, 
		"Drill", 
		1, 
		preload("res://structures/coal_deposit/coal_cutter/coal_cutter.tscn"), 
		preload("res://robots/drill_robot/drill_robot_display.png"))

