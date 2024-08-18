extends World

const COAL = preload("res://structures/natural/coal_deposit/coal_deposit.tscn")
const IRON = preload("res://structures/natural/iron_deposit/iron_deposit.tscn")
const COPPER = preload("res://structures/natural/copper_deposit/copper_deposit.tscn")
const BOULDER = preload("res://structures/natural/boulder/boulder.tscn")
const TREE = preload("res://structures/natural/tree/tree.tscn")

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

func _generate_structures():
	for data in STRUCTURE_DATA:	
		structure_manager.create_structure(data["resource"], data["grid_index"], data["grid_size"])
