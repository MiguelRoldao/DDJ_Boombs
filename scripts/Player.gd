extends RigidBody2D

# the JumpTimer is not in use. It was planned for aa jumping mechanic like
# in the original super mario bros, where the longer you jump, the higher
# you go

var speed = 50
var acceleration = 120
var air_acceleration = acceleration / 4.0
var gravity = 9.8
var jump_speed = 192
var throwing_force = 4
var recoil_force = 16

var torque_rate = 120
var max_mouse_distance = 64


var velocity = Vector2(0, 0)
var is_jumping = false
var mouse_hover = []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if Input.is_action_pressed("ui_right"):
		var impulse = Vector2(min(speed, delta * speed * (acceleration if is_on_floor() else air_acceleration)), 0)
		apply_central_impulse(impulse)
	elif Input.is_action_pressed("ui_left"):
		var impulse = Vector2(max(- speed, - delta * speed * (acceleration if is_on_floor() else air_acceleration)), 0)
		apply_central_impulse(impulse)


func _process(delta):
	# rotate gun
	var mouse_pos = get_local_mouse_position()
	var angle = rad2deg(atan2(mouse_pos.y, mouse_pos.x)) #+ rotation_degrees
	$GunSprite.rotation_degrees = angle
	


func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		#print("Mouse Click/Unclick at: ", event.position)
		if event.is_pressed():
			var local = get_local_mouse_position()
			var global = get_global_mouse_position()
			
			# check if clicked on a bomb
			#print(mouse_hover)
			#print(local, global, global-position)
			
			if mouse_hover.empty():
				throwBomb(global - position)
			else:
				for obj in mouse_hover:
					obj.click()
				
	elif event is InputEventMouseMotion:
		#print("Mouse Motion at: ", event.position)
		pass

	# Print the size of the viewport.
	#print("Viewport Resolution is: ", get_viewport_rect().size)

func dropBomb(pos: Vector2):
	print (pos)
	var bomb = load("res://scenes/Bomb.tscn").instance() as RigidBody2D
	bomb.apply_central_impulse(Vector2(0, 0))
	bomb.position = pos
	get_parent().add_child(bomb)

func throwBomb(vector: Vector2):
	var norm = vector.normalized()
	var mag = min(vector.length(), max_mouse_distance)
	
	var bomb = load("res://scenes/Bomb.tscn").instance() as RigidBody2D
	bomb.apply_central_impulse(throwing_force * norm * mag)
	bomb.position = position
	get_parent().add_child(bomb)
	
	apply_central_impulse(- recoil_force * norm * mag)
	pass

func is_on_floor():
	return test_motion(Vector2.DOWN)
	
func bounce():
	var impulse = Vector2(0, -1500)
	apply_central_impulse(impulse)
