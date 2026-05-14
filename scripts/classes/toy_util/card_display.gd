extends SubViewport

enum DETAILS {TOY_NAME, TOY_CODE, TOY_FACT}

const NAME := "My Name: "
const CODE := "PawzCode: "
const STATIC := "My Fun Fact!"

const PINK_TEXT := Color("ff52c2")
const BLUE_TEXT := Color("5294ffff")
const YELLOW_TEXT := Color("ffd452ff")

const PINK_BG := Color("ffb3e4ff")
const BLUE_BG := Color("b3d0ffff")
const YELLOW_BG := Color("fff7b3ff")

@onready var background: ColorRect = %Background
@onready var name_label: Label = %NameLabel
@onready var code_label: Label = %CodeLabel
@onready var fact_label: Label = %FunFactLabel
@onready var static_label: Label = %StaticLabel

func setup(patient_file: PatientFile) -> void:
	_set_colors()
	_set_labels([patient_file.product_name, str(patient_file.terminal_code), patient_file.marketing_line])
	#_set_labels(["TEST", "TEST", "testing testing one, two, three"])

func _set_labels(text: Array) -> void:
	name_label.text = NAME + text[DETAILS.TOY_NAME]
	code_label.text = CODE + text[DETAILS.TOY_CODE]
	static_label.text = STATIC
	fact_label.text = text[DETAILS.TOY_FACT]
	
func _set_colors() -> void:
	background.color = [PINK_BG, BLUE_BG, YELLOW_BG].pick_random()
	name_label.add_theme_color_override("font_color", [PINK_TEXT, BLUE_TEXT, YELLOW_TEXT].pick_random())
