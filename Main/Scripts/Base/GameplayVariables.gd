extends Node

var _start_timestamp = -1
var _pause_start_timestamps = []
var _pause_stop_timestamps = []
var _cutoff = false # if it's beyond limit of 10 s after a player wins

func start_game(timestamp):
	_start_timestamp = timestamp

func is_game_started():
	return _start_timestamp > 0

func pause_status(status):
	if _start_timestamp > 0:
		if status:
			_pause_start_timestamps.append(OS.get_ticks_msec())
		else:
			_pause_stop_timestamps.append(OS.get_ticks_msec())

func count_finish_time(timestamp_msec):
	if not is_game_started():
		return 0
	
	var result = 0
	var pause_durations = []

	for i in range(len(_pause_start_timestamps)):
		pause_durations.append(_pause_stop_timestamps[i] - _pause_start_timestamps[i])

	if len(_pause_start_timestamps) != 0:
		result = _pause_start_timestamps[0] - _start_timestamp
		result += timestamp_msec - _pause_stop_timestamps[-1]
		#print(timestamp_msec)
		#print(_start_timestamp)
		#print(result)
	else:
		result = timestamp_msec - _start_timestamp

	return result

func finished_waiting():
	_cutoff = true

func gameplay_is_cutted_off():
	return _cutoff

func reset_gameplay():
	_start_timestamp = -1
	_pause_start_timestamps = []
	_pause_stop_timestamps = []
	_cutoff = false # if it's beyond limit of 10 s after a player wins
	