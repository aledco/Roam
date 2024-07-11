extends Node

var timers = {}
var timer_callbacks = {}

## Starts the timer.
func _start_timer(time: float, timer: String):
	await get_tree().create_timer(time).timeout
	for callback in timer_callbacks[timer]:
		callback.call()
	_start_timer(time, timer)


## Calls the callback function every time seconds.
func interval(time: float, callback: Callable):
	if time in timers:
		var sig = timers[time]
		timer_callbacks[sig].append(callback)
	else:
		timers[time] = "timer_" + str(time)
		timer_callbacks[timers[time]] = [callback]
		_start_timer(time, timers[time])
	
