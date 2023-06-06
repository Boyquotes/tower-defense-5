extends "res://Scenes/actors/turrets/gun_turrets.gd"

func _ready():
	super()
	_projectile_scene = preload("res://Scenes/actors/turrets/bullet_bg.tscn")
