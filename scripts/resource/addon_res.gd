class_name AddonRes extends Resource

@export var texture: Texture2D
@export var scale: Vector2 = Vector2.ONE
@export_enum("None", "Tummy", "Neck", "Head", "Arm", "Hand", "Leg", "Foot") var placement: int = 0

const DROP_POS: Array[Vector2] = [
	Vector2.ZERO, # Center
	Vector2(0, 60), # Torso
	Vector2(0, -110), # Neck 
	Vector2(0, -50), # head
	Vector2(0, 30), # arm
	Vector2(0, 85), # hand
	Vector2(0, 15), # leg
	Vector2(0, 115), # foot
]

const GROUPS: Array[String] = ["None", "Tummy", "Neck", "Head", "Arm", "Hand", "Leg", "Foot"]

func get_position() -> Vector2:
	return DROP_POS[placement]
	
func get_group() -> String:
	return GROUPS[placement]
