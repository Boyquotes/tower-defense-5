extends "res://Scenes/actors/turrets/gun_turrets.gd"
#uses the same script as gun turrets and overwrites the needed functions

func _ready():
	super()
	_projectile_scene = preload("res://Scenes/actors/turrets/missile.tscn")
	_timer.wait_time = 1/fire_rate

func _physics_process(delta): #changed to fire both barrels with a short delay and then wait the fire rate timer
	if active:
		if target != null:
			aim(delta)
			if can_fire and _ray_cast.is_colliding():
				shoot(_muzzles[current_muzzle])
				can_fire = false
				await get_tree().create_timer(0.1).timeout #adds a delay between both barrels
				can_fire = true
				current_muzzle += 1
				if current_muzzle == _muzzles.size():
					current_muzzle = 0 #checks at the end so it only sets the delay after both barrels fired instead of at each barrel
					can_fire = false
					_timer.start()

func shoot(muzzle):
	var projectile = _projectile_scene.instantiate()
	projectile.transform = muzzle.global_transform	
	projectile.damage = damage
	projectile.pierce = pierce
	projectile.speed = 800
	add_child(projectile)
