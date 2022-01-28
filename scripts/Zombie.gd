extends KinematicBody2D

var speed = 30
var velocity = Vector2()
export var dir = -1
export var detects_cliffs = true

func _ready():
	if dir == 1:
		$AnimatedSprite.flip_h = false
		$vision_Cast.cast_to.y *= -1
	$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * dir
	$vision_Cast.position.x = $CollisionShape2D.shape.get_extents().x * dir
	$floor_checker.enabled = detects_cliffs
	if not detects_cliffs:
		$AnimatedSprite.set_modulate(Color(1.5, 0.5, 1))
	$Brain.visible = false

	
func _physics_process(delta):
	
	velocity.y += 20
	
	velocity.x = speed * dir
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if is_on_wall() or not $floor_checker.is_colliding() and detects_cliffs and is_on_floor():
		print (is_on_wall())
		dir = dir * -1
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
		$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * dir
		$vision_Cast.position.x = $CollisionShape2D.shape.get_extents().x * dir
		$vision_Cast.cast_to.y *= -1
	
	
	if $vision_Cast.is_colliding():
		if $vision_Cast.get_collider().is_in_group("player"):
			print ("I see you")
			$AnimatedSprite.play("running")
			$Brain.visible = true
			$Brain.play("exclamation")
			speed = 50
			$Run_Timer.start()
		

func _on_Run_Timer_timeout():
	print("Where dafq did he go?")
	$AnimatedSprite.play("thinking")
	$Brain.play("question")
	speed = 0
	$Brain_Timer.start()
	$vision_Cast.enabled = true
	
func _on_Brain_Timer_timeout():
	print("Fuck it, I'mma walk")
	$AnimatedSprite.play("walking")
	speed = 30
	$Brain.visible = false

func _on_top_checker_body_entered(body):
	if body.is_in_group("player"):
		body.bounce()
		deth()


func _on_bottom_checker_body_entered(body):
	if body.is_in_group("player"):
		body.gothit(position.x)


func _on_sides_checker_body_entered(body):
	if body.is_in_group("player"):
		body.gothit(position.x)


func _on_Death_Timer_timeout():
	queue_free()


func deth():
	$Brain.visible = false
	$AnimatedSprite.play("dead")
	speed = 0
	set_collision_layer_bit(1, false)
	set_collision_mask_bit(0, false)
	$top_checker.set_collision_layer_bit(1, false)
	$top_checker.set_collision_mask_bit(0, false)
	$sides_checker.set_collision_mask_bit(0, false)
	$bottom_checker.set_collision_mask_bit(0, false)
	$vision_Cast.enabled = false
	$Death_Timer.start()
