extends CanvasLayer

@onready var _build_buttons = get_tree().get_nodes_in_group("build_buttons")
@onready var _map = get_tree().get_root().get_child(0).get_child(0)
@onready var _control = $HUD/Control
@onready var _game_scene = get_tree().get_root().get_child(0)
var tower_scene
var tower_path = ""
var placing = false
var temp_tower

func _ready():
	for button in _build_buttons:
		button.pressed.connect(button_press.bind(button))
	pass

#func button_press(button): #a de verdade que é pra ser usada
#	if not placing:
#		tower_path = "res://Scenes/actors/turrets/" + button.get_name() + "_t1.tscn"
#		tower_scene = load(tower_path)
#		temp_tower = tower_scene.instantiate()
#		_control.add_child(temp_tower)
#		placing = true

func button_press(button): #a que foi feita em cima da hora
	if not placing:
		if button.get_name() == "gun":
			if _game_scene.money >= 250:
				_game_scene.money -= 250
				tower_path = "res://Scenes/actors/turrets/gun_t1.tscn"
				tower_scene = load(tower_path)
				temp_tower = tower_scene.instantiate()
				_control.add_child(temp_tower)
				placing = true
		else:
			if _game_scene.money >= 500:
				_game_scene.money -= 500
				tower_path = "res://Scenes/actors/turrets/missile_t1.tscn"
				tower_scene = load(tower_path)
				temp_tower = tower_scene.instantiate()
				_control.add_child(temp_tower)
				placing = true

func _physics_process(delta):
	if placing:
		_control.global_position = get_viewport().get_mouse_position()
		if Input.is_action_just_pressed("left_click"):
			#place tower
			_control.remove_child(temp_tower)
			_map.get_node("towers").add_child(temp_tower)
			temp_tower.global_position = get_viewport().get_mouse_position()
			temp_tower.damage = 10
			temp_tower.fire_rate = 3
			temp_tower.pierce = 3
			temp_tower.active = true
			temp_tower.get_node("range_view").visible = false
			placing = false

		if Input.is_action_just_pressed("right_click"):
			_game_scene.money += 250
			_control.remove_child(temp_tower)
			temp_tower.queue_free
			placing = false
