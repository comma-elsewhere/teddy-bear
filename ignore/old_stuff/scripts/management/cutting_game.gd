class_name ScalpelRoot extends Node2D

signal game_done(well_done: bool)

@onready var plush_fur: Sprite2D = %PlushFur
@onready var start_zone: Area2D = %StartZone
@onready var true_line: Line2D = %TrueLine
@onready var cut_line: Line2D = %CutLine

const MIN_DIST := 15.0
const CUT_WIDTH := 75.0

func _ready() -> void:
	start_zone.input_event.connect(_mouse_event)
	true_line.clear_points()
# randomizes line
	true_line.add_point(Vector2(randi_range(100, 600), 0))
	true_line.add_point(Vector2(randi_range(100, 900), 1024))
	
# cuts fabric when mouse is released, no matter where on screen
func _input(event: InputEvent) -> void:
	if cut_line.points.is_empty():
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if !event.pressed:
			_cut_fabric(cut_line)
	
# only records mouse input for cutting while in draw area
func _mouse_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if cut_line.points.is_empty():
			cut_line.add_point(cut_line.get_local_mouse_position())
			return
		if cut_line.get_local_mouse_position().distance_squared_to(cut_line.points[cut_line.points.size() - 1]) < MIN_DIST:
			return
		cut_line.add_point(cut_line.get_local_mouse_position())
	
func _cut_fabric(line: Line2D) -> void:
	var image := plush_fur.texture.get_image()
	var bitmap := BitMap.new()
	# Create bitmap from the Sprite2D texture image
	bitmap.create_from_image_alpha(image)
	# generate the polygons
	var polygons := bitmap.opaque_to_polygons(image.get_used_rect())
	# offset the line to SIZE pixels (inflate) to convert it to polygons
	var polyline := Geometry2D.offset_polyline(line.points, CUT_WIDTH, Geometry2D.JOIN_ROUND, Geometry2D.END_ROUND)
	for polygon in polygons:
		# clip each polygon from the Sprite2D image with the polyline
		var splits := Geometry2D.clip_polygons(polygon, polyline[0])
		for i in len(splits):
			# For each split create a new Polygon2D with the Sprite2D texture
			var poly := Polygon2D.new()
			poly.polygon = splits[i]
			poly.texture = plush_fur.texture
			add_child(poly)
	# Hide original sprite and cutline
	plush_fur.hide()
	cut_line.hide()
	game_done.emit(_grade_lines(cut_line, true_line))
		
func _grade_lines(line_a: Line2D, line_b: Line2D) -> bool:
	var follow_count: int = 0
	var line_length: float = 0
	
	if line_a.to_global(line_a.points[0]).distance_to(line_b.to_global(line_b.points[0])) < CUT_WIDTH:
		follow_count += 1
	if line_a.to_global(line_a.points[line_a.points.size() - 1]).distance_to(line_b.to_global(line_b.points[1])) < CUT_WIDTH:
		follow_count += 1
	
	for i in range((line_a.points.size()) - 1):
		line_length += line_a.points[i].distance_to(line_a.points[i+1])
		
	print(follow_count, line_length)
		
	if follow_count < 2 or line_length > line_b.points[0].distance_to(line_b.points[1]) * 1.01:
		return false
	return true
