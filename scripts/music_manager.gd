extends Node

enum Track {
	MAIN_MENU,
	GAME_1
}

@onready var game_1: AudioStreamPlayer = $Game1
@onready var main_menu: AudioStreamPlayer = $MainMenu

var current_player: AudioStreamPlayer = null

func play(track: Track):
	var new_player: AudioStreamPlayer

	match track:
		Track.MAIN_MENU:
			new_player = main_menu
		Track.GAME_1:
			new_player = game_1

	if current_player == new_player:
		return

	if current_player:
		current_player.stop()

	current_player = new_player
	current_player.play()
