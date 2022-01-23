extends KinematicBody2D

var speed = 30
var velocity = Vector2()
export var dir = -1
export var detects_cliffs = true

func _ready():
	if dir == 1:
		$AnimatedSprite.flip_h = true
	$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * dir
	$floor_checker.enabled = detects_cliffs
	if not detects_cliffs:
		set_modulate(Color(1.5, 0.5, 1))
	
func _physics_process(delta):
	
	velocity.y += 20
	
	velocity.x = speed * dir
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if is_on_wall() or not $floor_checker.is_colliding() and detects_cliffs and is_on_floor():
		print ($floor_checker.is_colliding())
		dir = dir * -1
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
		$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * dir


func _on_top_checker_body_entered(body):
	kill_blob(body)
	body.bounce()


func _on_bottom_checker_body_entered(body):
	LivesCounter.lives -= 1
	kill_blob(body)


func _on_sides_checker_body_entered(body):	
	LivesCounter.lives -= 1
	kill_blob(body)


func _on_Timer_timeout():
	queue_free()


func kill_blob(body):
	$AnimatedSprite.play("squashed")
	speed = 0
	set_collision_layer_bit(1, false)
	set_collision_mask_bit(0, false)
	$top_checker.set_collision_layer_bit(1, false)
	$top_checker.set_collision_mask_bit(0, false)
	$sides_checker.set_collision_mask_bit(0, false)
	$bottom_checker.set_collision_mask_bit(0, false)
	$Timer.start()
