extends Node2D

@onready var structure_manager: StructureManager = $StructureManager

const TREE = preload("res://structures/natural/tree/tree.tscn")

var STRUCTURE_DATA = [
	{
		"resource": TREE,
		"grid_index": Vector2i(-1, -3),
		"grid_size": TreeStructure.GRID_SIZE
	},
	{
		"resource": TREE,
		"grid_index": Vector2i(0, -3),
		"grid_size": TreeStructure.GRID_SIZE
	},
	{
		"resource": TREE,
		"grid_index": Vector2i(1, -3),
		"grid_size": TreeStructure.GRID_SIZE
	},
	{
		"resource": TREE,
		"grid_index": Vector2i(2, -3),
		"grid_size": TreeStructure.GRID_SIZE
	}
]

func _ready():
	for data in STRUCTURE_DATA:	
		structure_manager.create_structure(data["resource"], data["grid_index"], data["grid_size"])
