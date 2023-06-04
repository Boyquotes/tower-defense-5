extends Path2D

var timer = 0
@export var spawnTime = 1

var follower = preload("res://Scenes/actors/enemies/soldier_A_follow.tscn")

func _process(delta):
	timer = timer + delta
	
	if (timer > spawnTime):
		var newFollower = follower.instantiate()
		add_child(newFollower)
		#newFollower.add_to_group("enemies") ##doesnt work lol
		timer = 0
