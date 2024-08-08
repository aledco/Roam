class_name StructureModel extends Object

var parent: Structure
var name: String
var cost: Array
var structure_resource: Resource
var image: Texture2D
var on_selected: Callable

static func create(parent: Structure, 
					name: String, 
					cost: Array,  
					structure_resource: Resource,
					image: Texture2D,
					on_selected: Callable = func(): pass) -> StructureModel:
	var model := StructureModel.new()
	model.parent = parent
	model.name = name
	model.cost = cost
	model.structure_resource = structure_resource
	model.image = image
	model.on_selected = on_selected
	return model
