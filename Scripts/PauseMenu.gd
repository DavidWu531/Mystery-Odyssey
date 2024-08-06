extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if $"../MainScreen/TutorialDialogue".visible:
			$"../MainScreen/TutorialDialogue".hide()
		else:
			if get_tree().paused:
				get_tree().paused = false
				hide()
			else:
				get_tree().paused = true
				show()
