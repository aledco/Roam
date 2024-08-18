extends Node

var timers = {}
var timer_callbacks = {}

## Starts the timer.
func _start_timer(time: float, timer: String):
	await get_tree().create_timer(time).timeout
	for callback in timer_callbacks[timer]:
		if callback:
			callback.call()
	_start_timer(time, timer)


## Calls the callback function every time seconds.
func interval(time: float, callback: Callable) -> int:
	if time in timers:
		var sig = timers[time]
		timer_callbacks[sig].append(callback)
		return len(timer_callbacks[sig]) - 1
	else:
		timers[time] = "timer_" + str(time)
		timer_callbacks[timers[time]] = [callback]
		_start_timer(time, timers[time])
		return 0


func remove_interval(time: float, index: int):
	var sig = timers[time]
	timer_callbacks[sig].remove_at(index)


## Invokes the call back after time seconds.
func invoke(time: float, callback: Callable):
	await get_tree().create_timer(time).timeout
	if callback:
		callback.call()
