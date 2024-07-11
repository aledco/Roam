class_name MaterialModel extends Object

# parent needs to be of Variant type because for some reason, typing it as Workshop breaks the parser
var parent: Variant
var name: String
var material_id: int
var resource: Resource
var image: Texture2D

static func create(parent: Variant, name: String, material_id: int, resource: Resource, image: Texture2D) -> MaterialModel:
	var model := MaterialModel.new()
	model.parent = parent
	model.name = name
	model.material_id = material_id
	model.resource = resource
	model.image = image
	return model
