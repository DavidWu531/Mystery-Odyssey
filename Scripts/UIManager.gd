extends CanvasLayer

var quests = { 
	"Talk to the NPC": 1,  # Max 1
	"Collect Coins": 10,  # Max 10
	#"Talk to Pil": 1,
	#"Activate Gravity Flip Mode": 1,
	#"Escape the maze": 1,
}

var banner = preload("res://Scenes/achievement_banner.tscn")
var scroll_tip_id = 0

var npci_dialogue_id = 0

var quests_completed = 0
var current_quest = quests.keys()[quests_completed]
var current_quest_max = quests.get(current_quest)
var current_quest_progress = 0

func _ready():
	SignalBus.npc_talked.connect(npc_talked)
	SignalBus.coin_collected.connect(coin_collected)
	SignalBus.achievement_completed.connect(achievement_completed)
	
	SignalBus.default_silhouette.connect(default_silhouette)
	SignalBus.double_jump_silhouette.connect(double_jump_silhouette)
	SignalBus.gravity_flip_silhouette.connect(gravity_flip_silhouette)
	SignalBus.linear_motion_silhouette.connect(linear_motion_silhouette)


func _process(delta):
	if quests_completed < 1:
		if current_quest_progress == current_quest_max:
			quests_completed += 1
			current_quest_progress = 0
			current_quest = quests.keys()[quests_completed]
			current_quest_max = quests.get(current_quest)
	
	if Input.is_action_just_pressed("ui_text_submit"):
		if $MainScreen/Quest.visible:
			$MainScreen/Quest.hide()
		else:
			$MainScreen/Quest.show()
	
	$MainScreen/Quest/Label.text = "Quest: \n" + str(current_quest) + "\n(" + str(current_quest_progress) + "/" + str(current_quest_max) + ")"
	
	$PauseMenu/Score.text = "Score: " + str(Global.score)
	
	$MainScreen/PlayerHealthOverlay.size = Vector2(Global.player_maxhealth * 38, 32)
	$MainScreen/PlayerHealth.size = Vector2(Global.player_health * 38, 32)
	
	$MainScreen/TimeElapsed.text = str(Global.time_elapsed).pad_decimals(2)
	
	Global.time_elapsed += delta
	
	$MainScreen/PlayerEnergy.max_value = 20
	$MainScreen/PlayerEnergy.value = Global.player_energy
	
	if Input.is_action_just_pressed("ui_focus_next"):
		$MainScreen/TutorialDialogue.show()
		if scroll_tip_id == 0:
			$MainScreen/TutorialDialogue/Label.text = "Falling too slow? Press S or Down Arrow to fall faster\n \
			Press Esc to dismiss message\nStuck on something? Press Tab to display tips"
		elif scroll_tip_id == 1:
			$MainScreen/TutorialDialogue/Label.text = "Press E or LMB to interact with objects with (!)\n \
			Press Esc to dismiss message\nStuck on something? Press Tab to display tips"
		elif scroll_tip_id == 2:
			$MainScreen/TutorialDialogue/Label.text = "You can't go back down a solid grass block, only up\n \
			Press Esc to dismiss message\nStuck on something? Press Tab to display tips"
		elif scroll_tip_id == 3:
			$MainScreen/TutorialDialogue/Label.text = "Press 1 to toggle between different torch beams\n \
			Press Esc to dismiss message\nStuck on something? Press Tab to display tips"
		elif scroll_tip_id == 4:
			$MainScreen/TutorialDialogue/Label.text = "Torches deplete your energy and shutoff when empty\n \
			Press Esc to dismiss message\nStuck on something? Press Tab to display tips"
		elif scroll_tip_id == 5:
			$MainScreen/TutorialDialogue/Label.text = "In gravity flip mode, jump to switch gravity\n \
			Press Esc to dismiss message\nStuck on something? Press Tab to display tips"
		
		if scroll_tip_id < 5:
			scroll_tip_id += 1
		else:
			scroll_tip_id = 0


func _on_continue_pressed():
	$PauseMenu.hide()
	get_tree().paused = false


func npc_talked():
	if current_quest == "Talk to the NPC":
		current_quest_progress += 1


func coin_collected():
	if current_quest == "Collect Coins":
		current_quest_progress += 1


func _on_ok_pressed():
	$MainScreen/Tutorial.hide()


func gravity_flip_silhouette():
	$MainScreen/PlayerFrame/AnimatedSprite2D.play("gravityflip")


func default_silhouette():
	$MainScreen/PlayerFrame/AnimatedSprite2D.play("default")
	
	
func double_jump_silhouette():
	$MainScreen/PlayerFrame/AnimatedSprite2D.play("doublejump")
	
	
func linear_motion_silhouette():
	$MainScreen/PlayerFrame/AnimatedSprite2D.play("linearmotion")
	

func achievement_completed():
	var new_banner = banner.instantiate()
	new_banner.position = Vector2(36,774)
	add_child(new_banner)

