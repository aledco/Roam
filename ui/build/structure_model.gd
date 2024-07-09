class_name StructureModel extends Object

var parent: Structure
var name: String
var cost: int
var structure: Resource
var image: Texture2D

static func create(parent: Structure, name: String, cost: int, structure: Resource, image: Texture2D) -> StructureModel:
	var model := StructureModel.new()
	model.parent = parent
	model.name = name
	model.cost = cost
	model.structure = structure
	model.image = image
	return model
