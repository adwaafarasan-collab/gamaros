extends Node
# CombatSystem.gd - Strategic combat with dialogue

class_name CombatSystem

signal combat_started(hero: CharacterBody3D, enemy: Node3D)
signal combat_ended(victor: String)
signal strategy_changed(strategy: String)
signal dialogue_triggered(speaker: String, text: String, language: String)
signal combat_round_processed

enum CombatStrategy { AGGRESSIVE, DEFENSIVE, BALANCED, RETREAT, SWITCH_PLAN }
enum CombatPhase { PLANNING, EXECUTING, ENEMY_TURN, ROUND_END, VICTORY, DEFEAT }

var is_combat_active: bool = false
var current_phase: CombatPhase = CombatPhase.PLANNING
var current_strategy: CombatStrategy = CombatStrategy.BALANCED
var next_strategy_pending: CombatStrategy = CombatStrategy.BALANCED
var round_count: int = 0
var max_rounds: int = 20

var hero: Hero
var enemy: NPCEnemy
var hero_damage_this_round: int = 0
var enemy_damage_this_round: int = 0

func _ready() -> void:
	set_name("CombatSystem")
	print("[CombatSystem] Initialized")

func start_combat(p_hero: Hero, p_enemy: NPCEnemy) -> void:
	if is_combat_active:
		return
	
	hero = p_hero
	enemy = p_enemy
	is_combat_active = true
	round_count = 0
	current_phase = CombatPhase.PLANNING
	current_strategy = CombatStrategy.BALANCED
	
	print("[CombatSystem] Combat started: %s vs %s" % [hero.name, enemy.npc_name])
	emit_signal("combat_started", hero, enemy)
	
	# Trigger opening dialogue
	_trigger_combat_dialogue("combat_start")
	
	# Start first round
	await get_tree().create_timer(2.0).timeout
	_start_round()

func _start_round() -> void:
	if not is_combat_active:
		return
	
	round_count += 1
	if round_count > max_rounds:
		# Combat draw after max rounds
		end_combat("draw")
		return
	
	current_phase = CombatPhase.PLANNING
	hero_damage_this_round = 0
	enemy_damage_this_round = 0
	
	print("\n[CombatSystem] === ROUND %d ==="  % round_count)
	print("[Hero] Health: %d" % hero.current_health)
	print("[Enemy] Health: %d" % enemy.enemy_health)
	
	# Ask for strategy via dialogue
	_request_strategy_selection()

func _request_strategy_selection() -> void:
	# Show dialogue options for strategy
	var strategies_ar = [
		"هجوم شرس 🔥",
		"دفاع قوي 🛡️",
		"توازن 🎯",
		"انسحاب تكتيكي 🏃",
		"تبديل الخطة 🔄"
	]
	
	var strategies_en = [
		"Aggressive Attack 🔥",
		"Strong Defense 🛡️",
		"Balanced Approach 🎯",
		"Tactical Retreat 🏃",
		"Switch Strategy 🔄"
	]
	
	var language = LocalizationManager.Language.ARABIC if LocalizationManager.current_language == LocalizationManager.Language.ARABIC else LocalizationManager.Language.ENGLISH
	var strategies = strategies_ar if language == LocalizationManager.Language.ARABIC else strategies_en
	
	_trigger_combat_dialogue("strategy_request", strategies)
	
	# Wait for voice command
	await get_tree().create_timer(3.0).timeout
	_execute_strategy()

func _execute_strategy() -> void:
	current_phase = CombatPhase.EXECUTING
	
	var strategy_name = CombatStrategy.keys()[current_strategy]
	print("[CombatSystem] Executing strategy: %s" % strategy_name)
	
	match current_strategy:
		CombatStrategy.AGGRESSIVE:
			_execute_aggressive_strategy()
		CombatStrategy.DEFENSIVE:
			_execute_defensive_strategy()
		CombatStrategy.BALANCED:
			_execute_balanced_strategy()
		CombatStrategy.RETREAT:
			_execute_retreat_strategy()
		CombatStrategy.SWITCH_PLAN:
			_execute_switch_strategy()
	
	emit_signal("strategy_changed", strategy_name)
	
	await get_tree().create_timer(1.5).timeout
	_enemy_turn()

