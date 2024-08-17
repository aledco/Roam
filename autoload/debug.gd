extends Node

const ENABLED := true
const DEBUG_GRID := false
const DEBUG_STRUCTURES := true

func debug_grid() -> bool:
	return ENABLED and DEBUG_GRID

func debug_structures() -> bool:
	return ENABLED and DEBUG_STRUCTURES
