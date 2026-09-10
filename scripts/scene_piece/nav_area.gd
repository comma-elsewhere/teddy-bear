class_name NavArea extends Area2D

signal area_clicked()

@onready var collision_shape_1: CollisionShape2D = $CollisionShape2D1
@onready var collision_shape_2: CollisionShape2D = $CollisionShape2D2

func _ready() -> void:
	input_pickable = true
	add_to_group("NavArea")
	input_event.connect(_input_event_click)
	toggle_collision()
	
func toggle_collision(enable_shape_1: bool = true) -> void:
	collision_shape_1.disabled = !enable_shape_1
	collision_shape_2.disabled = enable_shape_1
	
func _input_event_click(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		area_clicked.emit()
