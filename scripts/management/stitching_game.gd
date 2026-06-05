extends Node2D

const ICON = preload("uid://ri3unyksjwas")

signal game_done(well_done: bool)

# max and min sizes for the polygon, stepped by 50
@export_range(50, 450, 50) var min_radius: float = 100.0
@export_range(100, 500, 50) var max_radius: float = 300.0

@onready var stuffing: Sprite2D = $Stuffing # the texture the polygon is created from
@onready var rope_interaction: RopeInteraction = $RopeInteraction
@onready var sewing_needle: Marker2D = $SewingNeedle

const POINT_DIV := 3
const CENTER := 512.0 # the point the polygon is centered on
const ROPE_LERP := 0.1

# polygon hole shape
var fabric_hole: Polygon2D = null
# polygon outline
var outline: Line2D = null

func _ready() -> void:
	sewing_needle.global_position = Vector2(CENTER, CENTER)
	var sides := randi_range(9, 18)
	fabric_hole = _create_polygon(sides) # creates polygon with this range of possible sides
	_show_hole() # displays created polygon texture of stuffing in hole shape
	var point_array := _create_outline(sides)
	for i in len(point_array): # returns array of points to attach thread at
		var new_area: RopeArea = _attach_rope_area(i, point_array)
		new_area.input_event.connect(_mouse_event.bind(new_area))
		new_area.area_entered.connect(_rope_area_entered)
		
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if rope_interaction.rope != null and rope_interaction.enable == true:
			sewing_needle.global_position = sewing_needle.global_position.lerp(get_global_mouse_position(), ROPE_LERP)
			rope_interaction.on_movement_request.emit()
	else:
		rope_interaction.enable = false
		sewing_needle.global_position = Vector2(CENTER, CENTER)
	
func _mouse_event(_viewport: Node, event: InputEvent, _shape_idx: int, area: RopeArea) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			rope_interaction.enable = true
			rope_interaction.set_rope(area.get_rope())
	
func _rope_area_entered(area: Area2D) -> void:
	if area.is_in_group("RopeEnd"):
		if rope_interaction.rope == null:
			return
		area.get_parent().get_parent().set_handle(rope_interaction.rope)
		rope_interaction.set_rope(null)
	
func _spawn_stitch_hole_sprite(pos: Vector2) -> void:
	var sprite := Sprite2D.new()
	sprite.texture = ICON
	sprite.apply_scale(Vector2(0.5, 0.5))
	sprite.centered = true
	add_child(sprite)
	sprite.global_position = pos
	
func _attach_rope_area(index: int, pos: Array[Vector2]) -> RopeArea:
	#_spawn_stitch_hole_sprite(pos[index])
	var new_area := RopeArea.new()
	add_child(new_area)
	new_area.global_position = pos[index]
	var length: float = 0
	while length <= 5:
		length = pos[index].distance_to(pos.pick_random())
	new_area.set_rope(length)
	
	return new_area
	
func _create_outline(side_count: int) -> Array[Vector2]:
	# create outline line
	outline = Line2D.new()
	add_child(outline)
	outline.points = fabric_hole.polygon
	outline.closed = true
	outline.hide()
	
	var points: Array[Vector2] = []
	for i in range(int(float(side_count) / POINT_DIV)):
		var rand_num: int = randi_range(0, (outline.points.size() -1))
		var new_point: Vector2 = outline.to_global(outline.get_point_position(rand_num))
		if !points.has(new_point):
			points.append(new_point)
	
	return points
	
	
# intersects created polygon with bitmap from fabric texture to show stuffing in intersection area
func _show_hole() -> void:
	var image = stuffing.texture.get_image()
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(image)
	var polygons = bitmap.opaque_to_polygons(image.get_used_rect())
	for polygon in polygons:
		var splits := Geometry2D.intersect_polygons(polygon, fabric_hole.polygon)
		for i in len(splits):
			var poly := Polygon2D.new()
			poly.texture = stuffing.texture
			poly.polygon = splits[i]
			#poly.global_position = CENTER
			add_child(poly)
			
	fabric_hole.hide()
	stuffing.hide()
	
	
# Creates a rounded polygon with a set number of sides and returns the polygon shape
func _create_polygon(sides: int) -> Polygon2D:
	var new_points: PackedVector2Array = []
	
	for i in range(sides):
		# Calculate the angle for each vertex
		var angle: float = (i / float(sides)) * 2.0 * PI
		
		# Generate a randomized radius for that angle
		var radius: float = randf_range(min_radius, max_radius)
		
		# Convert polar coordinates to Cartesian space
		var x: float = cos(angle) * radius
		var y: float = sin(angle) * radius
		new_points.append(Vector2(x + CENTER, y + CENTER))
		
	# Apply the points to the polygon
	var poly := Polygon2D.new()
	poly.polygon = new_points
	add_child(poly)
	return poly
