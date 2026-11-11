extends Backdrop

@onready var tool_mother: Node2D = $ToolMother

func _ready() -> void:
	for tool in tool_mother.get_children():
		if tool.has_method("toggle_monitor"):
			tool.toggle_monitor(false)
		else:
			push_error("Foreign Node in the BenchTop ToolMother")

func enter_backdrop() -> void:
	super()
	for tool in tool_mother.get_children():
		if tool.has_method("toggle_monitor"):
			tool.toggle_monitor(true)
		else:
			push_error("Foreign Node in the BenchTop ToolMother")
	
func exit_backdrop() -> void:
	super()
	for tool in tool_mother.get_children():
		if tool.has_method("toggle_monitor"):
			tool.toggle_monitor(false)
		else:
			push_error("Foreign Node in the BenchTop ToolMother")
	
func unlock_scalpel() -> void:
	return
