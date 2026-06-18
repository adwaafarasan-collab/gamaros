extends Node
# LocalizationManager.gd - Handles all text translations and localization
# Supports: Arabic, English with context-aware strings

class_name LocalizationManager

enum Language { ARABIC = 0, ENGLISH = 1 }

var current_language: Language = Language.ARABIC
var translations: Dictionary = {}

func _ready() -> void:
	set_name("LocalizationManager")
	add_to_group("localization")
	load_translations()
	print("[LocalizationManager] Initialized with %s" % Language.keys()[current_language])

func load_translations() -> void:
	# Load translation strings
	translations = {
		"start_game": ["ابدأ اللعبة", "Start Game"],
		"settings": ["الإعدادات", "Settings"],
		"quit": ["خروج", "Quit"],
		"welcome": ["مرحبا بك في جاماروس!", "Welcome to GAMAROS!"],
		"select_age": ["اختر عمرك", "Select Your Age"],
		"select_difficulty": ["اختر مستوى الصعوبة", "Select Difficulty"],
		"game_paused": ["اللعبة متوقفة", "Game Paused"],
		"resume": ["استئناف", "Resume"],
		"level_complete": ["تم إكمال المستوى!", "Level Complete!"],
		"hero_injured": ["تم إصابتك!", "You've Been Injured!"],
		"hero_captured": ["تم القبض عليك لكنك لن تُهزم!", "You've Been Captured But Never Defeated!"],
		"game_over": ["انتهت اللعبة", "Game Over"],
		"final_score": ["النتيجة النهائية: ", "Final Score: "],
	}

func set_language(language: Language) -> void:
	current_language = language
	print("[LocalizationManager] Language changed to: %s" % Language.keys()[language])

func get_text(key: String) -> String:
	if key in translations:
		return translations[key][current_language]
	else:
		push_warning("[LocalizationManager] Missing translation key: %s" % key)
		return key

func get_age_group_text(age_group: int) -> String:
	match age_group:
		0: return get_text("age_3_6") if "age_3_6" in translations else ("3-6 سنوات" if current_language == Language.ARABIC else "3-6 Years")
		1: return get_text("age_7_12") if "age_7_12" in translations else ("7-12 سنة" if current_language == Language.ARABIC else "7-12 Years")
		2: return get_text("age_13_17") if "age_13_17" in translations else ("13-17 سنة" if current_language == Language.ARABIC else "13-17 Years")
		3: return get_text("age_18_plus") if "age_18_plus" in translations else ("18+" if current_language == Language.ARABIC else "18+")
		_: return "Unknown"
