class_name Furnace extends MultiInputPathedStructure

static var GRID_SIZE: Vector2i = Vector2i(2, 3)

func get_grid_size() -> Vector2i:
	return GRID_SIZE

const NO_SENSOR_STATUS = 0
const WAITING_SENSOR_STATUS = 1
const READY_FOR_PRODUCTION_SENSOR_STATUS = 2

@onready var production_sensors_node: Node2D = $ProductionSensors
@onready var waiting_sensors_node: Node2D = $WaitingSensors
@onready var full_sensor: Area2D = $FullSensor

var production_sensors: Array[Area2D] = []
var waiting_sensors: Array[Area2D] = []
var materials_for_production: Array[RawMaterial] = []
var materials_for_output: Array[RawMaterial] = []

var fuel: int = 0

func _setup_io():
	assert(inputs.size() == 2)
	assert(outputs.size() == 1)
	assert(paths.size() == 3)
	inputs[0].setup(self, Vector2i.ZERO, 0)
	inputs[0].path = paths[0]
	inputs[1].setup(self, Vector2i(1, 0), 0)
	inputs[1].path = paths[1]
	outputs[0].setup(self, Vector2i(1, 2), 0)


func _ready():
	super._ready()
		
	for node in production_sensors_node.get_children():
		production_sensors.append(node as Area2D)
	for node in waiting_sensors_node.get_children():
		waiting_sensors.append(node as Area2D)
		
	_setup_io()


func _insert_material(material: RawMaterial):
	var index = 0
	for mat in materials:
		if mat.get_material_id() == material.get_material_id():
			index += 1
		else:
			break
	materials.insert(index, material)


func produce():
	for mat in materials_for_production:
		if not is_instance_valid(mat):
			materials_for_production.remove_at(materials_for_production.find(mat))
	
	if full_sensor.get_overlapping_bodies().is_empty():
		for mat in materials_for_production:
			if mat.is_fuel():
				var mat_fuel = mat.get_fuel_value()
				if mat_fuel > fuel:
					fuel = mat_fuel
				materials.remove_at(materials.find(mat))
				materials_for_production.remove_at(materials_for_production.find(mat))
				mat.queue_free()

		for mat in materials_for_production:
			if mat.is_smeltable() and fuel > 0:
				materials.remove_at(materials.find(mat))
				
				fuel -= 1
				
				var new_mat = mat.get_smelted_material()
				material_node.add_child(new_mat)
				new_mat.mock_follow_node = PathFollow2D.new()
				new_mat.mock_follow_node.loop = false
				new_mat.parent = self
				paths[-1].add_child(new_mat.mock_follow_node)
				new_mat.global_position = new_mat.mock_follow_node.global_position
				materials_for_output.append(new_mat)
				_insert_material(new_mat)
				
				materials_for_production.remove_at(materials_for_production.find(mat))
				mat.queue_free()
			materials_for_production.clear()
	super.produce()


func _physics_process(delta):
	for material in materials:	
		if not is_instance_valid(material) or material.at_exit_node:
			continue
		
		var output = _get_output(material)
		if output == null:
			match _get_sensor_status(material):
				NO_SENSOR_STATUS: 
					material.try_move(delta * speed)
				WAITING_SENSOR_STATUS:
					material.is_moving = false
				READY_FOR_PRODUCTION_SENSOR_STATUS:
					material.is_moving = false
					if material not in materials_for_production:
						materials_for_production.append(material)	
		else:
			output.material_to_output = true
			material.is_moving = false
			material.at_exit_node = true


func _material_is_valid(material: RawMaterial) -> bool:
	return material.is_fuel() or (material.is_smeltable() and fuel > 0)

func _get_sensor_status(material: RawMaterial) -> int:
	if material in materials_for_output:
		return NO_SENSOR_STATUS
	
	var mat_id = material.get_material_id()
	for i in range(production_sensors.size()):
		var production_bodies = production_sensors[i].get_overlapping_bodies()
		var waiting_bodies = waiting_sensors[i].get_overlapping_bodies()
		if material in waiting_bodies and \
				((production_bodies.size() > 0 and material not in production_bodies) or not _material_is_valid(material)):
			return WAITING_SENSOR_STATUS
		if material in production_bodies:
			return READY_FOR_PRODUCTION_SENSOR_STATUS
	return NO_SENSOR_STATUS
