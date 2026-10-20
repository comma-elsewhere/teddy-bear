extends Backdrop

func _ready() -> void:
	_reset()
	
func enter_backdrop() -> void:
	super()
	$ChuteLightRed.show()
	
func exit_backdrop() -> void:
	super()
	_reset()
	
func _reset() -> void:
	$ChuteLightGreen.hide()
	$ChuteInteractArea.hide()
	$ChuteDoor.position = Vector2.ZERO
