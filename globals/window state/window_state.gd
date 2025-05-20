extends Control

# NOTE: 

signal window_restored

var window_state_prev: int = 0
var poll_interval: float = 0.25 # 250ms, 4 poll/sec
var _running := true

func _ready() -> void:
	_start_polling()

func _start_polling() -> void:
	_running = true
	_poll_loop()

func stop_polling() -> void:
	_running = false

func _poll_loop() -> void:
	await get_tree().create_timer(poll_interval).timeout
	if not _running:
		return	
	check_window_state()
	_poll_loop()
		
func check_window_state() -> void:
	var minimized: int = DisplayServer.window_get_mode() == 1
	# 0 = windowed, 1 = minimized, 2 = maximized, 3 = fullscreen
	
	# if 1 -> 0 (minimized to not minimized)
	if window_state_prev == 1 and not minimized:
		emit_signal("window_restored")
	window_state_prev = minimized
