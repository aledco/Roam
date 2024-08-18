class_name SpawnProbabilityModel extends Object

var structure_resource: Resource
var structure_grid_size: Vector2i
var probabilities: Dictionary

static func create(structure_resource: Resource, structure_grid_size: Vector2i, probabilities: Dictionary) -> SpawnProbabilityModel:
	var model := SpawnProbabilityModel.new()
	model.structure_resource = structure_resource
	model.structure_grid_size = structure_grid_size
	model.probabilities = probabilities
	return model
