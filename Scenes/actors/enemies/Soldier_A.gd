extends CharacterBody2D

@export var speed = 500
@export var health = 10

func _ready():
	add_to_group("enemies")

func _process(delta):
	get_parent().set_progress(get_parent().get_progress() + speed*delta)
	if get_parent().get_progress_ratio() == 1:
		get_parent().queue_free()

func _damage(damage):
	health = health-damage
	if health <= 0:
		queue_free()
