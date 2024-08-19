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
				if $Achievements.visible:
					$Achievements.hide()
				get_tree().paused = false
				hide()
			else:
				get_tree().paused = true
				show()
	
	$Achievements/Progress.value = Global.achievement_completed
	$Achievements/Label.text = "Achievements Completed: " + str(Global.achievement_completed) + "/28"


func _on_achievement_pressed() -> void:
	$Achievements.show()
		
