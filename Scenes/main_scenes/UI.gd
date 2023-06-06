extends CanvasLayer

@onready var _build_buttons = get_tree().get_nodes_in_group("build_buttons")
@onready var _map = get_tree().get_root().get_child(0).get_child(0)
@onready var _control = $HUD/Control
var tower_scene
var tower_path = ""
var placing = false
var temp_tower

func _ready():
	for button in _build_buttons:
		button.pressed.connect(button_press.bind(button))

func button_press(button):
	if not placing:
		tower_path = "res://Scenes/actors/turrets/" + button.get_name() + "_t1.tscn"
		tower_scene = load(tower_path)
		temp_tower = tower_scene.instantiate()
		_control.add_child(temp_tower)
		placing = true

func _physics_process(delta):
	if placing:
		_control.global_position = get_viewport().get_mouse_position()
