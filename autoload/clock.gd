extends Node

var timers = {}
var current_id := 0

func _start_timer(time: float, callback: Callable) -> Timer:
	var timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(callback)
	timer.start(time)
	return timer

func _callback_wrapper(callback: Callable):
	if not callback:
		return
	
	var object = callback.get_object()
	if not is_instance_valid(object):
		push_error("Invalid callback in timer, you probably forgot to remove the interval on object destruction")
		return
	
	callback.call()

func _invoke_callback_wrapper(callback: Callable, interval_id: int):
	_callback_wrapper(callback)
	remove_interval(interval_id)

## Calls the callback in an interval every time seconds.
func interval(time: float, callback: Callable) -> int:
	if not callback or not is_instance_valid(callback.get_object()):
		push_error("Invalid callback")
		return -1
	
	var interval_id = current_id
	var timer = _start_timer(time, _callback_wrapper.bind(callback))
	timers[interval_id] = timer
	current_id += 1
	return interval_id

## Invokes the callback once after time seconds.
func invoke(time: float, callback: Callable) -> int:
	if not callback or not is_instance_valid(callback.get_object()):
		push_error("Invalid callback")
		return -1
	
	var interval_id = current_id
	var timer = _start_timer(time, _invoke_callback_wrapper.bind(callback, interval_id))
	timers[interval_id] = timer
	current_id += 1
	return interval_id

## Removes the interval or invocation.
func remove_interval(interval_id: int):
	if interval_id not in timers:
		return
	
	var timer = timers[interval_id]
	timer.queue_free()
	timers.erase(interval_id)
