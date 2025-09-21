extends Node

enum StopwatchState {
	IDLE,
	ACTIVE,
	PAUSED,
}

var stopwatch_status: StopwatchState = StopwatchState.IDLE
