extends RigidBody2D


var speed = 50
var acceleration = 120
var air_acceleration = acceleration / 4.0
var throwing_force = 4
var recoil_force = 16

var torque_rate = 120
var max_mouse_distance = 64


var double_gun = true


var dead = false


func _ready():
	if Checkpoint.use_coordinates:
		position = Checkpoint.coordinates
		Checkpoint.use_coordinates = false
	else:
		go_to_checkpoint()

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
			
			var retvals = $Gun.trigger(event)
			apply_central_impulse(retvals.recoil)
			if is_instance_valid(retvals.bomb):
				get_parent().add_child(retvals.bomb)


#func dropBomb(pos: Vector2):
#	print (pos)
#	var bomb = load("res://scenes/Bomb.tscn").instance() as RigidBody2D
#	bomb.apply_central_impulse(Vector2(0, 0))
#	bomb.position = pos
#	get_parent().add_child(bomb)


func is_on_floor():
	return test_motion(Vector2.DOWN)


func die():
	if dead:
		return
	get_tree().change_scene(Checkpoint.level)
	LivesCounter.dec()
	Checkpoint.p()
	dead = true

func go_to_checkpoint():
	var checkpoint = get_tree().current_scene.find_node(Checkpoint.checkpoint)
	if is_instance_valid(checkpoint):
		position = get_tree().current_scene.find_node(Checkpoint.checkpoint).position


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
	LivesCounter.dec()
	if LivesCounter.lives <= 0:
		die()


func _on_GotHitTimer_timeout():
	modulate = Color(1,1,1,1)
