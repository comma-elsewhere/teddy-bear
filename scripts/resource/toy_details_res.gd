class_name ToyDetails extends Resource

@export var patient_file: PatientFile

@export var textures: Array[AtlasTexture] = [] # Torso closed, torso open, left arm, left leg, right arm, right leg, head
@export var texture_offsets: Array[Vector2] = [Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO]

@export var extra_attached: bool = false
@export var stain: bool = false
@export var rip: bool = false
@export var dirty: bool = false # Clean in laundry machine
@export var debris: bool = false
