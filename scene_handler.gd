extends Node

func _ready():
	get_node("mainMenu/m/vb/newGame").connect("pressed", on_new_game_pressed)
	get_node("mainMenu/m/vb/quit").connect("pressed", on_quit_pressed)

func on_new_game_pressed():
	get_tree().change_scene_to_file ("res://Scenes/main_scenes/game_scene.tscn")

func on_quit_pressed():
	get_tree().quit()
