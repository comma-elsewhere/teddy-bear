extends InteractionArea

@onready var chute_animate: AnimationPlayer = $ChuteAnimate

var chute_up: bool = false

func _ready() -> void:
	create_collision(80)
	input_pickable = true
	input_event.connect(_mouse_event)
	start()

func _mouse_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_MASK_LEFT:
		if event.pressed:
			input_pickable = false
			chute_up = !chute_up
			
			if chute_up:
				chute_animate.play("slide_chute")
			else:
				chute_animate.play_backwards("slide_chute")
				
				
func _on_chute_animate_animation_finished(anim_name: StringName) -> void:
	if anim_name == "slide_chute":
		input_pickable = true
