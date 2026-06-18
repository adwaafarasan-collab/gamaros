extends Node3D
# Level1.gd - First tutorial level controller

class_name Level1

@onready var level_manager = LevelManager.new()
@onready var hero: Hero = $Hero
@onready var npc_guide: NPCBase = $NPCGuide

var level_started: bool = false

func _ready() -> void:
	print("[Level1] Scene loaded")
	add_child(level_manager)
	
	# Setup level objectives
	level_manager.add_objective("meet_npc")
	level_manager.add_objective("learn_voice_commands")
	level_manager.add_objective("reach_checkpoint")
	
	# Connect signals
	level_manager.all_objectives_completed.connect(_on_all_objectives_completed)
	VoiceManager.command_executed.connect(_on_voice_command)
	
	# Initialize NPC with dialogue
	if npc_guide:
		npc_guide.set_dialogue([
			"مرحباً! أنا دليلك في هذه المغامرة",
			"لتبدأ اللعبة، استخدم الأوامر الصوتية",
			"جرب قول: هجوم، دفاع، أو تحرك!",
			"هل أنت مستعد؟"
		])
		NPC_guide.start_dialogue()
		level_manager.complete_objective("meet_npc")
	
	# Start game loop
	GameManager.current_state = GameManager.GameState.PLAYING
	_setup_level()

func _setup_level() -> void:
	# Initialize lighting
	var sun = DirectionalLight3D.new()
	sun.rotation.x = -PI / 4
	add_child(sun)
	
	# Setup camera
	var camera = Camera3D.new()
	camera.position = Vector3(0, 5, 10)
	camera.look_at(Vector3(0, 0, 0), Vector3.UP)
	add_child(camera)
	
	print("[Level1] Level setup complete")

func _on_voice_command(command: String) -> void:
	match command:
		"attack":
			level_manager.complete_objective("learn_voice_commands")
		"defend":
			level_manager.complete_objective("learn_voice_commands")
		"move":
			level_manager.complete_objective("reach_checkpoint")

func _on_all_objectives_completed() -> void:
	print("[Level1] Level completed!")
	print("Progress: %.0f%%" % level_manager.get_progress())
	GameManager.level_changed.emit(2)
	GameManager.load_level(2)