func _execute_aggressive_strategy() -> void:
	print("[Hero] Executing AGGRESSIVE attack!")
	_trigger_combat_dialogue("strategy_aggressive")
	
	# High damage, low defense
	hero_damage_this_round = randi_range(25, 40)
	var defense_bonus = 0.5
	
	enemy_damage_this_round = randi_range(15, 30)
	enemy_damage_this_round = int(enemy_damage_this_round * defense_bonus)
	
	hero.take_damage(enemy_damage_this_round)

enemy.take_damage(hero_damage_this_round)

func _execute_defensive_strategy() -> void:
	print("[Hero] Executing DEFENSIVE stance!")
	_trigger_combat_dialogue("strategy_defensive")
	
	# Low damage, high defense
	hero_damage_this_round = randi_range(8, 15)
	var defense_bonus = 0.3
	
	enemy_damage_this_round = randi_range(20, 35)
	enemy_damage_this_round = int(enemy_damage_this_round * defense_bonus)
	
	hero.take_damage(enemy_damage_this_round)
	enemy.take_damage(hero_damage_this_round)

func _execute_balanced_strategy() -> void:
	print("[Hero] Executing BALANCED approach!")
	_trigger_combat_dialogue("strategy_balanced")
	
	# Medium damage, medium defense
	hero_damage_this_round = randi_range(15, 25)
	var defense_bonus = 0.65
	
	enemy_damage_this_round = randi_range(15, 28)
	enemy_damage_this_round = int(enemy_damage_this_round * defense_bonus)
	
	hero.take_damage(enemy_damage_this_round)
	enemy.take_damage(hero_damage_this_round)

func _execute_retreat_strategy() -> void:
	print("[Hero] Attempting tactical RETREAT!")
	_trigger_combat_dialogue("strategy_retreat")
	
	var retreat_chance = 70  # 70% success rate
	if randi_range(0, 100) < retreat_chance:
		print("[Hero] Successfully retreated!")
		end_combat("retreat")
	else:
		print("[Hero] Retreat failed! Taking increased damage!")
		# Failed retreat - take more damage
		enemy_damage_this_round = randi_range(30, 45)
		hero.take_damage(enemy_damage_this_round)

func _execute_switch_strategy() -> void:
	print("[Hero] Switching to next strategy...")
	_trigger_combat_dialogue("strategy_switch")
	
	# Apply next strategy's effects but with reduced efficiency
	if next_strategy_pending != CombatStrategy.SWITCH_PLAN:
		current_strategy = next_strategy_pending
		print("[Hero] Strategy switched to: %s" % CombatStrategy.keys()[current_strategy])
		# Reduced damage due to switching
		hero_damage_this_round = randi_range(10, 18)
		enemy_damage_this_round = randi_range(18, 32)
		hero.take_damage(enemy_damage_this_round)
		enemy.take_damage(hero_damage_this_round)

func _enemy_turn() -> void:
	current_phase = CombatPhase.ENEMY_TURN
	
	print("\n[Enemy] Executing AI strategy...")
	_trigger_combat_dialogue("enemy_turn")
	
	# AI decides strategy based on current situation
	var ai_strategy = enemy.decide_strategy(hero.current_health, enemy.enemy_health)
	print("[Enemy] Using strategy: %s" % ai_strategy)
	
	await get_tree().create_timer(1.0).timeout
	_end_round()

func _end_round() -> void:
	current_phase = CombatPhase.ROUND_END
	
	print("\n[CombatSystem] Round %d Summary:" % round_count)
	print("  Hero dealt: %d damage" % hero_damage_this_round)
	print("  Enemy dealt: %d damage" % enemy_damage_this_round)
	print("  Hero Health: %d" % hero.current_health)
	print("  Enemy Health: %d" % enemy.enemy_health)
	
	emit_signal("combat_round_processed")
	
	# Check for victory/defeat
	if hero.current_health <= 0:
		end_combat("defeat")
	elif enemy.enemy_health <= 0:
		end_combat("victory")
	else:
		# Continue to next round
		await get_tree().create_timer(2.0).timeout
		_start_round()

