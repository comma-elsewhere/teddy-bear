class_name NavArea extends Area2D

signal area_clicked(index: int)

var _collision: Array = []

func _ready() -> void:
	input_pickable = true
	add_to_group("NavArea")
	input_event.connect(_input_event_click)
	
	_collision.append_array(get_children())
	
	if _collision.size() < 2:
		push_error("NavArea Collider children not found")
	toggle_collision()
	
func toggle_collision(enable_shape_1: bool = true) -> void:
	_collision[0].disabled = !enable_shape_1
	_collision[1].disabled = enable_shape_1
	
func _input_event_click(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		area_clicked.emit(get_index())
