class_name  Options
extends Control

@onready var back_button = $MarginContainer/VBoxContainer/MarginContainer/back 

signal back_options

func _ready():
	back_button.button_down.connect(on_back_pressed)
	set_process(false)

func on_back_pressed() -> void:
	back_options.emit()
	set_process(false)