func end_combat(result: String) -> void:
	if not is_combat_active:
		return
	
	is_combat_active = false
	
	match result:
		"victory":
			current_phase = CombatPhase.VICTORY
			print("\n🏆 [CombatSystem] VICTORY! Defeated the enemy!")
			_trigger_combat_dialogue("victory")
			# Award experience/points
			GameManager.player_score += 500
		"defeat":
			current_phase = CombatPhase.DEFEAT
			print("\n💀 [CombatSystem] DEFEAT! Captured!")
			_trigger_combat_dialogue("defeat")
			GameManager.hero_get_captured()
		"retreat":
			print("\n🏃 [CombatSystem] Tactical retreat successful!")
			_trigger_combat_dialogue("retreat_success")
			GameManager.player_score += 100
		"draw":
			print("\n⚖️ [CombatSystem] Combat draw after %d rounds" % max_rounds)
			_trigger_combat_dialogue("draw")
	
	emit_signal("combat_ended", result)

func set_strategy(strategy: CombatStrategy) -> void:
	"""Called when voice command is recognized"""
	if current_phase == CombatPhase.PLANNING:
		current_strategy = strategy
		print("[CombatSystem] Strategy set to: %s" % CombatStrategy.keys()[strategy])

func set_next_strategy(strategy: CombatStrategy) -> void:
	"""Set strategy for next switch"""
	next_strategy_pending = strategy

func _trigger_combat_dialogue(dialogue_key: String, options: Array = []) -> void:
	"""Trigger combat-related dialogue"""
	var dialogues = {
		"combat_start": {
			ar: "قد بدأت المعركة! اختر استراتيجيتك بحكمة!",
			en: "Combat has started! Choose your strategy wisely!"
		},
		"strategy_request": {
			ar: "ماذا ستفعل؟ اختر من الخيارات:",
			en: "What will you do? Choose from the options:"
		},
		"strategy_aggressive": {
			ar: "هجوم شرس! 🔥",
			en: "Aggressive Attack! 🔥"
		},
		"strategy_defensive": {
			ar: "دفاع قوي! 🛡️",
			en: "Strong Defense! 🛡️"
		},
		"strategy_balanced": {
			ar: "توازن مثالي! 🎯",
			en: "Perfect Balance! 🎯"
		},
		"strategy_retreat": {
			ar: "انسحاب تكتيكي! 🏃",
			en: "Tactical Retreat! 🏃"
		},
		"strategy_switch": {
			ar: "تبديل الخطة! 🔄",
			en: "Switching Strategy! 🔄"
		},
		"enemy_turn": {
			ar: "دور الخصم...",
			en: "Enemy's turn..."
		},
		"victory": {
			ar: "لقد انتصرت! أنت البطل الحقيقي! 🏆",
			en: "Victory! You are the true hero! 🏆"
		},
		"defeat": {
			ar: "تم القبض عليك! لكنك لن تستسلمي... 💪",
			en: "You've been captured! But you won't give up... 💪"
		},
		"retreat_success": {
			ar: "نجحت في الانسحاب! الحكمة هي أفضل من الشجاعة أحياناً! 🧠",
			en: "Retreat successful! Wisdom is sometimes better than courage! 🧠"
		},
		"draw": {
			ar: "تعادل! كلاكما قويان جداً! ⚖️",
			en: "Draw! You both are very strong! ⚖️"
		}
	}
	
	if dialogue_key in dialogues:
		var language = "ar" if LocalizationManager.current_language == LocalizationManager.Language.ARABIC else "en"
		var text = dialogues[dialogue_key][language]
		print("[Combat Dialogue] %s" % text)
		emit_signal("dialogue_triggered", "Combat", text, language)

