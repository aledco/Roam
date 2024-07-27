extends Node2D

@onready var structure_manager: StructureManager = $StructureManager

const COAL = preload("res://structures/coal_deposit/coal_deposit.tscn")
const IRON = preload("res://structures/iron_deposit/iron_deposit.tscn")
const COPPER = preload("res://structures/copper_deposit/copper_deposit.tscn")
const BOULDER = preload("res://structures/boulder/boulder.tscn")
const TREE = preload("res://structures/tree/tree.tscn")

var STRUCTURE_DATA = [
	{
		"resource": COAL,
		"grid_index": Vector2i(-1, -3),
		"grid_size": CoalDeposit.GRID_SIZE
	},
	{
		"resource": IRON,
		"grid_index": Vector2i(0, -3),
		"grid_size": IronDeposit.GRID_SIZE
	},
	{
		"resource": COAL,
		"grid_index": Vector2i(1, -3),
		"grid_size": CoalDeposit.GRID_SIZE
	},
	{
		"resource": IRON,
		"grid_index": Vector2i(2, -3),
		"grid_size": IronDeposit.GRID_SIZE
	},
	{
		"resource": COAL,
		"grid_index": Vector2i(3, -3),
		"grid_size": CoalDeposit.GRID_SIZE
	},
	{
		"resource": COPPER,
		"grid_index": Vector2i(4, -3),
		"grid_size": CopperDeposit.GRID_SIZE
	},
	{
		"resource": COAL,
		"grid_index": Vector2i(5, -3),
		"grid_size": CoalDeposit.GRID_SIZE
	},
	{
		"resource": IRON,
		"grid_index": Vector2i(6, -3),
		"grid_size": IronDeposit.GRID_SIZE
	},
	{
		"resource": COAL,
		"grid_index": Vector2i(7, -3),
		"grid_size": CoalDeposit.GRID_SIZE
	},
	{
		"resource": IRON,
		"grid_index": Vector2i(8, -3),
		"grid_size": IronDeposit.GRID_SIZE
	},
	{
		"resource": TREE,
		"grid_index": Vector2i(9, -3),
		"grid_size": TreeStructure.GRID_SIZE
	},
	{
		"resource": TREE,
		"grid_index": Vector2i(10, -3),
		"grid_size": TreeStructure.GRID_SIZE
	},
]

func _ready():
	for data in STRUCTURE_DATA:	
		structure_manager.create_structure(data["resource"], data["grid_index"], data["grid_size"])
