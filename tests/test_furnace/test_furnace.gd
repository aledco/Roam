extends Node2D

@onready var structure_manager: StructureManager = $StructureManager

const COAL = preload("res://structures/natural/coal_deposit/coal_deposit.tscn")
const IRON = preload("res://structures/natural/iron_deposit/iron_deposit.tscn")
const COPPER = preload("res://structures/natural/copper_deposit/copper_deposit.tscn")
const BOULDER = preload("res://structures/natural/boulder/boulder.tscn")

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
		"resource": COPPER,
		"grid_index": Vector2i(2, -3),
		"grid_size": CopperDeposit.GRID_SIZE
	},
	{
		"resource": COAL,
		"grid_index": Vector2i(3, -3),
		"grid_size": CoalDeposit.GRID_SIZE
	},
	{
		"resource": BOULDER,
		"grid_index": Vector2i(4, -3),
		"grid_size": BoulderStructure.GRID_SIZE
	}
]

func _ready():
	for data in STRUCTURE_DATA:	
		structure_manager.create_structure(data["resource"], data["grid_index"], data["grid_size"])
