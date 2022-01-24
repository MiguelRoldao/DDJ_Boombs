extends Node2D


var max_mouse_distance = 64
var shooting_power = 4
var recoil_power = 16

var left_bomb_color = Color.red
var right_bomb_color = Color.green

var left_bomb = false
var right_bomb = false


# fires gun based on clicked button
# returs recoil force, and bomb to add to the environment
func trigger(event: InputEventMouseButton):
	var global = get_global_mouse_position()
	var vals = {recoil = Vector2.ZERO, bomb = null}
	var pos = get_parent().position

	if event.button_index == BUTTON_LEFT:
		if $LeftBombTimer.is_stopped():
			vals = shootBomb(global - pos, left_bomb_color)
			left_bomb = vals.bomb
			$LeftBombTimer.start()
		else:
			if is_instance_valid(left_bomb):
				left_bomb.click()
				left_bomb = null
	if event.button_index == BUTTON_RIGHT:
		if $RightBombTimer.is_stopped():
			vals = shootBomb(global - pos, right_bomb_color)
			right_bomb = vals.bomb
			$RightBombTimer.start()
		else:
			if is_instance_valid(right_bomb):
				right_bomb.click()
				right_bomb = null
	return vals


func shootBomb(vector: Vector2, color: Color):
	var norm = vector.normalized()
	var mag = min(vector.length(), max_mouse_distance)
	
	# create bomb and apply impulse
	var bomb = load("res://scenes/Bomb.tscn").instance() as RigidBody2D
	bomb.apply_central_impulse(shooting_power * norm * mag)
	bomb.position = get_parent().position
	
	#get_parent().add_child(bomb)
	bomb.modulate = color
	
	# apply recoil to player
	#apply_central_impulse(- recoil_force * norm * mag)
	var retvals = {
		bomb = bomb,
		recoil = - recoil_power * norm * mag
	}
	
	return retvals
