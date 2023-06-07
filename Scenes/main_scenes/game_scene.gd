extends Node2D

@onready var lives_label = $UI/HUD/stats/lives/Label
@onready var money_label = $UI/HUD/stats/money/Label
@onready var dead_screen = $"UI/HUD/dead screen"
@onready var lives = 100
@onready var money = 500
@onready var dead = false

func _ready():
	dead_screen.get_node("newGame").connect("pressed", on_new_game_pressed)
	dead_screen.get_node("quit").connect("pressed", on_quit_pressed)
	dead_screen.visible = false

func _process(delta):
	lives_label.text = "Vidas: " + str(lives)
	money_label.text = "$" + str(money)
	if lives <= 0:
		dead = true
		if not dead_screen.visible:
			dead_screen.visible = true
			$map1/Track.queue_free()
			$map1/towers.queue_free()

func on_new_game_pressed():
	if dead:
		get_tree().change_scene_to_file ("res://scene_handler.tscn")

func on_quit_pressed():
	if dead:
		get_tree().quit()
