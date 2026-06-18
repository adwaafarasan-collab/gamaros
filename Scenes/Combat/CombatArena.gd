extends Node3D
# CombatArena.gd - Main combat scene controller

class_name CombatArena

@onready var hero: CombatHero = $Hero
@onready var enemy: NPCEnemy = $Enemy
@onready var combat_system = CombatSystem.new()

var is_combat_active: bool = false

func _ready() -> void:
	add_child(combat_system)
	
	# Connect signals
	combat_system.combat_started.connect(_on_combat_started)
	combat_system.combat_ended.connect(_on_combat_ended)
	combat_system.strategy_changed.connect(_on_strategy_changed)
	combat_system.dialogue_triggered.connect(_on_dialogue_triggered)
	
	# Setup combat environment
	_setup_arena()
	
	# Start combat
	combat_system.start_combat(hero, enemy)

func _setup_arena() -> void:
	print("[CombatArena] Setting up combat arena")
	
	# Add lighting
	var sun = DirectionalLight3D.new()
	sun.rotation.x = -PI / 4
	sun.energy_multiplier = 1.5
	add_child(sun)
	
	# Add camera
	var camera = Camera3D.new()
	camera.position = Vector3(0, 3, 8)
	camera.look_at(Vector3(0, 1, 0), Vector3.UP)
	add_child(camera)

func _on_combat_started(p_hero: CharacterBody3D, p_enemy: Node3D) -> void:
	is_combat_active = true
	hero.enter_combat(enemy)
	print("[CombatArena] Combat started between %s and %s" % [hero.name, enemy.npc_name])

func _on_combat_ended(result: String) -> void:
	is_combat_active = false
	hero.exit_combat()
	
	print("[CombatArena] Combat ended: %s" % result)
	
	# Wait for dialogue to finish
	await get_tree().create_timer(2.0).timeout
	
	# Return to level
	get_tree().change_scene_to_file("res://Scenes/Levels/Level1.tscn")

func _on_strategy_changed(strategy: String) -> void:
	print("[CombatArena] Hero's strategy: %s" % strategy)

func _on_dialogue_triggered(speaker: String, text: String, language: String) -> void:
	print("[%s - %s] %s" % [speaker, language, text])
	# Here you would display dialogue on screen
