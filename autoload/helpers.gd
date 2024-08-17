extends Node

func valid(array: Array) -> Array:
	return array.filter(func(x): return is_instance_valid(x))

func remove(array: Array, item: Variant):
	var index = array.find(item)
	if index == -1:
		return
	array.remove_at(index)

func remove_and_free(array: Array, node: Node):
	remove(array, node)
	node.queue_free()

func contains_amount(array: Array, item: Variant, amount: int) -> bool:
	var count = 0
	for elem in array:
		if elem == item:
			count += 1
			if count > amount:
				return false
	return count == amount
