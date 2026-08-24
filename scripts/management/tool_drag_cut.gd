extends ToolDrag

@export var activation_area: InteractionArea

func _ready() -> void:
	super()
	hide()
	activation_area.activate.connect(_show_self)
	
func _show_self() -> void:
	show()
