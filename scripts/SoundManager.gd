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
var sound_enable = true

# Main theme
var possible_music = [
preload("res://art/Sound/Music/theme-1.ogg")
]
# Effects for pieces and buttons
var possible_sounds = [
preload("res://art/Sound/Effects/Match1.wav"),
preload("res://art/Sound/Effects/Match2.wav"),
preload("res://art/Sound/Effects/Match3.wav"),
preload("res://art/Sound/Effects/Match4.wav"),
preload("res://art/Sound/Effects/Match5.wav"),
preload("res://art/Sound/Effects/Match6.wav"),
preload("res://art/Sound/Effects/Match7.wav")
]
# Game Win sounds
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
# Combo sounds for blue pieces
var combo_sounds_blue = [
preload("res://art/Sound/Effects/Cortes/blue1.ogg"),
preload("res://art/Sound/Effects/Cortes/blue2.ogg"),
preload("res://art/Sound/Effects/Cortes/blue3.ogg"),
preload("res://art/Sound/Effects/Cortes/blue4.ogg"),
preload("res://art/Sound/Effects/Cortes/blue5.ogg"),
preload("res://art/Sound/Effects/Cortes/blue6.ogg")
]
# Combo sounds for purple pieces
var combo_sounds_purple = [
preload("res://art/Sound/Effects/Cortes/purple1.ogg"),
preload("res://art/Sound/Effects/Cortes/purple2.ogg"),
preload("res://art/Sound/Effects/Cortes/purple3.ogg"),
preload("res://art/Sound/Effects/Cortes/purple4.ogg"),
preload("res://art/Sound/Effects/Cortes/purple5.ogg"),
preload("res://art/Sound/Effects/Cortes/purple6.ogg")
]
# Combo sounds for green pieces
var combo_sounds_green = [
preload("res://art/Sound/Effects/Cortes/green1.ogg"),
preload("res://art/Sound/Effects/Cortes/green2.ogg"),
preload("res://art/Sound/Effects/Cortes/green3.ogg"),
preload("res://art/Sound/Effects/Cortes/green4.ogg"),
preload("res://art/Sound/Effects/Cortes/green5.ogg")
]
# Combo sounds for orange pieces
var combo_sounds_orange = [
preload("res://art/Sound/Effects/Cortes/orange1.ogg"),
preload("res://art/Sound/Effects/Cortes/orange2.ogg"),
preload("res://art/Sound/Effects/Cortes/orange3.ogg"),
preload("res://art/Sound/Effects/Cortes/orange4.ogg"),
preload("res://art/Sound/Effects/Cortes/orange5.ogg"),
preload("res://art/Sound/Effects/Cortes/orange6.ogg")
]
# Combo sounds for red pieces
var combo_sounds_red = [
preload("res://art/Sound/Effects/Cortes/red1.ogg"),
preload("res://art/Sound/Effects/Cortes/red2.ogg"),
preload("res://art/Sound/Effects/Cortes/red3.ogg"),
preload("res://art/Sound/Effects/Cortes/red4.ogg"),
preload("res://art/Sound/Effects/Cortes/red5.ogg"),
preload("res://art/Sound/Effects/Cortes/red6.ogg")
]
# Combo sounds for yellow pieces
var combo_sounds_yellow = [
preload("res://art/Sound/Effects/Cortes/yellow1.ogg"),
preload("res://art/Sound/Effects/Cortes/yellow2.ogg"),
preload("res://art/Sound/Effects/Cortes/yellow3.ogg"),
preload("res://art/Sound/Effects/Cortes/yellow4.ogg"),
preload("res://art/Sound/Effects/Cortes/yellow5.ogg"),
preload("res://art/Sound/Effects/Cortes/yellow6.ogg"),
preload("res://art/Sound/Effects/Cortes/yellow7.ogg"),
]
# Combo sounds for color pieces
var combo_sounds_color = [
#preload("res://art/Sound/Effects/Cortes/color.ogg")
preload("res://art/Sound/Effects/delisioso.ogg")
]
# All combo sounds
var combo_sounds = {
"blue" : combo_sounds_blue,
"purple" : combo_sounds_purple,
"green" : combo_sounds_green,
"orange" : combo_sounds_orange,
"red" : combo_sounds_red,
"yellow" : combo_sounds_yellow,
"color" : combo_sounds_color
}
# @Deprecated
var possible_combo_sound = [
preload("res://art/Sound/Effects/delisioso.ogg")
]

func _ready():
	randomize()
	play_random_music()

func play_random_music():
	if sound_enable:
		if possible_music.size() > 0:
			var temp = floor(rand_range(0, possible_music.size()))
			music_player.stream = possible_music[temp]
			music_player.play()

func play_random_sound():
	if sound_enable:
		if possible_sounds.size() > 0:
			var temp = floor(rand_range(0, possible_sounds.size()))
			sound_player.stream = possible_sounds[temp]
			sound_player.play()

# @Deprecated - now is play_combo_sound(color)
func play_random_combo_sound():
	if sound_enable:
		if possible_combo_sound.size() > 0:
			var temp = floor(rand_range(0, possible_combo_sound.size()))
			combo_sound_player.stream = possible_combo_sound[temp]
			combo_sound_player.play()

func play_combo_sound(color):
	if sound_enable:
		var sounds_list = combo_sounds[color]
		var list_size = sounds_list.size()
		var sound_index = floor (rand_range(0, list_size))
		var sound = sounds_list[sound_index]
		#print("DEBUG - color:", color, " list_size:", list_size, " sound_index:", sound_index, " sound:", sound)
		combo_sound_player.stream = sound
		combo_sound_player.play()

func stop_combo_sound():
	if sound_enable:
		combo_sound_player.stop()

func play_fixed_sound(sound):
	if sound_enable:
		if sound < possible_sounds.size():
			sound_player.stream = possible_sounds[sound]
			sound_player.play()

func play_win_music(win_color):
	if sound_enable:
		#print("DEBUG sound win_color:",win_color)
		win_player.stream = win_sounds[win_color]
		win_player.play()

func stop_music_player():
	if sound_enable:
		music_player.stop()

func activate_music(activate):
	if sound_enable:
		if (activate):
			music_player.set_volume_db(MUSIC_LEVEL)
		else:
			music_player.set_volume_db(MUTE)

func activate_effects(activate):
	if sound_enable:
		if (activate):
			combo_sound_player.set_volume_db(COMBO_LEVEL)
			sound_player.set_volume_db(EFFECTS_LEVEL)
			win_player.set_volume_db(WIN_LEVEL)
		else:
			combo_sound_player.set_volume_db(MUTE)
			sound_player.set_volume_db(MUTE)
			win_player.set_volume_db(MUTE)

func stop_win_music_player():
	if sound_enable:
		win_player.stream = null
		win_player.stop()

func enable_game_sound(enable):
	if enable:
		music_player.play()
		win_player.play()
		activate_effects(enable)
		activate_music(enable)
	else:
		win_player.stop()
		music_player.stop()
		win_player.stop()
		sound_player.volume_db = -80
		combo_sound_player.volume_db = -80

func enable_sounds(enable):
	if sound_enable: enable_game_sound(enable)

func remove_combo_audio():
	if sound_enable:
		combo_sound_player.stream = null