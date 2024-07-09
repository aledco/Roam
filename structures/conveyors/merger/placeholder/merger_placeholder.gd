class_name MergerPlaceholder extends ConveyorPlaceholder

func _get_structure() -> Resource:
	return preload("res://structures/conveyors/merger/merger.tscn")


static func get_model() -> StructureModel:
	return StructureModel.create(
		null, 
		"Merger", 
		1, 
		preload("res://structures/conveyors/merger/placeholder/merger_placeholder.tscn"),
		preload("res://structures/conveyors/merger/merger.png"))
