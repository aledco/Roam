class_name BuildMenu extends CanvasLayer

const STRUCTURE_UI = preload("res://ui/build/structure_ui.tscn")

@onready var container = $Control/Container

func _ready():
	var models := [
		[
			StructureModel.create(null, 
				"Conveyor", 1, 
				preload("res://structures/conveyors/conveyor/placeholder/conveyor_placeholder.tscn"),
				preload("res://structures/conveyors/conveyor/conveyor.png"), true),
			StructureModel.create(null, 
				"Right Conveyor", 1, 
				preload("res://structures/conveyors/curved_conveyor/right/placeholder/curved_conveyor_right_placeholder.tscn"),
				preload("res://structures/conveyors/curved_conveyor/right/curved_conveyor_right.png"), true),
			StructureModel.create(null, 
				"Left Conveyor", 1, 
				preload("res://structures/conveyors/curved_conveyor/left/placeholder/curved_conveyor_left_placeholder.tscn"),
				preload("res://structures/conveyors/curved_conveyor/left/curved_conveyor_left.png"), true),
			StructureModel.create(null, 
				"Splitter", 1, 
				preload("res://structures/conveyors/splitter/placeholder/splitter_placeholder.tscn"),
				preload("res://structures/conveyors/splitter/splitter.png"), true),
			StructureModel.create(null, 
				"Merger", 1, 
				preload("res://structures/conveyors/merger/placeholder/merger_placeholder.tscn"),
				preload("res://structures/conveyors/merger/merger.png"), true),
			StructureModel.create(null, 
				"Tunnel", 1, 
				preload("res://structures/conveyors/tunnel/in/placeholder/tunnel_in_placeholder.tscn"),
				preload("res://structures/conveyors/tunnel/in/tunnel_in_display.png"), true),
			StructureModel.create(null, 
				"Workshop", 1, 
				preload("res://structures/workshop/placeholder/workshop_placeholder.tscn"),
				preload("res://structures/workshop/workshop_display.png"), true),
		],
	]
	
	for x in range(models.size()):
		for y in range(models[x].size()):
			_create_structure_ui(models[x][y])


func _create_structure_ui(model: StructureModel):
	var structure_ui = STRUCTURE_UI.instantiate() as StructureUI
	container.add_child(structure_ui)
	structure_ui.set_model(model)
	structure_ui.set_root_ui_node(self)
