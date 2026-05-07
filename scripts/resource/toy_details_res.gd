class_name ToyDetails extends Resource

@export var patient_file: PatientFile

@export var textures: Array[AtlasTexture] = [] # Torso closed, torso open, left arm, left leg, right arm, right leg, head
@export var texture_offsets: Array[Vector2] = [Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO]

@export var accessories: bool = false
@export var stained: bool = false
@export var ripped: bool = false
