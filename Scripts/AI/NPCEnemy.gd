extends Node3D
# NPCEnemy.gd - Enemy NPC with AI combat strategy

class_name NPCEnemy

enum EnemyAIType { AGGRESSIVE, DEFENSIVE, INTELLIGENT, COWARDLY }
enum EnemyStrategy { ATTACK_WEAK, DEFEND, HEAL_SELF, ATTACK_STRONG, RETREAT }

@export var npc_name: String = "Enemy"
@export var enemy_health: int = 100
@export var max_health: int = 100
@export var ai_type: EnemyAIType = EnemyAIType.INTELLIGENT
@export var attack_power: int = 15
@export var defense_power: int = 10

var current_strategy: EnemyStrategy = EnemyStrategy.DEFEND
var is_in_combat: bool = false
var health_percentage: float = 1.0

func _ready() -> void:
	print("[NPCEnemy] %s initialized (AI: %s)" % [npc_name, EnemyAIType.keys()[ai_type]])

func take_damage(damage: int) -> void:
	enemy_health = max(0, enemy_health - damage)
	health_percentage = float(enemy_health) / float(max_health)
	print("[Enemy %s] Took %d damage. Health: %d/%d (%.1f%%)" % [npc_name, damage, enemy_health, max_health, health_percentage * 100])

func heal(amount: int) -> void:
	enemy_health = min(max_health, enemy_health + amount)
	health_percentage = float(enemy_health) / float(max_health)
	print("[Enemy %s] Healed %d. Health: %d/%d" % [npc_name, amount, enemy_health, max_health])

func decide_strategy(hero_health: int, enemy_health: int) -> String:
	"""AI decision-making based on current combat state"""
	match ai_type:
		EnemyAIType.AGGRESSIVE:
			return _ai_aggressive(hero_health, enemy_health)
		EnemyAIType.DEFENSIVE:
			return _ai_defensive(hero_health, enemy_health)
		EnemyAIType.INTELLIGENT:
			return _ai_intelligent(hero_health, enemy_health)
		EnemyAIType.COWARDLY:
			return _ai_cowardly(hero_health, enemy_health)
		_:
			return "DEFEND"

func _ai_aggressive(hero_health: int, enemy_health: int) -> String:
	"""Always attack, never retreat"""
	if enemy_health < 30:
		current_strategy = EnemyStrategy.ATTACK_STRONG
		return "ATTACK_STRONG"
	else:
		current_strategy = EnemyStrategy.ATTACK_WEAK
		return "ATTACK_WEAK"

func _ai_defensive(hero_health: int, enemy_health: int) -> String:
	"""Prefer defense and healing"""
	if enemy_health < 40:
		current_strategy = EnemyStrategy.HEAL_SELF
		return "HEAL_SELF"
	else:
		current_strategy = EnemyStrategy.DEFEND
		return "DEFEND"

func _ai_intelligent(hero_health: int, enemy_health: int) -> String:
	"""Adaptive strategy based on situation"""
	var hero_ratio = float(hero_health) / 100.0
	var enemy_ratio = float(enemy_health) / 100.0
	
	# If hero is weak, attack hard
	if hero_ratio < 0.3 and enemy_ratio > 0.5:
		current_strategy = EnemyStrategy.ATTACK_STRONG
		return "ATTACK_STRONG"
	# If we're weak, heal or defend
	elif enemy_ratio < 0.3:
		if randi_range(0, 100) < 60:
			current_strategy = EnemyStrategy.HEAL_SELF
			return "HEAL_SELF"
		else:
			current_strategy = EnemyStrategy.DEFEND
			return "DEFEND"
	# Balanced approach
	else:
		var choice = randi_range(0, 100)
		if choice < 40:
			current_strategy = EnemyStrategy.ATTACK_WEAK
			return "ATTACK_WEAK"
		elif choice < 70:
			current_strategy = EnemyStrategy.DEFEND
			return "DEFEND"
		else:
			current_strategy = EnemyStrategy.ATTACK_STRONG
			return "ATTACK_STRONG"

func _ai_cowardly(hero_health: int, enemy_health: int) -> String:
	"""Tries to retreat when losing"""
	var enemy_ratio = float(enemy_health) / 100.0
	
	if enemy_ratio < 0.5:
		current_strategy = EnemyStrategy.RETREAT
		return "RETREAT"
	else:
		current_strategy = EnemyStrategy.DEFEND
		return "DEFEND"

func get_combat_stats() -> Dictionary:
	"""Return current combat statistics"""
	return {
		"health": enemy_health,
		"max_health": max_health,
		"health_percentage": health_percentage,
		"attack_power": attack_power,
		"defense_power": defense_power,
		"strategy": EnemyStrategy.keys()[current_strategy]
	}
