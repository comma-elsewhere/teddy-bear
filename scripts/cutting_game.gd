class_name ScalpelRoot extends Node2D

@onready var plush_fur: Sprite2D = %PlushFur
@onready var start_zone: Area2D = %StartZone
@onready var true_line: Line2D = %TrueLine
@onready var cut_line: Line2D = %CutLine


func _ready() -> void:
	start_zone.input_event.connect(_mouse_event)
	
func _mouse_event() -> void:
	pass
	
func _cut_fabric(line: Line2D) -> void:
	var image := plush_fur.texture.get_image()
	var bitmap := BitMap.new()
	# Create bitmap from the Sprite2D texture image
	bitmap.create_from_image_alpha(image)
	# generate the polygons
	var polygons := bitmap.opaque_to_polygons(image.get_used_rect())
	# offset the line to SIZE pixels (inflate) to convert it to polygons
	var polyline := Geometry2D.offset_polyline(line.points, 100, Geometry2D.JOIN_ROUND, Geometry2D.END_ROUND)
	for polygon in polygons:
		# clip each polygon from the Sprite2D image with the polyline
		var splits := Geometry2D.clip_polygons(polygon, polyline[0])
		for i in len(splits):
			# For each split create a new Polygon2D with the Sprite2D texture
			var poly := Polygon2D.new()
			poly.polygon = splits[i]
			poly.texture = plush_fur.texture
			add_child(poly)
	# Hide original sprite
	plush_fur.hide()
