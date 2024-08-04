extends Node

var connections := {}

func add_connection(input: Structure, output: Structure):
	if input in connections:
		connections[input].append(output)
	else:
		connections[input] = [output]


func remove_connection(input: Structure, output: Structure):
	Helpers.remove(connections[input], output)
	if connections[input].is_empty():
		connections.erase(input)


func connected(input: Structure, output: Structure) -> bool:
	if input not in connections:
		return false
	
	return output in connections[input]
