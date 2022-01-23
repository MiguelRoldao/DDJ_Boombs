extends Node2D

func _ready():
	LivesCounter.lives = 3
	
func _physics_process(delta):
	if LivesCounter.lives == 2:
		$Live1.hide()
	if LivesCounter.lives == 1:
		$Live2.hide()
	if LivesCounter.lives == 0:
		get_tree().reload_current_scene()
