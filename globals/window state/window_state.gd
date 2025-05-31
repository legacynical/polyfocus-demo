extends Control

signal window_restored

var window_state_prev: int = 0 # app starts in windowed mode
var poll_interval: float = 0.25 # 250ms, 4 poll/sec
var _running := true

# DisplayServer.window_get_mode() return values
const WINDOWED: int = 0
const MINIMIZED: int = 1
#const MAXIMIZED: int = 2
#const FULLSCREEN: int = 3

#region Custom Poll Loop
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
	check_window_state() # polled function 
	_poll_loop()
#endregion

func check_window_state() -> void:
	var window_state_current: int = DisplayServer.window_get_mode()
	if window_state_prev == MINIMIZED and window_state_current != MINIMIZED:
		emit_signal("window_restored")
	window_state_prev = window_state_current
