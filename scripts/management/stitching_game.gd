extends Node2D

signal game_done(well_done: bool)

@export_range(50, 450, 50) var min_radius: float = 100.0
@export_range(100, 500, 50) var max_radius: float = 500.0

@onready var stuffing: Sprite2D = $Stuffing

const CENTER := Vector2(200, 200)

var fabric_hole: Polygon2D = null

func _ready() -> void:
	fabric_hole = _create_polygon(randi_range(6, 18))
	_show_hole()
	
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
			poly.global_position = CENTER
			add_child(poly)
			
	fabric_hole.hide()
	stuffing.hide()
	
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
		new_points.append(Vector2(x, y) + CENTER)
		
	# Apply the points to the polygon
	var poly := Polygon2D.new()
	poly.polygon = new_points
	add_child(poly)
	return poly
