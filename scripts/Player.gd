extends RigidBody2D


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


var left_bomb_color = Color.red
var right_bomb_color = Color.green

var left_click = false
var right_click = false

var left_bomb = false
var right_bomb = false

var double_gun = true



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
			
			if double_gun:
				if event.button_index == BUTTON_LEFT:
					if $LeftBombTimer.is_stopped():
						left_bomb = throwBomb(global - position, left_bomb_color)
						$LeftBombTimer.start()
					else:
						if is_instance_valid(left_bomb):
							left_bomb.click()
							left_bomb = null
				if event.button_index == BUTTON_RIGHT:
					if $RightBombTimer.is_stopped():
						right_bomb = throwBomb(global - position, right_bomb_color)
						$RightBombTimer.start()
					else:
						if is_instance_valid(right_bomb):
							right_bomb.click()
							right_bomb = null
			else:
				if mouse_hover.empty():
					throwBomb(global - position, Color.red)
				else:
					for obj in mouse_hover:
						obj.click()


func dropBomb(pos: Vector2):
	print (pos)
	var bomb = load("res://scenes/Bomb.tscn").instance() as RigidBody2D
	bomb.apply_central_impulse(Vector2(0, 0))
	bomb.position = pos
	get_parent().add_child(bomb)


func throwBomb(vector: Vector2, color: Color):
	var norm = vector.normalized()
	var mag = min(vector.length(), max_mouse_distance)
	
	# create bomb and apply impulse
	var bomb = load("res://scenes/Bomb.tscn").instance() as RigidBody2D
	bomb.apply_central_impulse(throwing_force * norm * mag)
	bomb.position = position
	get_parent().add_child(bomb)
	bomb.modulate = color
	
	# apply recoil to player
	apply_central_impulse(- recoil_force * norm * mag)
	
	return bomb


func is_on_floor():
	return test_motion(Vector2.DOWN)


func die():
	get_tree().change_scene("res://scenes/World1.tscn")


func bounce():
	var impulse = Vector2(0, -1500)
	apply_central_impulse(impulse)

func gothit(var enemyposx):
	modulate = Color(1,0.3,0.3,0.3)
	$GotHitTimer.start()
	var impulse = Vector2(0, 0)
	if position.x < enemyposx:
		impulse = Vector2(-1000, -1000)
	elif position.x > enemyposx:
		impulse = Vector2(1000, -1000)
	apply_central_impulse(impulse)


func _on_GotHitTimer_timeout():
	modulate = Color(1,1,1,1)
