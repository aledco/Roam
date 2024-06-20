extends Node

signal one_second_timer

func _ready():
	_start_timer(1, one_second_timer)


func _start_timer(time: float, sig: Signal):
	await get_tree().create_timer(time).timeout
	sig.emit()
	_start_timer(time, sig)
