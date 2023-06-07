extends CharacterBody2D

@export var speed = 800
@export var health = 10
@onready var sprite = $TowerDefenseTile245

func _ready():
	add_to_group("enemies")

func _process(delta):
	get_parent().set_progress(get_parent().get_progress() + speed*delta)
	if get_parent().get_progress_ratio() == 1:
		get_tree().get_root().get_child(0).lives -= 1
		get_parent().queue_free()

func take_damage(damage):
	health = health-damage
	if health <= 0:
		get_tree().get_root().get_child(0).money += 5
		queue_free()

func targeted(is_tar):
	if is_tar:
		sprite.modulate = Color(1,0,0)
	else:
		sprite.modulate = Color(1,1,1)
