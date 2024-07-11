class_name BuildMenu extends BaseUI

const STRUCTURE_UI = preload("res://ui/build/structure_ui.tscn")

@onready var container = $Control/Container

func get_size() -> Vector2:
	return container.size

func destroy():
	hide()

func _ready():
	var models := [
		[
			ConveyorPlaceholder.get_model(),
			CurvedConveyorRightPlaceholder.get_model(),
			CurvedConveyorLeftPlaceholder.get_model(),
			SplitterPlaceholder.get_model(),
			MergerPlaceholder.get_model(),
			TunnelInPlaceholder.get_model(),
			WorkshopPlaceholder.get_model(),
			StoragePlaceholder.get_model()
		],
	]
	
	for x in range(models.size()):
		for y in range(models[x].size()):
			_create_structure_ui(models[x][y])


func _create_structure_ui(model: StructureModel):
	var structure_ui = STRUCTURE_UI.instantiate()
	container.add_child(structure_ui)
	structure_ui.set_model(model)
	structure_ui.set_root_ui_node(self)

