class_name PlayerBuildMenu extends ScrollContainer

const STRUCTURE_SELECT = preload("res://ui/shared/structure_select/structure_select.tscn")

@onready var grid_container: Container = $MarginContainer/GridContainer

func _ready():
	var models := [
		ConveyorPlaceholder.get_model(),
		CurvedConveyorRightPlaceholder.get_model(),
		CurvedConveyorLeftPlaceholder.get_model(),
		TunnelInPlaceholder.get_model(),
		WorkshopPlaceholder.get_model(),
		FurnacePlaceholder.get_model(),
		StoragePlaceholder.get_model(),
		MergerPlaceholder.get_model(),
		CoalPowerPlantPlaceholder.get_model()
	]
	
	for model in models:
		var structure_ui = STRUCTURE_SELECT.instantiate()
		grid_container.add_child(structure_ui)
		structure_ui.set_model(model)
		structure_ui.set_root_ui_node(find_parent("PlayerMenu"))
