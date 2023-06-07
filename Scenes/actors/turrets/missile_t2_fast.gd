extends "res://Scenes/actors/turrets/missile_turrets.gd"

func shoot(muzzle):
	var projectile = _projectile_scene.instantiate()
	projectile.transform = muzzle.global_transform	
	projectile.damage = damage
	projectile.pierce = pierce
	projectile.speed = 1100 #faster!!
	add_child(projectile)
