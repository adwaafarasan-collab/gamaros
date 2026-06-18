extends CharacterBody3D
# Hero.gd - Main player character controller
# Handles: Movement, health, state, voice commands

class_name Hero

signal health_changed(new_health: int)
signal state_changed(new_state: String)
signal voice_command_received(command: String)

enum HeroState { IDLE, MOVING, ATTACKING, DEFENDING, INJURED, CAPTURED }

@export var max_health: int = 100
@export var movement_speed: float = 5.0
@export var jump_force: float = 5.0
@export var gravity: float = 9.8

var current_state: HeroState = HeroState.IDLE
var current_health: int = 100
var is_voice_controlled: bool = true
var velocity: Vector3 = Vector3.ZERO

func _ready() -> void:
	current_health = max_health
	print("[Hero] Initialized with %d health" % current_health)
	VoiceManager.command_executed.connect(_on_voice_command)

func _physics_process(delta: float) -> void:
	# Apply gravity
	velocity.y -= gravity * delta
	
	# Move character
	velocity = move_and_slide(velocity)

func take_damage(damage: int) -> void:
	current_health = max(0, current_health - damage)
	emit_signal("health_changed", current_health)
	set_state(HeroState.INJURED)
	print("[Hero] Took %d damage. Health: %d" % [damage, current_health])
	
	if current_health <= 0:
		GameManager.end_game()

func heal(amount: int) -> void:
	current_health = min(max_health, current_health + amount)
	emit_signal("health_changed", current_health)
	print("[Hero] Healed %d. Health: %d" % [amount, current_health])

func set_state(new_state: HeroState) -> void:
	if current_state != new_state:
		current_state = new_state
		emit_signal("state_changed", HeroState.keys()[new_state])

func _on_voice_command(command: String) -> void:
	if not is_voice_controlled:
		return
	
	match command:
		"attack":
			perform_attack()
		"defend":
			perform_defense()
		"move":
			set_state(HeroState.MOVING)
		"run":
			movement_speed = 10.0
		"jump":
			velocity.y = jump_force

func perform_attack() -> void:
	set_state(HeroState.ATTACKING)
	print("[Hero] Performing attack!")
	await get_tree().create_timer(0.5).timeout
	set_state(HeroState.IDLE)

func perform_defense() -> void:
	set_state(HeroState.DEFENDING)
	print("[Hero] Defending!")
	await get_tree().create_timer(1.0).timeout
	set_state(HeroState.IDLE)
