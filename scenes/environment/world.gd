extends Node2D

@onready var pause_menu = $CanvasLayer/Pause
var paused = false

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		pauseMenu()

func pauseMenu():
	if paused:
		pause_menu.visible = false
		Engine.time_scale = 1
		#get_tree().paused = true
	else:
		pause_menu.visible = true
		Engine.time_scale = 0
	
	paused = !paused
