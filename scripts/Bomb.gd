extends RigidBody2D

var explosion_radius = 32.0
var power = 400.0
var time = 3.0

var toExplode = false

func _ready():
	add_to_group("explosive")
	$Timer.start()

func _physics_process(delta):
	if toExplode:
		explode()
		queue_free()

func _on_Timer_timeout():
	print("bomb timeout")
	toExplode = true

func explode():
	for body in $Area2D.get_overlapping_bodies():
		if body == self:
			continue
		elif body.is_in_group("explosive"):
			body.toExplode = true
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
			print(vec, " ", mag, " ", force, " ", - force * vec / mag, " ", prevVel, " ", body.velocity)
	var ring = load("res://scenes/circle.tscn").instance() as MeshInstance2D
	ring.position = position
	ring.scale.x = explosion_radius
	ring.scale.y = explosion_radius
	get_parent().add_child(ring)
			
