extends Node

onready var music_player = $MusicPlayer
onready var sound_player = $SoundPlayer
onready var combo_sound_player = $ComboSoundPlayer
onready var win_player = $WinPlayer

var MUSIC_LEVEL = -15
var EFFECTS_LEVEL = -10
var COMBO_LEVEL = 5
var WIN_LEVEL = -10
var MUTE = -100

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

var combo_sounds = {
"blue1" : preload("res://art/Sound/Effects/Cortes/blue1.ogg"),
"blue2" : preload("res://art/Sound/Effects/Cortes/blue2.ogg"),
"blue3" : preload("res://art/Sound/Effects/Cortes/blue3.ogg"),
"purple1" : preload("res://art/Sound/Effects/Cortes/purple1.ogg"),
"purple2" : preload("res://art/Sound/Effects/Cortes/purple2.ogg"),
"purple3" : preload("res://art/Sound/Effects/Cortes/purple2.ogg"),
"green1" : preload("res://art/Sound/Effects/Cortes/green1.ogg"),
"green2" : preload("res://art/Sound/Effects/Cortes/green2.ogg"),
"green3" : preload("res://art/Sound/Effects/Cortes/green2.ogg"),
"orange1" : preload("res://art/Sound/Effects/Cortes/orange1.ogg"),
"orange2" : preload("res://art/Sound/Effects/Cortes/orange2.ogg"),
"orange3" : preload("res://art/Sound/Effects/Cortes/orange3.ogg"),
"red1" : preload("res://art/Sound/Effects/Cortes/red1.ogg"),
"red2" : preload("res://art/Sound/Effects/Cortes/red2.ogg"),
"red3" : preload("res://art/Sound/Effects/Cortes/red3.ogg"),
"yellow1" : preload("res://art/Sound/Effects/Cortes/yellow1.ogg"),
"yellow2" : preload("res://art/Sound/Effects/Cortes/yellow2.ogg"),
"yellow3" : preload("res://art/Sound/Effects/Cortes/yellow3.ogg"),
"color" : preload("res://art/Sound/Effects/Cortes/color.ogg")
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

#Deprecated - now is play_combo_sound(color)
func play_random_combo_sound():
	if possible_combo_sound.size() > 0:
		var temp = floor(rand_range(0, possible_combo_sound.size()))
		combo_sound_player.stream = possible_combo_sound[temp]
		combo_sound_player.play()
		
func play_combo_sound(color):
	#print("DEBUG - color:",color)
	if (color == "color"):
		combo_sound_player.stream = combo_sounds[color]
		combo_sound_player.play()
		return
	var number = floor(rand_range(1, 4))
	var sound = color + String(number)
	combo_sound_player.stream = combo_sounds[sound]
	combo_sound_player.play()

func stop_combo_sound():
	combo_sound_player.stop()

func play_fixed_sound(sound):
	if sound < possible_sounds.size():
		sound_player.stream = possible_sounds[sound]
		sound_player.play()

func play_win_music(win_color):
	#print("DEBUG sound win_color:",win_color)
	win_player.stream = win_sounds[win_color]
	win_player.play()

func stop_music_player():
	music_player.stop()

func activate_music(activate):
	if (activate):
		music_player.set_volume_db(MUSIC_LEVEL)
	else:
		music_player.set_volume_db(MUTE)

func activate_effects(activate):
	if (activate):
		combo_sound_player.set_volume_db(COMBO_LEVEL)
		sound_player.set_volume_db(EFFECTS_LEVEL)
		win_player.set_volume_db(WIN_LEVEL)
	else:
		combo_sound_player.set_volume_db(MUTE)
		sound_player.set_volume_db(MUTE)
		win_player.set_volume_db(MUTE)

func stop_win_music_player():
	win_player.stream = null
	win_player.stop()

func disable_sounds(enable):
	if enable:
		music_player.play()
		win_player.play()
		sound_player.volume_db = EFFECTS_LEVEL
		combo_sound_player.volume_db = COMBO_LEVEL
		activate_effects(enable)
		activate_music(enable)
	else:
		win_player.stop()
		music_player.stop()
		win_player.stop()
		sound_player.volume_db = -80
		combo_sound_player.volume_db = -80