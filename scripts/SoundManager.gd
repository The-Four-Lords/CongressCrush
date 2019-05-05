extends Node

onready var music_player = $MusicPlayer
onready var sound_player = $SoundPlayer
onready var combo_sound_player = $ComboSoundPlayer

var possible_music = [
preload("res://art/Sound/Music/theme-1.ogg")
]

var possible_sounds = [

preload("res://art/Sound/Effects/Match1.wav"),
preload("res://art/Sound/Effects/Match2.wav"),
preload("res://art/Sound/Effects/Match3.wav"),
preload("res://art/Sound/Effects/Match4.wav"),
preload("res://art/Sound/Effects/Match5.wav"),
preload("res://art/Sound/Effects/Match6.wav"),
preload("res://art/Sound/Effects/Match7.wav")
]

var possible_combo_sound = [
preload("res://art/Sound/Effects/delisioso.ogg")
]

func _ready():
	randomize()
	play_random_music()

func play_random_music():
	if possible_music.size() > 0:
		var temp = floor(rand_range(0, possible_music.size()))
		music_player.stream = possible_music[temp]
		music_player.play()

func play_random_sound():
	if possible_sounds.size() > 0:
		var temp = floor(rand_range(0, possible_sounds.size()))
		sound_player.stream = possible_sounds[temp]
		sound_player.play()

func play_random_combo_sound():
	if possible_combo_sound.size() > 0:
		var temp = floor(rand_range(0, possible_combo_sound.size()))
		combo_sound_player.stream = possible_combo_sound[temp]
		combo_sound_player.play()

func play_fixed_sound(sound):
	if sound < possible_sounds.size():
		sound_player.stream = possible_sounds[sound]
		sound_player.play()

func disable_sounds(enable):
	if enable:
		music_player.play()
		sound_player.volume_db = -10
		combo_sound_player.volume_db = -5
	else:
		music_player.stop()
		sound_player.volume_db = -80
		combo_sound_player.volume_db = -80