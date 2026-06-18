extends Node3D
# NPCBase.gd - Base class for all NPCs
# Handles: Dialogue, behavior, AI state machine

class_name NPCBase

enum NPCState { IDLE, TALKING, WALKING, ATTACKING }

@export var npc_name: String = "NPC"
@export var npc_type: String = "neutral"  # neutral, ally, enemy
@export var dialogue_language: String = "ar"  # ar, en

var current_state: NPCState = NPCState.IDLE
var dialogue_queue: Array = []
var is_talking: bool = false
var target_hero: Node3D = null

func _ready() -> void:
	print("[NPC] %s initialized (Type: %s)" % [npc_name, npc_type])

func set_dialogue(dialogue: Array) -> void:
	dialogue_queue = dialogue

func start_dialogue() -> void:
	if dialogue_queue.is_empty():
		return
	
	is_talking = true
	for line in dialogue_queue:
		print("[NPC %s] %s" % [npc_name, line])
		VoiceManager.speak_npc_response(npc_name, line)
		await get_tree().create_timer(2.0).timeout
	
	is_talking = false

func set_state(new_state: NPCState) -> void:
	current_state = new_state
	print("[NPC %s] State: %s" % [npc_name, NPCState.keys()[new_state]])

func interact_with_hero(hero: Node3D) -> void:
	target_hero = hero
	print("[NPC %s] Interacting with hero" % npc_name)
	start_dialogue()
