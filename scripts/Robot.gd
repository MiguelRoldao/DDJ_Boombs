extends KinematicBody2D

var speed = 0
var velocity = Vector2()
export var dir = -1
var detects_cliffs = true
var health = 3

func _ready():
	if dir == 1:
		$AnimatedSprite.flip_h = false
		$vision_Cast.cast_to.y *= -1
		$vision_Cast2.cast_to.y *= -1
	$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * dir
	$vision_Cast.position.x = $CollisionShape2D.shape.get_extents().x * dir
	$vision_Cast2.position.x = $CollisionShape2D.shape.get_extents().x * dir
	$floor_checker.enabled = detects_cliffs
	$AnimatedSprite.play("crouch")

func _physics_process(delta):
	
	velocity.y += 20
	
	velocity.x = speed * dir
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if is_on_wall() or not $floor_checker.is_colliding() and is_on_floor():
		print ($floor_checker.is_colliding())
		dir = dir * -1
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
		$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * dir
		$vision_Cast.position.x = $CollisionShape2D.shape.get_extents().x * dir
		$vision_Cast2.position.x = $CollisionShape2D.shape.get_extents().x * dir
		$vision_Cast.cast_to.y *= -1
		$vision_Cast2.cast_to.y *= -1
	
	
	if $vision_Cast.is_colliding():
		if $vision_Cast.get_collider().is_in_group("player"):
			print ("Target acquired")
			$AnimatedSprite.play("running")
			$State.visible = true
			$State.play("exclamation")
			speed = 25
			$Run_Timer.start()
	elif $vision_Cast2.is_colliding():
		if $vision_Cast2.get_collider().is_in_group("player"):
			print ("Target acquired")
			$AnimatedSprite.play("running")
			$State.visible = true
			$State.play("exclamation")
			speed = 25
			$Run_Timer.start()

func _on_Run_Timer_timeout():
	print("Lost sight of target, initiating investigation")
	$AnimatedSprite.play("walking")
	$State.visible = false
	speed = 15
	$vision_Cast.enabled = true

func _on_top_checker_body_entered(body):
	if body.is_in_group("player"):
		body.bounce_alt()
		$vision_Cast.enabled = false
		$vision_Cast2.enabled = false
		if health==1:
			set_modulate(Color(1.5, 0.5, 1))
			deth()
		else:
			health-=1
			$top_checker/CollisionShape2D.disabled = true
			$AnimatedSprite.play("hit")
			speed = 0
			set_modulate(Color(1.5, 0.5, 1))
			$Hit_Timer.start()

func _on_Hit_Timer_timeout():
	$vision_Cast.enabled = true
	$vision_Cast2.enabled = true
	$top_checker/CollisionShape2D.disabled = false
	$AnimatedSprite.play("walking")
	speed = 15
	set_modulate(Color(1, 1, 1))

func _on_sides_checker_body_entered(body):
	if body.is_in_group("player"):
		body.gothit(position.x)


func _on_Death_Timer_timeout():
	queue_free()

func deth():
	$State.visible = false
	$AnimatedSprite.play("dead")
	speed = 0
	set_collision_layer_bit(1, false)
	set_collision_mask_bit(0, false)
	$top_checker.set_collision_layer_bit(1, false)
	$top_checker.set_collision_mask_bit(0, false)
	$sides_checker.set_collision_mask_bit(0, false)
	$top_checker/CollisionShape2D.disabled = true
	$sides_checker/CollisionShape2D.disabled = true
	$Death_Timer.start()
