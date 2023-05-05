extends Node2D

var bullet = preload("res://Scenes/actors/turrets/bullet_sm.tscn")
var bulletDamage = 5
var pathName
var currTargets = []
var curr

func _on_range_body_entered(body):
	print("hi")
	if "Soldier A" in body.name:
		var tempArray = []
		currTargets = get_node("base/range").get_overlapping_bodies()

		for i in currTargets:
			if "soldier" in i.name:
				tempArray.append(i)
		
		var currTarget = null
		
		for i in tempArray:
			if currTarget == null:
				currTarget = i.get_node("../")
			else:
				if i.get_parent().get_progress() > currTarget.get_prograss():
					currTarget = i.get_node("../")
		
		curr = currTarget
		pathName = currTarget.get_parent().name
		
		var tempBullet = bullet.instantiate()
		tempBullet.pathName = pathName
		tempBullet.damage = bulletDamage
		get_node("gun/muzzle/bulletContainer").add_child(tempBullet)
		tempBullet.global_position = $muzzle.global_position

func _on_range_body_exited(body):
	pass # Replace with function body.
