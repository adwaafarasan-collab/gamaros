extends Control
# DifficultySelectionController.gd - Difficulty level selection UI

func _ready() -> void:
	$CanvasLayer/VBoxContainer/MarginContainer/VBoxContainer2/EasyButton.pressed.connect(_on_easy_pressed)
	$CanvasLayer/VBoxContainer/MarginContainer/VBoxContainer2/NormalButton.pressed.connect(_on_normal_pressed)
	$CanvasLayer/VBoxContainer/MarginContainer/VBoxContainer2/HardButton.pressed.connect(_on_hard_pressed)
	$CanvasLayer/VBoxContainer/MarginContainer/VBoxContainer2/NightmareButton.pressed.connect(_on_nightmare_pressed)
	$CanvasLayer/VBoxContainer/BackButton.pressed.connect(_on_back_pressed)

func _on_easy_pressed() -> void:
	print("[DifficultySelection] Selected: Easy")
	GameManager.set_difficulty(GameManager.Difficulty.EASY)
	_start_game()

func _on_normal_pressed() -> void:
	print("[DifficultySelection] Selected: Normal")
	GameManager.set_difficulty(GameManager.Difficulty.NORMAL)
	_start_game()

func _on_hard_pressed() -> void:
	print("[DifficultySelection] Selected: Hard")
	GameManager.set_difficulty(GameManager.Difficulty.HARD)
	_start_game()

func _on_nightmare_pressed() -> void:
	print("[DifficultySelection] Selected: Nightmare")
	GameManager.set_difficulty(GameManager.Difficulty.NIGHTMARE)
	_start_game()

func _start_game() -> void:
	print("[DifficultySelection] Starting game...")
	GameManager.current_state = GameManager.GameState.PLAYING
	GameManager.load_level(1)

func _on_back_pressed() -> void:
	print("[DifficultySelection] Going back to age selection")
	get_tree().change_scene_to_file("res://Scenes/Setup/AgeSelection.tscn")
