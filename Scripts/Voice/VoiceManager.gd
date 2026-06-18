extends Node
# VoiceManager.gd - Handles all voice interaction
# Features: Speech recognition, voice commands, NPC responses

class_name VoiceManager

signal voice_recognized(text: String, confidence: float)
signal command_executed(command: String)
signal npc_speaking(npc_name: String, text: String, language: String)

enum Language { ARABIC, ENGLISH }

var is_listening: bool = false
var current_language: Language = Language.ARABIC
var recognized_commands: Dictionary = {}

func _ready() -> void:
	set_name("VoiceManager")
	add_to_group("voice")
	initialize_commands()
	print("[VoiceManager] Initialized")

func initialize_commands() -> void:
	# Arabic commands
	recognized_commands["هجوم"] = "attack"
	recognized_commands["دفاع"] = "defend"
	recognized_commands["تحرك"] = "move"
	recognized_commands["تحدث"] = "talk"
	recognized_commands["ساعدني"] = "help"
	recognized_commands["اركض"] = "run"
	
	# English commands
	recognized_commands["attack"] = "attack"
	recognized_commands["defend"] = "defend"
	recognized_commands["move"] = "move"
	recognized_commands["talk"] = "talk"
	recognized_commands["help"] = "help"
	recognized_commands["run"] = "run"

func start_listening() -> void:
	if not is_listening:
		is_listening = true
		print("[VoiceManager] Started listening in %s" % Language.keys()[current_language])

func stop_listening() -> void:
	if is_listening:
		is_listening = false
		print("[VoiceManager] Stopped listening")

func process_voice_input(voice_text: String, confidence: float) -> void:
	# Normalize and process voice input
	var normalized_text = voice_text.to_lower().strip_edges()
	print("[VoiceManager] Recognized: '%s' (Confidence: %.2f)" % [normalized_text, confidence])
	
	if confidence > 0.6:  # Confidence threshold
		emit_signal("voice_recognized", voice_text, confidence)
		execute_voice_command(normalized_text)
	else:
		print("[VoiceManager] Low confidence, ignoring")

func execute_voice_command(command: String) -> void:
	if command in recognized_commands:
		var action = recognized_commands[command]
		print("[VoiceManager] Executing command: %s" % action)
		emit_signal("command_executed", action)
	else:
		print("[VoiceManager] Unknown command: %s" % command)

func set_language(language: Language) -> void:
	current_language = language
	print("[VoiceManager] Language set to: %s" % Language.keys()[language])

func speak_npc_response(npc_name: String, text: String, language: Language = Language.ARABIC) -> void:
	# Queue NPC voice response (text-to-speech)
	print("[VoiceManager] NPC '%s' speaking: '%s'" % [npc_name, text])
	emit_signal("npc_speaking", npc_name, text, Language.keys()[language])

func get_voice_feedback() -> String:
	# Return voice UI feedback based on listening state
	if is_listening:
		return "🎤 Listening..."
	else:
		return "🔇 Not Listening"
