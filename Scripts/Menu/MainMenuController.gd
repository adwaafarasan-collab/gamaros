extends Control
# MainMenuController.gd - Main menu UI logic

func _ready() -> void:
	$CanvasLayer/VBoxContainer/StartButton.pressed.connect(_on_start_pressed)
	$CanvasLayer/VBoxContainer/SettingsButton.pressed.connect(_on_settings_pressed)
	$CanvasLayer/VBoxContainer/QuitButton.pressed.connect(_on_quit_pressed)

func _on_start_pressed() -> void:
	print("[MainMenu] Starting game...")
	GameManager.start_game()
	get_tree().change_scene_to_file("res://Scenes/Setup/AgeSelection.tscn")

func _on_settings_pressed() -> void:
	print("[MainMenu] Opening settings...")

func _on_quit_pressed() -> void:
	print("[MainMenu] Quitting game")
	get_tree().quit()
