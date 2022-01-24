tool
extends Node2D


export(int) var path = 16
export(int) var length = 8
export(int) var speed = 8	# pixels per second

var state = false
var displacement = 0.0



func _ready():
	resize()


func _process(delta):
	if Engine.editor_hint:
		resize()
		return
	
	if state:
		if displacement != 0.0:
			displacement = clamp(displacement - speed * delta, 0.0, float(path))
	else:
		if displacement != float(path):
			displacement = clamp(displacement + speed * delta, 0.0, float(path))
			
	$IronGate.position.y = displacement
	
func toggle():
	state = not state

func resize():
	var tex_rect = $IronGate/TextureRect
	tex_rect.margin_top = -length/2.0
	tex_rect.margin_bottom = length/2.0
	$IronGate/CollisionShape2D.shape.extents.y = length/2.0
	$IronGate/CollisionShape2D.position.y = -0.5 if length%2 != 0 else 0




func _set_state(state):
	self.state = state
