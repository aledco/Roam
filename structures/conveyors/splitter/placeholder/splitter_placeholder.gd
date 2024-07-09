class_name SplitterPlaceholder extends ConveyorPlaceholder

func _get_structure() -> Resource:
	return preload("res://structures/conveyors/splitter/splitter.tscn")


static func get_model() -> StructureModel:
	return StructureModel.create(
		null, 
		"Splitter", 
		1, 
		preload("res://structures/conveyors/splitter/placeholder/splitter_placeholder.tscn"),
		preload("res://structures/conveyors/splitter/splitter.png"))
