class_name ToyDetails extends Resource

@export var patient_file: PatientFile

# Toy body part textures and their offset from the body part parent (to look natural)
@export var textures: Array[AtlasTexture] = [] # Torso closed, torso open, left arm, left leg, right arm, right leg, head
@export var texture_offsets: Array[Vector2] = [Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO]

# Toy damage/problems for repair
@export var dirty_or_stain: bool = false # Clean in laundry machine after cutting open to remove the heart aka "Internal Electronics"
@export var dirt: Color = Color("ffffff") 
@export var stains: Color = Color("ffffff")
@export var open_hole: Array[bool] = [] # bool for holes that need to be stitched
@export var missing_item: Array[ItemRes] = [] # for items missing from toy
@export var exterior_contam: Array[ItemRes] = [] # for contaminants on toy exterior 
@export var interior_contam: Array[ItemRes] = [] # for contaminants inside the toy

enum BODY_PARTS {TORSO, LEFT_ARM, LEFT_LEG, RIGHT_ARM, RIGHT_LEG, HEAD}

const PART_COUNT := 6

var has_heart: bool = true

func _init() -> void:
	open_hole.resize(PART_COUNT)
