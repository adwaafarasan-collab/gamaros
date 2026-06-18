extends CharacterBody3D
# CombatHero.gd - Enhanced Hero for combat system
# Extends the base Hero with combat-specific features

class_name CombatHero

enum CombatState { IDLE, ATTACKING, DEFENDING, RETREATING, INJURED }

@export var attack_power: int = 20
@export var defense_power: int = 15
@export var critical_hit_chance: float = 0.25  # 25%
@export var dodge_chance: float = 0.15  # 15%

var combat_state: CombatState = CombatState.IDLE
var is_in_combat: bool = false
var active_strategy: String = "BALANCED"

func _ready() -> void:
	super()
	VoiceManager.command_executed.connect(_on_combat_voice_command)

func _on_combat_voice_command(command: String) -> void:
	if not is_in_combat:
		return
	
	match command:
		"هجوم", "attack":
			set_combat_strategy("AGGRESSIVE")
		"دفاع", "defend":
			set_combat_strategy("DEFENSIVE")
		"توازن", "balance":
			set_combat_strategy("BALANCED")
		"انسحاب", "retreat":
			set_combat_strategy("RETREAT")
		"تبديل", "switch":
			set_combat_strategy("SWITCH_PLAN")

func set_combat_strategy(strategy: String) -> void:
	active_strategy = strategy
	print("[CombatHero] Strategy changed to: %s" % strategy)

func perform_attack(target: Node3D, multiplier: float = 1.0) -> int:
	var base_damage = attack_power
	
	# Critical hit chance
	if randf() < critical_hit_chance:
		base_damage = int(base_damage * 1.5)
		print("[CombatHero] CRITICAL HIT! Damage: %d" % base_damage)
	
	return int(base_damage * multiplier)

func perform_defense() -> int:
	"""Return defense value"""
	return defense_power

func try_dodge() -> bool:
	"""Check if attack is dodged"""
	return randf() < dodge_chance

func enter_combat(enemy: NPCEnemy) -> void:
	is_in_combat = true
	combat_state = CombatState.IDLE
	print("[CombatHero] Entered combat with %s" % enemy.npc_name)

func exit_combat() -> void:
	is_in_combat = false
	combat_state = CombatState.IDLE
	active_strategy = "BALANCED"
	print("[CombatHero] Exited combat")
