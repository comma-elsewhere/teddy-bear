extends Node2D

@export var main_scene: PackedScene

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		get_tree().change_scene_to_packed(main_scene)
