extends KinematicBody2D

var speed = 96.0
var gravity = 9.8
var jump_speed = 192
var throwing_force = 4
var recoil_ratio = 2

var velocity = Vector2(0, 0)
var is_jumping = false
var mouse_hover = []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var x = velocity.x
	

	
	if is_on_floor():
		if Input.is_action_pressed("ui_right"):
			if x < speed:
				x = speed
		elif Input.is_action_pressed("ui_left"):
			if x > -speed:
				x = -speed
		else:
			if x > 0:
				x -= speed * delta * gravity
				if x < 0:
					x = 0
			elif x < 0:
				x += speed * delta * gravity
				if x > 0:
					x = 0
		
		
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
			var local = get_local_mouse_position()
			var global = get_global_mouse_position()
			
			# check if clicked on a bomb
			print(mouse_hover)
			print(local, global)
			
			if mouse_hover.empty():
				throwBomb(local)
				velocity -= local * throwing_force / recoil_ratio
			else:
				for obj in mouse_hover:
					obj.click()
				
	elif event is InputEventMouseMotion:
		#print("Mouse Motion at: ", event.position)
		pass

	# Print the size of the viewport.
	#print("Viewport Resolution is: ", get_viewport_rect().size)

func jump():
	velocity.y = -200

func dropBomb(pos: Vector2):
	print (pos)
	var bomb = load("res://scenes/Bomb.tscn").instance() as RigidBody2D
	bomb.apply_central_impulse(Vector2(0, 0))
	bomb.position = pos
	get_parent().add_child(bomb)

func throwBomb(vector: Vector2):
	var bomb = load("res://scenes/Bomb.tscn").instance() as RigidBody2D
	bomb.apply_central_impulse(throwing_force * vector)
	bomb.position = position
	get_parent().add_child(bomb)
	pass


