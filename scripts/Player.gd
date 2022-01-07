extends KinematicBody2D


var velocity = Vector2(0, 0)
var speed = 96.0
var gravity = 9.8
var jump_speed = 192
var is_jumping = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var x = velocity.x
	
	if Input.is_action_pressed("ui_right"):
		if x < speed:
			x = speed
	elif Input.is_action_pressed("ui_left"):
		if x > -speed:
			x = -speed
	elif is_on_floor():
		if x > 0:
			x -= speed * delta * gravity
			if x < 0:
				x = 0
		elif x < 0:
			x += speed * delta * gravity
			if x > 0:
				x = 0
	
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			is_jumping = true
			velocity.y = -jump_speed
			$JumpTimer.start()
		else:
			pass #velocity.y = 0
	else:
		velocity.y += speed * delta * gravity
		if Input.is_action_just_released("ui_up"):
			pass
		elif is_jumping:
			if $JumpTimer.time_left:
				pass
	# TODO: jumping
				
		#velocity.y += gravity
	
	#velocity.x = clamp(x, -speed, speed)
	velocity.x = x
	move_and_slide(velocity, Vector2.UP)
	
	if is_on_floor():
		velocity.y = 0


func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		#print("Mouse Click/Unclick at: ", event.position)
		if event.is_pressed():
			#jump()
			var local = get_local_mouse_position()
			var global = get_global_mouse_position()
			print(local, global)
			throwBomb(local + global)
	elif event is InputEventMouseMotion:
		#print("Mouse Motion at: ", event.position)
		pass

	# Print the size of the viewport.
	#print("Viewport Resolution is: ", get_viewport_rect().size)

func jump():
	velocity.y = -200

func throwBomb(pos: Vector2):
	print (pos)
	var bomb = load("res://scenes/Bomb.tscn").instance() as RigidBody2D
	bomb.apply_central_impulse(Vector2(0, 0))
	bomb.position = pos
	get_parent().add_child(bomb)

