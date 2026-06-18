extends Control
# HUDManager.gd - Heads-up display management

class_name HUDManager

var health_label: Label
var story_label: Label
var score_label: Label

func _ready() -> void:
	set_name("HUDManager")
	_create_hud_elements()

func _create_hud_elements() -> void:
	"""Create all HUD elements"""
	print("[HUDManager] Creating HUD elements")
	
	health_label = Label.new()
	health_label.text = "Health: 100/100"
	health_label.position = Vector2(20, 20)
	add_child(health_label)
	
	story_label = Label.new()
	story_label.text = "Chapter 1"
	story_label.position = Vector2(200, 20)
	add_child(story_label)
	
	score_label = Label.new()
	score_label.text = "Score: 0"
	score_label.position = Vector2(400, 20)
	add_child(score_label)

func update_health(health: int, max_health: int) -> void:
	if health_label:
		health_label.text = "Health: %d/%d" % [health, max_health]

func update_score(score: int) -> void:
	if score_label:
		score_label.text = "Score: %d" % score
