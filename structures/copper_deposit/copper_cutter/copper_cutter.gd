class_name CopperCutter extends MaterialProducer

func get_grid_size() -> Vector2i:
	return CopperDeposit.GRID_SIZE


func _get_production_material_id()-> int:
	return Copper.MATERIAL_ID


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
		preload("res://structures/copper_deposit/copper_cutter/copper_cutter.tscn"), 
		preload("res://robots/drill_robot/drill_robot_display.png"))

