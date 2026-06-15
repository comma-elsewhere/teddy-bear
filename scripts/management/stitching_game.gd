extends Node2D

const ICON = preload("uid://ri3unyksjwas")

signal game_done(well_done: bool)

# max and min sizes for the polygon, stepped by 50
@export_range(50, 450, 50) var min_radius: float = 100.0
@export_range(100, 500, 50) var max_radius: float = 250.0

@onready var stuffing: Sprite2D = $Stuffing # the texture the polygon is created from

const POINT_DIV := 3
const CENTER := 512.0 # the point the polygon is centered on
const ROPE_LERP := 0.1
# polygon hole shape
var fabric_hole: Polygon2D = null
# polygon outline
var outline: Line2D = null

func _ready() -> void:
	var sides := randi_range(9, 18)
	fabric_hole = _create_polygon(sides) # creates polygon with this range of possible sides
	_show_hole() # displays created polygon texture of stuffing in hole shape
	var point_array := _create_outline(sides)
	for i in len(point_array): # returns array of points to attach thread at
		var new_area: RopeArea = _attach_rope_area(i, point_array)
		
	
func _spawn_stitch_hole_sprite() -> Sprite2D:
	var sprite := Sprite2D.new()
	sprite.texture = ICON
	sprite.apply_scale(Vector2(0.5, 0.5))
	sprite.centered = true
	sprite.show_behind_parent = true
	return sprite
	
func _attach_rope_area(index: int, pos: Array[Vector2]) -> RopeArea:
	var new_area := RopeArea.new()
	add_child(new_area) # initiate ropearea on ready
	new_area.global_position = pos[index] # set global position relative to index
	var length: float = 0
	while length <= 5 or length >= 200:
		length = pos[index].distance_to(pos.pick_random()) # pick a random other point and length to the distance between them
	new_area.set_rope(length) # set rope length to length
	if index != 0: # if not the first rope, hide
		new_area.hide()
	
	new_area.add_child(_spawn_stitch_hole_sprite()) # returns a new sprite at position and adds as child to rope
	
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
