class_name ItemData
extends Resource

@export var parent_toy: String = ""
@export var item_name: String = ""
@export var goes_on_neck: bool = false
@export var texture: AtlasTexture
@export var alt_texture: AtlasTexture = null

func get_uid() -> String:
	return parent_toy.to_snake_case() + "_" + item_name.to_snake_case()
