@tool
extends Node

@export var sheet_id: String = "YOUR_SHEET_ID"
@export var gid: String = "0"
@export var output_path: String = "user://data.csv"
@export var update_on_start: bool = true
@export_tool_button("Update CSV") var update_button: Callable = update_csv

var _http: HTTPRequest = null


func _ready() -> void:
	if update_on_start and not Engine.is_editor_hint():
		update_csv()


func update_csv() -> void:
	if _http != null:
		push_warning("CSV update already in progress.")
		return

	_http = HTTPRequest.new()
	_http.timeout = 15.0
	_http.request_completed.connect(_on_request_completed)
	add_child(_http)  # Unowned child, so it is not saved into the scene in the editor.

	var url := "https://docs.google.com/spreadsheets/d/%s/export?format=csv&gid=%s" % [sheet_id, gid]
	var err := _http.request(url)
	if err != OK:
		_fail("Request failed to start (error %d)." % err)


func _on_request_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	_http.queue_free()
	_http = null

	if result != HTTPRequest.RESULT_SUCCESS or response_code != 200:
		push_error("CSV download failed: result %d, HTTP %d." % [result, response_code])
		return

	var text := body.get_string_from_utf8().strip_edges()
	if text.begins_with("<!DOCTYPE") or text.begins_with("<html"):
		push_error("Received HTML instead of CSV. Check the sheet's sharing settings.")
		return

	var file := FileAccess.open(output_path, FileAccess.WRITE)
	if file == null:
		push_error("Cannot open %s (error %d)." % [output_path, FileAccess.get_open_error()])
		return

	file.store_buffer(body)
	file.close()
	print("CSV updated: ", ProjectSettings.globalize_path(output_path))


func _fail(message: String) -> void:
	push_error(message)
	if _http != null:
		_http.queue_free()
		_http = null
