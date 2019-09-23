extends Node

onready var music_player = $MusicPlayer
onready var sound_player = $SoundPlayer
onready var combo_sound_player = $ComboSoundPlayer
onready var win_player = $WinPlayer

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

var win_sounds = {
"blue" : preload("res://art/Sound/Music/WIN/blue.ogg"),
"red" : preload("res://art/Sound/Music/WIN/red.ogg"),
"green" : preload("res://art/Sound/Music/WIN/green.ogg"),
"orange" : preload("res://art/Sound/Music/WIN/orange.ogg"),
"purple" : preload("res://art/Sound/Music/WIN/purple.ogg"),
"yellow" : preload("res://art/Sound/Music/WIN/yellow.ogg"),
"lose" : preload("res://art/Sound/Music/WIN/lose.ogg"),
"draw" : preload("res://art/Sound/Music/WIN/draw.ogg")
}

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

func play_win_music(win_color):
	win_player.stream = win_sounds[win_color]
	win_player.play()

func stop_music_player():
	music_player.stop()

func disable_sounds(enable):
	if enable:
		music_player.play()
		sound_player.volume_db = -20
		combo_sound_player.volume_db = -5
	else:
		win_player.stop()
		music_player.stop()
		sound_player.volume_db = -80
		combo_sound_player.volume_db = -80