extends KinematicBody2D

var velocity = Vector2()
export var dir = -1
export var detects_cliffs = true

func _ready():
	if dir == 1:
		$AnimatedSprite.flip_h = true
	$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * dir
	$floor_checker.enabled = detects_cliffs
	
func _physics_process(delta):
	
	if is_on_wall() or not $floor_checker.is_colliding() and detects_cliffs and is_on_floor():
		dir = dir * -1
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
		$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * dir
	
	velocity.y += 20
	
	velocity.x = 20 * dir
	
	velocity = move_and_slide(velocity, Vector2.UP)