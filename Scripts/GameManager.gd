extends Node
# GameManager.gd - Central game management singleton
# Handles: Game state, transitions, difficulty, age customization

class_name GameManager

signal game_started
signal game_paused
signal game_resumed
signal level_changed(level: int)
signal hero_injured(damage: int)
signal hero_captured
signal game_over

enum GameState { MENU, LOADING, PLAYING, PAUSED, GAME_OVER }
enum AgeGroup { CHILD_3_6, CHILD_7_12, TEEN_13_17, ADULT }
enum Difficulty { EASY, NORMAL, HARD, NIGHTMARE }

var current_state: GameState = GameState.MENU
var current_level: int = 1
var player_age_group: AgeGroup = AgeGroup.CHILD_7_12
var current_difficulty: Difficulty = Difficulty.NORMAL
var player_score: int = 0
var player_health: int = 100
var is_voice_active: bool = true

func _ready() -> void:
	set_name("GameManager")
	add_to_group("persistent")
	print("[GameManager] Initialized")

func start_game() -> void:
	current_state = GameState.LOADING
	print("[GameManager] Starting game...")
	emit_signal("game_started")

func pause_game() -> void:
	if current_state == GameState.PLAYING:
		current_state = GameState.PAUSED
		get_tree().paused = true
		emit_signal("game_paused")

func resume_game() -> void:
	if current_state == GameState.PAUSED:
		current_state = GameState.PLAYING
		get_tree().paused = false
		emit_signal("game_resumed")

func load_level(level: int) -> void:
	current_level = level
	var level_path = "res://Scenes/Levels/Level%d.tscn" % level
	print("[GameManager] Loading level: %s" % level_path)
	emit_signal("level_changed", level)
	get_tree().change_scene_to_file(level_path)

func set_age_group(age: AgeGroup) -> void:
	player_age_group = age
	print("[GameManager] Age group set to: %s" % AgeGroup.keys()[age])

func set_difficulty(difficulty: Difficulty) -> void:
	current_difficulty = difficulty
	print("[GameManager] Difficulty set to: %s" % Difficulty.keys()[difficulty])

func apply_damage(damage: int) -> void:
	player_health = max(0, player_health - damage)
	emit_signal("hero_injured", damage)
	if player_health <= 0:
		end_game()

func hero_get_captured() -> void:
	emit_signal("hero_captured")
	print("[GameManager] Hero captured! (But never defeated!)")

func end_game() -> void:
	current_state = GameState.GAME_OVER
	emit_signal("game_over")
	print("[GameManager] Game Over! Final Score: %d" % player_score)

func get_content_for_age(content_type: String) -> Dictionary:
	# Returns age-appropriate content based on player age group
	var content = {}
	match player_age_group:
		AgeGroup.CHILD_3_6:
			content["difficulty_multiplier"] = 0.5
			content["time_limit_seconds"] = 300
			content["vocabulary_level"] = "simple"
		AgeGroup.CHILD_7_12:
			content["difficulty_multiplier"] = 0.75
			content["time_limit_seconds"] = 180
			content["vocabulary_level"] = "intermediate"
		AgeGroup.TEEN_13_17:
			content["difficulty_multiplier"] = 1.0
			content["time_limit_seconds"] = 120
			content["vocabulary_level"] = "advanced"
		AgeGroup.ADULT:
			content["difficulty_multiplier"] = 1.2
			content["time_limit_seconds"] = 90
			content["vocabulary_level"] = "expert"
	return content
