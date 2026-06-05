extends Node2D

const ICON = preload("uid://ri3unyksjwas")

signal game_done(well_done: bool)

# max and min sizes for the polygon, stepped by 50
@export_range(50, 450, 50) var min_radius: float = 100.0
@export_range(100, 500, 50) var max_radius: float = 300.0

@onready var stuffing: Sprite2D = $Stuffing # the texture the polygon is created from

const POINT_DIV := 3
const TAN_ANGLE := deg_to_rad(20.0)
const CENTER := 512.0 # the point the polygon is centered on

# polygon hole shape
var fabric_hole: Polygon2D = null
# polygon outline
var outline: Line2D = null

func _ready() -> void:
	var sides := randi_range(9, 18)
	fabric_hole = _create_polygon(sides) # creates polygon with this range of possible sides
	_show_hole() # displays created polygon texture of stuffing in hole shape
	for stitch_point in _create_outline(sides): # returns array of points to attach thread at
		var new_area: Area2D = _attach_rope_area(stitch_point)
		new_area.input_event.connect(_mouse_event.bind(new_area))
		new_area.area_entered.connect(_rope_area_entered)
	
func _mouse_event(_viewport: Node, event: InputEvent, _shape_idx: int, area: Area2D) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			area.show()
	
func _rope_area_entered(area: Area2D) -> void:
	pass
	
func _spawn_stitch_hole_sprite(pos: Vector2) -> void:
	pass
	
func _attach_rope_area(pos: Vector2) -> Area2D:
	_spawn_stitch_hole_sprite(pos)
	return null
	
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
		points.append(outline.to_global(outline.get_point_position(rand_num)))
	
	for point in points:
		var sprite := Sprite2D.new()
		sprite.texture = ICON
		sprite.apply_scale(Vector2(0.5, 0.5))
		sprite.centered = true
		add_child(sprite)
		sprite.global_position = point
	
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
