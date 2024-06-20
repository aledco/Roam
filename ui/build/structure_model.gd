class_name StructureModel extends Object

var parent: Structure
var name: String
var cost: int
var structure: Resource
var image: Texture2D
var is_placeholder: bool

static func create(parent: Structure, name: String, cost: int, structure: Resource, image: Texture2D, is_placeholder: bool = false) -> StructureModel:
	var model := StructureModel.new()
	model.parent = parent
	model.name = name
	model.cost = cost
	model.structure = structure
	model.image = image
	model.is_placeholder = is_placeholder
	return model
