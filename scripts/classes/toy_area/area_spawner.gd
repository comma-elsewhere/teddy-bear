class_name AreaSpawner

enum BOOLS {ACCESSORY, STAIN, RIP}
enum PART {TORSO, LEFT_ARM, LEFT_LEG, RIGHT_ARM, RIGHT_LEG, HEAD}

const TORSO_POINTS : Array[Transform2D] = [Transform2D(0.0, Vector2(0,0)), ]
const ARM_POINTS : Array[Transform2D] = [Transform2D(0.0, Vector2(0,0)), ]
const LEG_POINTS : Array[Transform2D] = [Transform2D(0.0, Vector2(0,0)), ]
const HEAD_POINTS : Array[Transform2D] = [Transform2D(0.0, Vector2(0,0)), ]

func initiate(area_bools: Array[bool], bodies: Array[RigidBody2D]) -> void:
	pass
