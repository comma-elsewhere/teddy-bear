extends Node2D

@onready var backdrops: Node = %Backdrops
@onready var navigation: Node = %Navigation
@onready var hook: Sprite2D = $Hook

enum NAV {TOP, LEFT, RIGHT, BOTTOM}
enum BD {TERMINAL, CHUTE, BENCH_BOT, BENCH_TOP, MAIN_ROOM}

var bd_array: Array[Backdrop] = []
var nav_array: Array[NavArea] = []

var current_bd: Backdrop = null

func _ready() -> void:
	for child in backdrops.get_children():
		var bd: Backdrop = child as Backdrop
		bd.hide()
		bd_array.append(bd)
	
	for child in navigation.get_children():
		var nav: NavArea = child as NavArea
		nav.area_clicked.connect(_nav_clicked)
		nav_array.append(nav)
		
	_change_state(BD.MAIN_ROOM)

func _process(delta: float) -> void:
	if current_bd == null:
		return
	current_bd.tick_backdrop(delta)

func _nav_clicked(index: int) -> void:
	match index:
		NAV.TOP: 
			if _get_bd_index() == BD.BENCH_BOT or _get_bd_index() == BD.MAIN_ROOM:
				_change_state(BD.BENCH_TOP)
			elif _get_bd_index() == BD.BENCH_TOP:
				_change_state(BD.BENCH_BOT)
			else: return
		
		NAV.LEFT:
			if _get_bd_index() == BD.CHUTE:
				_change_state(BD.BENCH_TOP)
			elif _get_bd_index() == BD.TERMINAL:
				_change_state(BD.CHUTE)
			else:
				_change_state(BD.TERMINAL)
		NAV.RIGHT: 
			if _get_bd_index() == BD.CHUTE:
				_change_state(BD.TERMINAL)
			elif _get_bd_index() == BD.TERMINAL:
				_change_state(BD.BENCH_TOP)
			else:
				_change_state(BD.CHUTE)
		NAV.BOTTOM: 
			if _get_bd_index() == BD.MAIN_ROOM: return
			else: _change_state(BD.MAIN_ROOM)

func _get_bd_index() -> int:
	if current_bd == null:
		return -1
	else:
		return current_bd.get_index()

func _change_state(new_index: int) -> void:
	if current_bd != null:
		current_bd.exit_backdrop()
		
	if _get_bd_index() == BD.MAIN_ROOM:
		for nav in nav_array:
			nav.toggle_collision(false)
		
	current_bd = bd_array[new_index]
	current_bd.enter_backdrop()
	
	if _get_bd_index() == BD.MAIN_ROOM:
		for nav in nav_array:
			nav.toggle_collision(true)
		
