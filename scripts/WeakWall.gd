extends StaticBody2D


var max_round_rot = 10

func on_activate():
	# create round rock
	var rock = load("res://scenes/obstacles/RoundRock.tscn").instance() as RigidBody2D
	rock.position = position
	var torque = rand_range(-max_round_rot, max_round_rot)
	print(torque)
	rock.angular_velocity = torque
	get_parent().add_child(rock)
	queue_free()
