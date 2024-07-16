class_name BuildMenu extends BaseUI

const STRUCTURE_UI = preload("res://ui/build/structure_ui.tscn")

@onready var container = $Control/Container

func get_rect() -> Rect2:
	return container.get_rect()

func destroy():
	hide()

func _ready():
	var models := [
		ConveyorPlaceholder.get_model(),
		CurvedConveyorRightPlaceholder.get_model(),
		CurvedConveyorLeftPlaceholder.get_model(),
		SplitterPlaceholder.get_model(),
		MergerPlaceholder.get_model(),
		TunnelInPlaceholder.get_model(),
		Workshop1Placeholder.get_model(),
		Workshop2Placeholder.get_model(),
		Workshop3Placeholder.get_model(),
		StoragePlaceholder.get_model(),
	]
	
	for i in range(len(models)):
		_create_structure_ui(models[i])	


func _create_structure_ui(model: StructureModel):
	var structure_ui = STRUCTURE_UI.instantiate()
	container.add_child(structure_ui)
	structure_ui.set_model(model)
	structure_ui.set_root_ui_node(self)

