class_name MiniGame extends Node2D

signal minigame_complete()

@onready var button: Button = $CanvasLayer/ColorRect/Button

func _ready() -> void:
	button.pressed.connect(_finished)

func set_res(new_res: Array[AddonRes]) -> void:
	if new_res.is_empty():
		return

func _finished() -> void:
	print("I tried")
	minigame_complete.emit()
