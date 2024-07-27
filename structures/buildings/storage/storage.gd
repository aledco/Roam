class_name Storage extends PathedStructure

const STORAGE_UI = preload("res://ui/inventory/storage_ui.tscn")

@onready var end_node: OutputNode = $EndNode

var storage: StorageUI

func get_grid_size() -> Vector2i:
	return Vector2i(1, 1)


func _ready():
	super._ready()
	end_node.setup(self, Vector2i.ZERO, 0)
	
	assert(inputs.size() == 1)
	assert(paths.size() == 1)
	inputs[0].setup(self, Vector2i.ZERO, 0)
	inputs[0].path = paths[0]
	
	storage = STORAGE_UI.instantiate() as StorageUI
	add_child(storage)
	storage.hide()


func _create_special_ui():
	storage.show()


func produce():
	if materials.size() == 0:
		return
	
	if end_node.material_to_output:
		var material = materials.pop_front()
		end_node.material_to_output = false
		storage.add_material(material)
		material.queue_free()


func _physics_process(delta):
	for material in materials:
		if material.at_exit_node or storage.is_full(material.get_material_id()):
			continue
		
		if material in end_node.get_overlapping_bodies():
			end_node.material_to_output = true
			material.at_exit_node = true
		else:
			material.try_move(delta * speed)
