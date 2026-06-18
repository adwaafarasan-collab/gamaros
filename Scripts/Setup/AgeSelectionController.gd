extends Control
# AgeSelectionController.gd - Age group selection UI

func _ready() -> void:
	$CanvasLayer/VBoxContainer/MarginContainer/GridContainer/Age1Button.pressed.connect(_on_age_1_pressed)
	$CanvasLayer/VBoxContainer/MarginContainer/GridContainer/Age2Button.pressed.connect(_on_age_2_pressed)
	$CanvasLayer/VBoxContainer/MarginContainer/GridContainer/Age3Button.pressed.connect(_on_age_3_pressed)
	$CanvasLayer/VBoxContainer/MarginContainer/GridContainer/Age4Button.pressed.connect(_on_age_4_pressed)
	$CanvasLayer/VBoxContainer/BackButton.pressed.connect(_on_back_pressed)

func _on_age_1_pressed() -> void:
	print("[AgeSelection] Selected: 3-6 years")
	GameManager.set_age_group(GameManager.AgeGroup.CHILD_3_6)
	_proceed_to_difficulty()

func _on_age_2_pressed() -> void:
	print("[AgeSelection] Selected: 7-12 years")
	GameManager.set_age_group(GameManager.AgeGroup.CHILD_7_12)
	_proceed_to_difficulty()

func _on_age_3_pressed() -> void:
	print("[AgeSelection] Selected: 13-17 years")
	GameManager.set_age_group(GameManager.AgeGroup.TEEN_13_17)
	_proceed_to_difficulty()

func _on_age_4_pressed() -> void:
	print("[AgeSelection] Selected: 18+ years")
	GameManager.set_age_group(GameManager.AgeGroup.ADULT)
	_proceed_to_difficulty()

func _proceed_to_difficulty() -> void:
	get_tree().change_scene_to_file("res://Scenes/Setup/DifficultySelection.tscn")

func _on_back_pressed() -> void:
	print("[AgeSelection] Going back to main menu")
	get_tree().change_scene_to_file("res://Scenes/Menu/MainMenu.tscn")
