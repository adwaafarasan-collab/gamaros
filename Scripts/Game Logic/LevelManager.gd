extends Node
# LevelManager.gd - Manages level progression and objectives

class_name LevelManager

signal level_objective_completed(objective: String)
signal all_objectives_completed

var current_objectives: Array = []
var completed_objectives: Array = []
var level_time_remaining: float = 0.0

func _ready() -> void:
	print("[LevelManager] Initialized")

func add_objective(objective: String) -> void:
	current_objectives.append(objective)
	print("[LevelManager] Objective added: %s" % objective)

func complete_objective(objective: String) -> void:
	if objective in current_objectives:
		current_objectives.erase(objective)
		completed_objectives.append(objective)
		emit_signal("level_objective_completed", objective)
		print("[LevelManager] Objective completed: %s" % objective)
		
		if current_objectives.is_empty():
			emit_signal("all_objectives_completed")
			print("[LevelManager] All objectives completed!")

func get_progress() -> float:
	var total = completed_objectives.size() + current_objectives.size()
	if total == 0:
		return 0.0
	return float(completed_objectives.size()) / float(total) * 100.0
