extends Control

var codes = ["8192", "5655", "3087"]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		$Text.focus_mode = FOCUS_NONE
		$Text.focus_mode = FOCUS_ALL


func _on_text_text_submitted(new_text):
	if new_text in codes:
		$Result.text = "Access Granted!"
	else:
		$Result.text = "Access Denied!"
	
	$Text.clear()
