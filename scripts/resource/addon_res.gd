class_name AddonRes extends Resource

@export var texture: Texture2D
@export var scale: Vector2 = Vector2.ONE
@export_enum("None", 
"Tummy", "Neck", "LeftHead", 
"RightHead", "LeftHand", "RightHand", 
"LeftArm", "RightArm", "LeftLeg", 
"RightLeg", "LeftFoot", "RightFoot") var placement: int = 0

var position: Vector2
var drop_group: String

const DROP_POS: Array[Vector2] = [
	Vector2.ZERO, # Center
	Vector2(0, 60), # Torso
	Vector2(0, -110), # Neck 
	Vector2(-50, -50), # Left head
	Vector2(50, -50), # Right head
	Vector2(0, 85), # Left hand
	Vector2(0, 85), # right hand
	Vector2(0, 30), # left arm
	Vector2(0, 30), # right arm
	Vector2(0, 15), # left leg
	Vector2(0, 15), # right leg
	Vector2(0, 115), # left foot
	Vector2(0, 115), # right foot
]

const GROUPS: Array[String] = ["None", "Tummy", "Neck", "LeftHead", "RightHead", "LeftHand", 
"RightHand", "LeftArm", "RightArm", "LeftLeg", "RightLeg", "LeftFoot", "RightFoot"]

func _init() -> void:
	position = DROP_POS[placement]
	drop_group = GROUPS[placement]
