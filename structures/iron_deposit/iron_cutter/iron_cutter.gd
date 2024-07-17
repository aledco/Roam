class_name IronCutter extends MaterialProducer

func get_grid_size() -> Vector2i:
	return IronDeposit.GRID_SIZE


func _get_production_material_id()-> int:
	return Iron.MATERIAL_ID


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
		preload("res://structures/iron_deposit/iron_cutter/iron_cutter.tscn"), 
		preload("res://robots/drill_robot/drill_robot_display.png"))
