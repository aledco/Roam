class_name BaseWorkshop extends MultiInputPathedStructure

const BOX = preload("res://raw_materials/box/box.tscn")

const NO_SENSOR_STATUS = 0
const WAITING_SENSOR_STATUS = 1
const READY_FOR_PRODUCTION_SENSOR_STATUS = 2

@onready var production_sensors_node: Node2D = $ProductionSensors
@onready var waiting_sensors_node: Node2D = $WaitingSensors
@onready var full_sensor: Area2D = $FullSensor

var production_sensors: Array[Area2D] = []
var waiting_sensors: Array[Area2D] = []
var materials_for_production: Array[RawMaterial] = []

var current_material: MaterialModel

func get_num_inputs() -> int:
	return 0

func _setup_io():
	pass


func set_current_material(material_model: MaterialModel) -> void:
	current_material = material_model


func _ready():
	super._ready()
	
	var models = RawMaterial.get_models_for_workshop(self)
	if len(models) > 0:
		current_material = models[0]
		
	for node in production_sensors_node.get_children():
		production_sensors.append(node as Area2D)
	for node in waiting_sensors_node.get_children():
		waiting_sensors.append(node as Area2D)
		
	_setup_io()

func _create_special_ui():
	var material_list = RawMaterial.get_models_for_workshop(self)
	if material_list == []:
		return
	
	var material_select_ui := MATERIAL_SELECT_UI.instantiate() as MaterialSelectUI
	add_child(material_select_ui)
	material_select_ui.create_material_selections(material_list)


func produce():
	if materials_for_production.size() == len(inputs) and full_sensor.get_overlapping_bodies().is_empty():
		for mat in materials_for_production:
			materials.remove_at(materials.find(mat))
			mat.queue_free()
		materials_for_production.clear()
		
		var new_mat := RawMaterialManager.instantiate_material(current_material.material_id)
		material_node.add_child(new_mat)
		new_mat.mock_follow_node = PathFollow2D.new()
		new_mat.mock_follow_node.loop = false
		new_mat.parent = self
		paths[-1].add_child(new_mat.mock_follow_node)
		new_mat.global_position = new_mat.mock_follow_node.global_position
		var index = 0
		for material in materials:
			if material.get_material_id() == new_mat.get_material_id():
				index += 1
			else:
				break
		materials.insert(index, new_mat)
	
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
	var mat_id = material.get_material_id()
	if mat_id == current_material.material_id:
		return NO_SENSOR_STATUS
	
	for i in range(production_sensors.size()):
		var production_bodies = production_sensors[i].get_overlapping_bodies()
		var waiting_bodies = waiting_sensors[i].get_overlapping_bodies()
		if material in waiting_bodies and \
				((production_bodies.size() > 0 and material not in production_bodies) or \
				not RawMaterial.is_ingredient(mat_id, current_material.material_id)):
			return WAITING_SENSOR_STATUS
		if material in production_bodies:
			return READY_FOR_PRODUCTION_SENSOR_STATUS
	return NO_SENSOR_STATUS
