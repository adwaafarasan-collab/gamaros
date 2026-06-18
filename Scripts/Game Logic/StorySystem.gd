extends Node
# StorySystem.gd - Central story and narrative management

class_name StorySystem

signal chapter_started(chapter: int)
signal chapter_ended(chapter: int)
signal cutscene_triggered(cutscene_id: String)
signal dialogue_triggered(speaker: String, text: String)
signal story_milestone_reached(milestone: String)

enum Chapter { PROLOGUE, CHAPTER_1, CHAPTER_2, CHAPTER_3, CHAPTER_4, CHAPTER_5, EPILOGUE }

var current_chapter: Chapter = Chapter.PROLOGUE
var current_level: int = 1
var story_progress: float = 0.0
var player_choices: Dictionary = {}
var unlocked_content: Array = []

func _ready() -> void:
	set_name("StorySystem")
	print("[StorySystem] Initialized")

func start_story() -> void:
	print("[StorySystem] Starting story...")
	_play_prologue_cutscene()

func _play_prologue_cutscene() -> void:
	"""Play the opening cutscene"""
	var prologue_ar = [
		"في عالم بعيد...",
		"ممالك مسحورة مليئة بالموسيقى والسحر...",
		"ولكن ظلام مظلم يهدد بالنهاية",
		"الملك من الوضع راغما...",
		"لعل هناك بطل بلا لون يمكن أن ينقذ ملكنا..."
	]
	
	var prologue_en = [
		"In a distant world...",
		"A magical kingdom filled with music and enchantment...",
		"But a dark sorcerer threatens its end",
		"The kingdom is in danger...",
		"Perhaps there is a hero without a name who can save us..."
	]
	
	var language = LocalizationManager.Language.ARABIC if LocalizationManager.current_language == LocalizationManager.Language.ARABIC else LocalizationManager.Language.ENGLISH
	var prologue = prologue_ar if language == LocalizationManager.Language.ARABIC else prologue_en
	
	for line in prologue:
		print("[Prologue] %s" % line)
		emit_signal("dialogue_triggered", "Narrator", line)
		await get_tree().create_timer(2.5).timeout
	
	current_chapter = Chapter.CHAPTER_1
	emit_signal("chapter_started", current_chapter)

func load_level(level: int) -> void:
	current_level = level
	story_progress = (float(level) / 7.0) * 100.0
	
	match level:
		1:
			current_chapter = Chapter.CHAPTER_1
			print("[Story] Loading Chapter 1")
		2:
			current_chapter = Chapter.CHAPTER_1
			print("[Story] Loading Chapter 1 Part 2")
		_:
			print("[Story] Loading Level %d" % level)

func mark_choice(choice_id: String, choice_value: String) -> void:
	player_choices[choice_id] = choice_value
	print("[StorySystem] Player choice marked: %s = %s" % [choice_id, choice_value])

func unlock_content(content_id: String) -> void:
	if not content_id in unlocked_content:
		unlocked_content.append(content_id)
		print("[StorySystem] Content unlocked: %s" % content_id)
		emit_signal("story_milestone_reached", content_id)

func get_story_progress() -> float:
	return story_progress
