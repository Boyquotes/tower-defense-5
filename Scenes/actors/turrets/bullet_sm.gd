extends CharacterBody2D

var direction := Vector2.RIGHT
var speed := 400

func _ready():
	set_as_top_level(true)
	direction = direction.normalized()
	look_at(direction + global_position)
	
func _physics_process(delta):
	var v = direction * speed * delta
	var c := move_and_collide(v)
	if c and c.collider:
		#do shit here
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
