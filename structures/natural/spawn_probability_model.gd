class_name SpawnProbabilityModel extends Object

var _get_structure_resource: Callable
var structure_grid_size: Vector2i
var probabilities: Dictionary

static func create(get_structure_resource: Callable, structure_grid_size: Vector2i, probabilities: Dictionary) -> SpawnProbabilityModel:
	var model := SpawnProbabilityModel.new()
	model._get_structure_resource = get_structure_resource
	model.structure_grid_size = structure_grid_size
	model.probabilities = probabilities
	return model

func get_structure_resource() -> Resource:
	return _get_structure_resource.call()
