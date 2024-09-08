extends Control

var code

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(get_process_delta_time()).timeout
	code = str($"../../Hidden/PinI".text) + str($"../../Hidden/PinII".text)\
 + str($"../../Hidden/PinIII".text) + str($"../../Hidden/PinIV".text)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		$Text.focus_mode = FOCUS_NONE
		$Text.focus_mode = FOCUS_ALL
		hide()
		for node in $"..".get_overlapping_bodies():
			if "Player" in node.name:
				node.can_move = true
				node.z_index = 1


func _on_text_text_submitted(new_text):
	if str(new_text) == str(code):
		$Result.text = "Access Granted!"
		await get_tree().create_timer(1.0).timeout
		hide()
		for node in $"..".get_overlapping_bodies():
			if "Player" in node.name:
				SignalBus.undoomed.emit()
	else:
		$Result.text = "Access Denied!"
	
	$Text.clear()
