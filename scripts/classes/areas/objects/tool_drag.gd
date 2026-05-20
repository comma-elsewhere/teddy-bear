class_name ToolDrag extends DragArea

@export_enum("Remove", "Cut", "Stitch") var tool_target: int = 0
@export var texture: Texture2D

const GROUP: Array[String] = ["RemovePopup", "CutPopup", "StitchPopup"]

var tool_group: String

func _ready() -> void:
	var sprite := Sprite2D.new()
	sprite.texture = texture
	add_child(sprite)
	create_collision(float(sprite.texture.get_width())/2)
	reset_point = global_position
	_set_tool_group()
	area_entered.connect(_check_area)
	set_visibility_layer_bit(3, true)
	z_index = 10
	start()
	
func _set_tool_group() -> void:
	tool_group = GROUP[tool_target]

func _check_area(area: Area2D) -> void:
	if area.is_in_group(tool_group):
		area.create_popup()
