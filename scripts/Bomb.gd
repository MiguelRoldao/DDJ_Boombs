extends RigidBody2D

var explosion_radius = 32.0
var power = 200.0
var time = 3.0

var toExplode = false

func _ready():
	add_to_group("explosive")
	$Timer.start()
	input_pickable = true
	connect("mouse_entered", self, "mouse_entered_hovering")
	connect("mouse_exited", self, "mouse_exited_hovering")

func _physics_process(delta):
	if toExplode:
		explode()

func _on_Timer_timeout():
	#print("bomb timeout")
	toExplode = true


func mouse_entered_hovering():
	#get_parent().get_node("Player").mouse_hover.append(self)
	pass


func mouse_exited_hovering():
	#get_parent().get_node("Player").mouse_hover.erase(self)
	pass


func click():
	toExplode = true


func explode():
	explosion()
	mouse_exited_hovering()
	queue_free()

func explosion():
	for body in $Area2D.get_overlapping_bodies():
		if body == self:
			continue
		elif body.is_in_group("explosive"):
			#body.toExplode = true
			body.get_node("Timer").wait_time = min(body.get_node("Timer").time_left, 0.1)
			body.get_node("Timer").start()
		elif body.is_in_group("explosion_action"):
			var ret = body.on_activate()
			if ret is RigidBody2D:
				var vec = (ret.position - self.position) as Vector2
				var mag = vec.length()
				var force = power * (mag / (2 * explosion_radius) - 1)
				(ret as RigidBody2D).apply_central_impulse(- force * vec / mag)
		elif body.is_in_group("player"):
			var vec = (body.position - self.position) as Vector2
			var mag = vec.length()
			var force = power * (mag / (2 * explosion_radius) - 1) * body.mass
			(body as RigidBody2D).apply_central_impulse(- force * vec / mag)
		elif body is RigidBody2D:
			var vec = (body.position - self.position) as Vector2
			var mag = vec.length()
			var force = power * (mag / (2 * explosion_radius) - 1)
			(body as RigidBody2D).apply_central_impulse(- force * vec / mag)
		elif body is KinematicBody2D:
			var vec = (body.position - self.position) as Vector2
			var mag = vec.length()
			var force = power * (mag / (2 * explosion_radius) - 1)
			var prevVel = body.velocity
			body.velocity += - force * vec / mag
			#print(vec, " ", mag, " ", force, " ", - force * vec / mag, " ", prevVel, " ", body.velocity)
	var ring = load("res://scenes/Circle.tscn").instance() as MeshInstance2D
	ring.position = position
	ring.scale.x = explosion_radius
	ring.scale.y = explosion_radius
	get_parent().add_child(ring)
			

