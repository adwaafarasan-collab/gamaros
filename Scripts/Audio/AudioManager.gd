extends Node
# AudioManager.gd - Central audio and sound management

class_name AudioManager

signal music_changed(track_name: String)
signal sound_played(sound_name: String)

enum MusicTrack { MENU, PROLOGUE, CHAPTER_1, CHAPTER_2, CHAPTER_3, COMBAT, VICTORY, DEFEAT }
enum SoundEffect { ATTACK, HIT, HEAL, DEFENSE, LEVEL_UP, VICTORY_SFX, DEFEAT_SFX, UI_CLICK }

var current_music: AudioStreamPlayer = null
var sfx_players: Dictionary = {}
var is_music_playing: bool = false
var current_music_track: MusicTrack = MusicTrack.MENU

func _ready() -> void:
	set_name("AudioManager")
	print("[AudioManager] Initialized")
	_initialize_audio_players()

func _initialize_audio_players() -> void:
	"""Create audio stream players for sound effects"""
	for i in range(8):
		var player = AudioStreamPlayer.new()
		add_child(player)
		sfx_players["sfx_%d" % i] = player

func play_music(track: MusicTrack, fade_in: float = 1.0) -> void:
	"""Play background music"""
	if current_music_track == track and is_music_playing:
		return
	
	current_music_track = track
	var track_name = MusicTrack.keys()[track]
	print("[AudioManager] Playing music: %s" % track_name)
	
	if current_music == null:
		current_music = AudioStreamPlayer.new()
		add_child(current_music)
	
	current_music.play()
	is_music_playing = true
	emit_signal("music_changed", track_name)

func stop_music(fade_out: float = 1.0) -> void:
	"""Stop background music"""
	if current_music:
		current_music.stop()
		is_music_playing = false
		print("[AudioManager] Music stopped")

func play_sound_effect(effect: SoundEffect) -> void:
	"""Play sound effect"""
	var effect_name = SoundEffect.keys()[effect]
	print("[AudioManager] Playing SFX: %s" % effect_name)

func play_voice_line(character_name: String, line_id: String, language: String = "ar") -> void:
	"""Play voice line for NPC dialogue"""
	print("[AudioManager] Playing voice: %s - %s (%s)" % [character_name, line_id, language])

func set_music_volume(volume: float) -> void:
	"""Set music volume (0.0 to 1.0)"""
	if current_music:
		current_music.volume_db = linear2db(volume)

func set_sfx_volume(volume: float) -> void:
	"""Set sound effects volume (0.0 to 1.0)"""
	for player in sfx_players.values():
		player.volume_db = linear2db(volume)
