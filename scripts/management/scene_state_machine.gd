class_name SceneStateMachine extends Node

enum STATE {MAIN, TERMINAL, BENCH, CHUTE}

@onready var room_layer: CanvasLayer = %RoomLayer
@onready var terminal_layer: CanvasLayer = %TerminalLayer
@onready var bench_layer: CanvasLayer = %BenchLayer
@onready var chute_layer: CanvasLayer = %ChuteLayer

@onready var terminal_nav: PanelContainer = %TerminalNav
@onready var bench_nav: PanelContainer = %BenchNav
@onready var chute_nav: PanelContainer = %ChuteNav

@onready var anim_sfx: AnimationPlayer = %AnimSFX

var state: int = -1
