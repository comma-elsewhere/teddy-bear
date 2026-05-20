class_name PopupArea extends DropArea

 # preload scenes for the popup scenes
const CUTTING_GAME := preload("uid://bauxpoy27ihxe")
const REMOVAL_EXTERIOR := preload("uid://cbt72jkdrbh2b")
const REMOVAL_INTERIOR := preload("uid://ngx8msl71kep")
const STITCHING_GAME := preload("uid://b2u01ri738q46")

# Need same groups in tool drag
enum TYPE {REMOVE, CUT, STITCH, INT, EXT}
const GROUP: Array[String] = ["RemovePopup", "CutPopup", "StitchPopup", "Interior", "Exterior"]

var popup_preload: PackedScene = null # Set before ready by area spawner
var addon_res: Array[AddonRes] = [] # optional set by area spawner

func _ready() -> void:
	enable_area(false) # disallow interaction until threshhold met
	create_collision(RADIUS)
	start()

func initiate_removal_exterior(item_res: AddonRes) -> void:
	add_to_group(GROUP[TYPE.REMOVE])
	add_to_group(GROUP[TYPE.EXT])
	popup_preload = REMOVAL_EXTERIOR
	addon_res = [item_res]
	_add_sprite(item_res)
	
func initiate_removal_interior(item_array: Array[AddonRes]) -> void:
	add_to_group(GROUP[TYPE.REMOVE])
	add_to_group(GROUP[TYPE.INT])
	popup_preload = REMOVAL_INTERIOR
	addon_res = item_array
	
func initiate_cutting_popup() -> void:
	add_to_group(GROUP[TYPE.CUT])
	add_to_group(GROUP[TYPE.EXT])
	popup_preload = CUTTING_GAME
	
func initiate_stitching_popup(damage_res: AddonRes = null) -> void:
	add_to_group(GROUP[TYPE.STITCH])
	add_to_group(GROUP[TYPE.EXT])
	popup_preload = STITCHING_GAME
	if damage_res != null:
		_add_sprite(damage_res)

# enable/disable area from interaction with other things
func enable_area(enable: bool) -> void:
	monitorable = enable
	monitoring = enable
	
# Call via tool drag area entered & is in group("whatever")
func create_popup() -> void:
	get_parent().set_deferred("freeze", true) # prevent parent from moving while popup is open
	# create popup
	var viewport_display := Sprite2D.new()
	var viewport := SubViewport.new()
	var popup: MiniGame = popup_preload.instantiate() as MiniGame
	add_child(viewport)
	viewport.add_child(popup)
	# Subviewport settings yeesh
	viewport.size = Vector2(512, 512)
	viewport.size_2d_override = Vector2(1024, 1024)
	viewport.size_2d_override_stretch = true
	viewport.handle_input_locally = true
	#viewport.physics_object_picking = true
	#viewport.physics_object_picking_sort = true
	#viewport.physics_object_picking_first_only = true
	viewport.canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	add_child(viewport_display)
	viewport_display.texture = viewport.get_texture() # set display texture to subviewport texture
	popup.minigame_complete.connect(remove_self) # when minigame is complete, remove the whole area
	popup.set_res(addon_res) # pass through addon res to the popup scene
	viewport_display.set_visibility_layer_bit(4, true)
	
func remove_self() -> void:
	if is_in_group(GROUP[TYPE.CUT]): # if you just cut the toy open, enable removing things from the interior
		get_tree().call_group(GROUP[TYPE.INT], "enable_area", true)
	get_parent().freeze = false # allow parent to move again
	# Remove self from scene tree
	get_parent().remove_child(self)
	call_deferred("queue_free")
	
# display sprite based on addon res
func _add_sprite(res: AddonRes) -> void:
	var sprite := Sprite2D.new()
	sprite.texture = res.texture
	sprite.apply_scale(res.scale)
	add_child(sprite)
	
	
	
	
