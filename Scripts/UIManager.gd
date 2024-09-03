extends CanvasLayer

var quests = { 
	"Talk to an NPC": 1,  # Max 1
	"Collect Coins": 5,  # Max 5
	"Hit helpful blocks": 2,  # Max 2
	"Slay Enemies": 3,  # Max 3
	"Activate Gravity Flip Mode": 1,  # Max 1
	"Activate Double Jump Mode": 1,  # Max 1
	"Drop the tungsten cube in lava": 1  # Max 1
}

var banner = preload("res://Scenes/achievement_banner.tscn")
var scroll_tip_id = 0

var npci_dialogue_id = 0
var player_gamemode

var quests_completed = 0
var current_quest = quests.keys()[quests_completed]
var current_quest_max = quests.get(current_quest)
var current_quest_progress = 0

func _ready():
	SignalBus.npc_talked.connect(npc_talked)
	SignalBus.coin_collected.connect(coin_collected)
	SignalBus.achievement_completed.connect(achievement_completed)
	SignalBus.doomed.connect(doomed)
	SignalBus.undoomed.connect(undoomed)
	
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
	
	if Global.player_health <= 5:
		if Global.player_maxhealth <= 5:
			$MainScreen/PlayerHealthOverlay.size = Vector2(Global.player_maxhealth * 38, 31.6)
		else:
			$MainScreen/PlayerHealthOverlay.size = Vector2(190, 31.6)
		$MainScreen/PlayerHealth.size = Vector2(Global.player_health * 38, 31.6)
		$MainScreen/PlayerHealthText.hide()
	else:
		$MainScreen/PlayerHealthOverlay.size = Vector2(38, 31.6)
		$MainScreen/PlayerHealth.size = Vector2(38, 31.6)
		$MainScreen/PlayerHealthText.show()
	
	$MainScreen/PlayerHealthText.text = "x" + str(Global.player_health)
	
	$MainScreen/TimeElapsed.text = str(Global.time_elapsed).pad_decimals(2)
	
	Global.time_elapsed += delta
	
	$MainScreen/Energy/PlayerEnergy.max_value = 50
	$MainScreen/Energy/PlayerEnergy.value = Global.player_energy
	
	$MainScreen/Speed/PlayerSpeed.value = Global.player_speed
	
	if Input.is_action_just_pressed("ui_focus_next"):
		$MainScreen/TutorialDialogue.show()
		match scroll_tip_id:
			0:
				$MainScreen/TutorialDialogue/Label.text = "Falling too slow? Press S or Down Arrow to fall faster\n \
				Press Esc to dismiss message\nStuck on something? Press Tab to display tips"
			1:
				$MainScreen/TutorialDialogue/Label.text = "Press E to interact with objects with (!)\n \
				Press Esc to dismiss message\nStuck on something? Press Tab to display tips"
			2:
				$MainScreen/TutorialDialogue/Label.text = "Leaf blocks are only passable from below\n \
				Press Esc to dismiss message\nStuck on something? Press Tab to display tips"
			3:
				$MainScreen/TutorialDialogue/Label.text = "Press 1 to toggle between different torch beams\n \
				Press Esc to dismiss message\nStuck on something? Press Tab to display tips"
			4:
				$MainScreen/TutorialDialogue/Label.text = "Torches deplete your energy and shutoff when empty\n \
				Press Esc to dismiss message\nStuck on something? Press Tab to display tips"
			5:
				$MainScreen/TutorialDialogue/Label.text = "Mushroom pads launch you in the air\n \
				Press Esc to dismiss message\nStuck on something? Press Tab to display tips"
			6:
				$MainScreen/TutorialDialogue/Label.text = "Quicksand slows your movement upon falling into it\n \
				Press Esc to dismiss message\nStuck on something? Press Tab to display tips"
			7:
				$MainScreen/TutorialDialogue/Label.text = "Torch level increases by 1 every 2 achievements completed\n \
				Press Esc to dismiss message\nStuck on something? Press Tab to display tips"
			8:
				$MainScreen/TutorialDialogue/Label.text = "You get 1 extra heart for every achievement completed\n \
				Press Esc to dismiss message\nStuck on something? Press Tab to display tips"
			9:
				$MainScreen/TutorialDialogue/Label.text = "All enemies are vulnerable to light emitted from the torch\n \
				Press Esc to dismiss message\nStuck on something? Press Tab to display tips"
			10:
				$MainScreen/TutorialDialogue/Label.text = "Press R to respawn at the last checkpoint at the expense of 1 health, cannot be reversed\n \
				Press Esc to dismiss message\nStuck on something? Press Tab to display tips"
			11:
				$MainScreen/TutorialDialogue/Label.text = "You can hit blue blocks to find out what to do next\n \
				Press Esc to dismiss message\nStuck on something? Press Tab to display tips"
			12:
				$MainScreen/TutorialDialogue/Label.text = "Press Shift to change speeds, but they drain energy at higher speeds at different rates\n \
				Press Esc to dismiss message\nStuck on something? Press Tab to display tips"
			13:
				$MainScreen/TutorialDialogue/Label.text = "Hold LMB to damage enemies or cracked blocks with an attack cooldown\n \
				Press Esc to dismiss message\nStuck on something? Press Tab to display tips"
		
		if scroll_tip_id < 13:
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
	$MainScreen/TutorialDialogue/Label.text = "Gravity Flip: Switch gravity when trying to jump\n \
	Press Esc to dismiss message\nStuck on something? Press Tab to display tips"


func default_silhouette():
	$MainScreen/PlayerFrame/AnimatedSprite2D.play("default")
	$MainScreen/TutorialDialogue/Label.text = "Default: Just jump\n \
	Press Esc to dismiss message\nStuck on something? Press Tab to display tips"

	
func double_jump_silhouette():
	$MainScreen/PlayerFrame/AnimatedSprite2D.play("doublejump")
	$MainScreen/TutorialDialogue/Label.text = "Double Jump: Jump another time in mid-air\n \
	Press Esc to dismiss message\nStuck on something? Press Tab to display tips"

	
func linear_motion_silhouette():
	$MainScreen/PlayerFrame/AnimatedSprite2D.play("linearmotion")
	$MainScreen/TutorialDialogue/Label.text = "Linear Motion: Travel in a straight line on an angle\n \
	Press Esc to dismiss message\nStuck on something? Press Tab to display tips"


func achievement_completed():
	var new_banner = banner.instantiate()
	new_banner.position = Vector2(36,774)
	add_child(new_banner)


func _on_player_frame_mouse_entered() -> void:
	$MainScreen/TutorialDialogue.show()


func _on_player_frame_mouse_exited() -> void:
	$MainScreen/TutorialDialogue.hide()


func doomed():
	$MainScreen/PlayerHealth.modulate = Color(0, 1, 1)
	$MainScreen/TutorialDialogue.show()
	$MainScreen/TutorialDialogue/Label.text = "Fool! You have doomed us all! That's it, no more respawns for you! No-Respawn Mode Enabled!\n \
	Press Esc to dismiss message\nStuck on something? Press Tab to display tips"


func undoomed():
	$MainScreen/PlayerHealth.modulate = Color(1, 1, 1)
	$MainScreen/TutorialDialogue.show()
	$MainScreen/TutorialDialogue/Label.text = "Holy, you went through hell... let's lift the curse, shall we?\n \
	Press Esc to dismiss message\nStuck on something? Press Tab to display tips"
