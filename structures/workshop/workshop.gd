class_name Workshop extends MultiInputPathedStructure

const WOOD = preload("res://raw_materials/wood/wood.tscn")

const NO_SENSOR_STATUS = 0
const WAITING_SENSOR_STATUS = 1
const READY_FOR_PRODUCTION_SENSOR_STATUS = 2

@onready var production_sensors_node: Node2D = $ProductionSensors
@onready var waiting_sensors_node: Node2D = $WaitingSensors
@onready var full_sensor: Area2D = $FullSensor

var production_sensors: Array[Area2D] = []
var waiting_sensors: Array[Area2D] = []
var materials_for_production: Array[RawMaterial] = []

static var GRID_SIZE: Vector2i = Vector2i(2, 3)

func get_grid_size() -> Vector2i:
	return GRID_SIZE

func _get_allowed_materials() -> Array:
	return [Wood.MATERIAL_ID]

func _setup_io():
	assert(inputs.size() == 2)
	assert(outputs.size() == 1)
	assert(paths.size() == 3)
	inputs[0].setup(self, Vector2i.ZERO, 0)
	inputs[0].path = paths[0]
	inputs[1].setup(self, Vector2i(1, 0), 0)
	inputs[1].path = paths[1]
	outputs[0].setup(self, Vector2i(1, 2), 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()

	for node in production_sensors_node.get_children():
		production_sensors.append(node as Area2D)
	for node in waiting_sensors_node.get_children():
		waiting_sensors.append(node as Area2D)
		
	_setup_io()


func produce():
	if materials_for_production.size() == 2 and full_sensor.get_overlapping_bodies().is_empty():
		for mat in materials_for_production:
			materials.remove_at(materials.find(mat))
			mat.queue_free()
		materials_for_production.clear()
		
		var new_mat := WOOD.instantiate() as RawMaterial
		material_node.add_child(new_mat)
		new_mat.mock_follow_node = PathFollow2D.new()
		new_mat.mock_follow_node.loop = false
		paths[2].add_child(new_mat.mock_follow_node)
		new_mat.global_position = new_mat.mock_follow_node.global_position
		materials.push_back(new_mat)
	
	super.produce()


func _physics_process(delta):
	for material in materials:	
		if material.at_exit_node:
			continue
		
		var output = _get_output(material)
		if output == null:
			match _get_sensor_status(material):
				NO_SENSOR_STATUS: 
					material.try_move(delta * speed)
				WAITING_SENSOR_STATUS:
					pass
				READY_FOR_PRODUCTION_SENSOR_STATUS:
					if material not in materials_for_production:
						materials_for_production.append(material)
		else:
			output.material_to_output = true
			material.at_exit_node = true


func _get_sensor_status(material: RawMaterial) -> int:
	for i in range(production_sensors.size()):
		var production_bodies = production_sensors[i].get_overlapping_bodies()
		var waiting_bodies = waiting_sensors[i].get_overlapping_bodies()
		if material in waiting_bodies and \
				(production_bodies.size() > 0 or material.get_material_id() not in _get_allowed_materials()):
			return WAITING_SENSOR_STATUS
		if material in production_bodies:
			return READY_FOR_PRODUCTION_SENSOR_STATUS
	return NO_SENSOR_STATUS
