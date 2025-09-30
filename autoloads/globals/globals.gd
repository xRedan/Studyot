extends Node

enum StopwatchState {
	IDLE,
	ACTIVE,
	PAUSED,
}

var stopwatch_status: StopwatchState = StopwatchState.IDLE


func sec_to_string(_sec: int) -> String:
	var hour: int = (_sec / 60) / 60
	var minute: int = (_sec/60) % 60
	var rem_sec: int = _sec % 60
	return "%02d" % hour + ":" + "%02d" % minute + ":" + "%02d" % rem_sec
