extends CharacterBody2D

var damage = 10
var speed = 800
var pierce = 3
var direction := Vector2.RIGHT
var hits_left = pierce

func _ready():
	set_as_top_level(true)
	direction = transform.x
	look_at(direction + global_position)
	
func _physics_process(delta):
	var v = direction * speed * delta
	var c := move_and_collide(v)
	if c and c.get_collider():
		var collider = c.get_collider()
		hit(collider)

func hit(target):
	if target.is_in_group("enemies"):
		add_collision_exception_with(target)
		target.take_damage(damage)
		hits_left = hits_left - 1
		if hits_left == 0:
			queue_free()
	else:
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
