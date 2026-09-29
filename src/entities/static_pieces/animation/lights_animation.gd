class_name LightsAnimationPlayer
extends AnimationPlayer

const MIN_TIME := 25
const MAX_TIME := 100
const ANIM_NAMES : Array[StringName] = [&"lights_flicker", &"lights_flicker_2"]

@onready var _random_timer := Timer.new()

func _ready() -> void:
	_random_timer.one_shot = true
	_random_timer.autostart = false
	add_child(_random_timer)
	_random_timer.timeout.connect(_play_lights_random)
	animation_finished.connect(_start_timer_random)
	
func _start_timer_random(_anim_name: StringName) -> void:
	_random_timer.start(randf_range( float(MIN_TIME), float(MAX_TIME) ))
	
func _play_lights_random() -> void:
	play(ANIM_NAMES.pick_random())
