extends Control

@onready var options_menu = $Options
@onready var margin_container = $MarginContainer


func _ready():
	options_menu.back_options.connect(back_options_menu)
	margin_container.visible = true
	options_menu.visible = false

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/environment/world.tscn")


func _on_quit_pressed():
	get_tree().quit()


func _on_options_pressed():
	margin_container.visible = false
	options_menu.set_process(true)
	options_menu.visible = true

func back_options_menu() -> void:
	margin_container.visible = true
	options_menu.visible = false