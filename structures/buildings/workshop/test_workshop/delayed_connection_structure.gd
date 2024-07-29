class_name DelayedConnectionStructure extends MultiInputPathedStructure

func _get_connections() -> Array[Connection]:
	return []


func _setup_io():
	pass


func _ready():
	super._ready()
	connections = _get_connections()
	_setup_io()


func add_input_node(input: InputNode):
	inputs_node.add_child(input)
	inputs.append(input)


func add_output_node(output: OutputNode):
	outputs_node.add_child(output)
	output.append(output)
