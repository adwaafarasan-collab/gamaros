extends Control
# MobileInputHandler.gd - Touch controls and mobile optimization

class_name MobileInputHandler

signal touch_detected(position: Vector2)
signal swipe_detected(direction: Vector2)
signal tap_detected(position: Vector2)
signal long_press_detected(position: Vector2)

enum GestureType { TAP, SWIPE, LONG_PRESS, PINCH }

var touch_start_position: Vector2 = Vector2.ZERO
var touch_start_time: float = 0.0
var is_touching: bool = false
var swipe_threshold: float = 50.0
var long_press_threshold: float = 0.5

var mobile_buttons: Array = []

func _ready() -> void:
	set_name("MobileInputHandler")
	print("[MobileInputHandler] Initialized")
	
	if OS.get_name() in ["Android", "iOS"]:
		print("[MobileInputHandler] Mobile platform detected")
		_setup_mobile_ui()
		_setup_touch_input()

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			_on_touch_start(event.position)
		else:
			_on_touch_end(event.position)


func _on_touch_start(position: Vector2) -> void:
	is_touching = true
	touch_start_position = position
	touch_start_time = Time.get_ticks_msec() / 1000.0
	emit_signal("touch_detected", position)
	print("[MobileInputHandler] Touch started at: %v" % position)

func _on_touch_end(position: Vector2) -> void:
	if not is_touching:
		return
	
	is_touching = false
	var touch_duration = (Time.get_ticks_msec() / 1000.0) - touch_start_time
	var touch_distance = touch_start_position.distance_to(position)
	
	if touch_duration > long_press_threshold:
		emit_signal("long_press_detected", position)
		print("[MobileInputHandler] Long press detected")
	elif touch_distance > swipe_threshold:
		var swipe_direction = (position - touch_start_position).normalized()
		emit_signal("swipe_detected", swipe_direction)
		print("[MobileInputHandler] Swipe detected: %v" % swipe_direction)
	else:
		emit_signal("tap_detected", position)
		print("[MobileInputHandler] Tap detected at: %v" % position)

func _setup_touch_input() -> void:
	"""Configure touch input for mobile"""
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _setup_mobile_ui() -> void:
	"""Create mobile-optimized UI buttons"""
	print("[MobileInputHandler] Setting up mobile UI")

func get_ui_scale() -> float:
	"""Get appropriate UI scale for mobile device"""
	var screen_size = get_viewport().get_visible_rect().size
	if screen_size.y < 1080:
		return 0.8
	elif screen_size.y > 2160:
		return 1.5
	else:
		return 1.0
