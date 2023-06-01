extends CharacterBody2D

@export var speed = 500

func _ready():
	add_to_group("enemies")

func _process(delta):
	get_parent().set_progress(get_parent().get_progress() + speed*delta)
	if get_parent().get_progress_ratio() == 1:
		get_parent().queue_free()
