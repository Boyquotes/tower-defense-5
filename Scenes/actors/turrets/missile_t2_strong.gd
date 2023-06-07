extends "res://Scenes/actors/turrets/missile_turrets.gd"

func shoot(muzzle):
	var projectile = _projectile_scene.instantiate()
	projectile.transform = muzzle.global_transform	
	projectile.damage = damage
	projectile.pierce = pierce
	projectile.speed = 800
	projectile.guided = true #go get'em
	add_child(projectile)
