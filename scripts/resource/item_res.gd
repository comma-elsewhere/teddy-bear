class_name ItemRes extends Resource

@export var texture: Texture2D
@export var scale: Vector2
@export_enum("None", 
"Torso", "Neck", "LeftHead", 
"RightHead", "LeftHand", "RightHand", 
"LeftArm", "RightArm", "LeftLeg", 
"RightLeg", "LeftFoot", "RightFoot") var drop_group: String = "None"
