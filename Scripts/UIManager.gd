extends CanvasLayer

var quests = { 
	"Talk to an NPC": {"progress": 0, "goal": 1, "completed": false},
	"Collect Coins": {"progress": 0, "goal": 5, "completed": false},
	"Find Hidden Coins": {"progress": 0, "goal": 3, "completed": false},
	"Hit helpful blocks": {"progress": 0, "goal": 2, "completed": false},
	"Slay Enemies": {"progress": 0, "goal": 3, "completed": false},
	"Bounce on mushroom pads": {"progress": 0, "goal": 10, "completed": false},
	"Avoid rolling boulders": {"progress": 0, "goal": 15, "completed": false},
	"Activate Gravity Flip Mode": {"progress": 0, "goal": 1, "completed": false},
	"Escape the maze": {"progress": 0, "goal": 1, "completed": false},
	"Activate Double Jump Mode": {"progress": 0, "goal": 1, "completed": false},
	"Find the hidden key": {"progress": 0, "goal": 1, "completed": false},
	"Drop the tungsten cube in lava": {"progress": 0, "goal": 1, "completed": false},
	"Enter the correct code": {"progress": 0, "goal": 1, "completed": false},
	"Summon Andona using his altar": {"progress": 0, "goal": 1, "completed": false}
}

var banner = preload("res://Scenes/achievement_banner.tscn")
var scroll_tip_id = 0

var boss_maxhealth = 1000
var quests_completed = 0


func _ready():
	SignalBus.coin_collected.connect(collect_coin)
	SignalBus.npc_talked_to.connect(talk_to_npc)
	SignalBus.helpful_block_hit.connect(hit_helpful_blocks)
	SignalBus.enemy_slayed.connect(slay_enemies)
	SignalBus.mushroom_bounced.connect(bounce_on_mushroom_pads)
	SignalBus.avoided_rolling_boulder.connect(avoid_rolling_boulders)
	SignalBus.gravity_flip_activated.connect(activate_gravity_flip_mode)
	SignalBus.maze_escaped.connect(escape_the_maze)
	SignalBus.double_jump_activated.connect(activate_double_jump_mode)
	SignalBus.hidden_key_found.connect(find_the_hidden_key)
	SignalBus.tungsten_cube_dropped.connect(drop_the_tungsten_cube_in_lava)
	SignalBus.correct_code_entered.connect(enter_the_correct_code)
	SignalBus.andona_summoned.connect(summon_andona_using_his_altar)
	
	
	SignalBus.achievement_completed.connect(achievement_completed)
	SignalBus.doomed.connect(doomed)
	SignalBus.undoomed.connect(undoomed)
	SignalBus.boss_spawned.connect(boss_spawned)
	
	SignalBus.default_silhouette.connect(default_silhouette)
	SignalBus.double_jump_silhouette.connect(double_jump_silhouette)
	SignalBus.gravity_flip_silhouette.connect(gravity_flip_silhouette)
	SignalBus.linear_motion_silhouette.connect(linear_motion_silhouette)
	
	$MainScreen/BossHealth/BossHealthbar.max_value = 200
	
	update_quest()
	
	if Settings.gamemode == "Adventure":
		$MainScreen/Dialogue/Dialogue.text = "Navigate the realm, avoid obstacles, and fight against wild creatures"
	elif Settings.gamemode == "Creative":
		$MainScreen/Dialogue/Dialogue.text = "Explore the realm freely with infinite stamina and health"
	elif Settings.gamemode == "Speedrunner":
		$MainScreen/TimeElapsed.show()
		$MainScreen/Dialogue/Dialogue.text = "Beat the game as fast as you can, race against the time"
	elif Settings.gamemode == "Permadeath":
		$MainScreen/Dialogue/Dialogue.text = "If all of your health is depleted, game over!"
	$MainScreen/Dialogue/DialogueTimer.start(10.0)


func _process(delta):
	if Input.is_action_just_pressed("ui_end"):
		if $MainScreen/Quest.visible:
			$MainScreen/Quest.hide()
		else:
			$MainScreen/Quest.show()
	
	$PauseMenu/Score.text = "Score: " + str(Global.score)
	
	if Global.spectator:
		$MainScreen/Health/Base/PlayerHealthText.text = "Spectator Mode: Health N/A"
		$MainScreen/Health/Base/PlayerHealth.size = Vector2(0,31)
		$MainScreen/Health/Base/PlayerHealthText.position = Vector2(64,0)
		$MainScreen/Energy/PlayerEnergyText.text = "Spectator Mode: Energy N/A"
	elif Settings.gamemode == "Creative":
		$MainScreen/Health/Base/PlayerHealthText.text = "Creative Mode: Infinite Health"
		$MainScreen/Health/Base/PlayerHealth.size = Vector2(0,31)
		$MainScreen/Health/Base/PlayerHealthText.position = Vector2(64,0)
		$MainScreen/Energy/PlayerEnergyText.text = "Creative Mode: Infinite Energy"
	else:
		if Global.player_health <= 5:
			if Global.player_maxhealth <= 5:
				$MainScreen/Health/Base/PlayerHealthOverlay.size = Vector2(Global.player_maxhealth * 38, 31.6)
			else:
				$MainScreen/Health/Base/PlayerHealthOverlay.size = Vector2(190, 31.6)
			$MainScreen/Health/Base/PlayerHealth.size = Vector2(Global.player_health * 38, 31.6)
		else:
			$MainScreen/Health/Base/PlayerHealthOverlay.size = Vector2(38, 31.6)
			$MainScreen/Health/Base/PlayerHealth.size = Vector2(38, 31.6)
			$MainScreen/Health/Base/PlayerHealthText.show()
		$MainScreen/Health/Base/PlayerHealthText.text = str(Global.player_health).pad_decimals(1) + "/" + str(Global.player_maxhealth).pad_decimals(1)
		$MainScreen/Health/Base/PlayerHealthText.position = Vector2(128,0)
		$MainScreen/Health/Boss/PlayerHealthText.text = str(Global.player_health).pad_decimals(1) + "/" + str(Global.player_maxhealth).pad_decimals(1)
		$MainScreen/Energy/PlayerEnergyText.text = str(Global.player_energy).pad_decimals(1) + "/" + str(Global.player_maxenergy).pad_decimals(1)
	
	$MainScreen/Health/Boss/PlayerHealthBar.value = Global.player_health
	$MainScreen/Health/Boss/PlayerHealthBar.max_value = Global.player_maxhealth
	
	$MainScreen/TimeElapsed.text = str(Global.time_elapsed).pad_decimals(2)
	
	Global.time_elapsed += delta
	
	$MainScreen/Energy/PlayerEnergy.max_value = Global.player_maxenergy
	$MainScreen/Energy/PlayerEnergy.value = Global.player_energy
	
	$MainScreen/Speed/PlayerSpeed.value = Global.player_speed
	
	$MainScreen/BossHealth/BossHealthbar.value = fmod(Global.boss_health, 200.0)
	$MainScreen/BossHealth/BossHealthText.text = str(Global.boss_health).pad_decimals(1) + "/" + str(boss_maxhealth).pad_decimals(1)
	$MainScreen/BossHealth/HealthbarLeft.text = "x" + str(Global.boss_health / 200.0).pad_decimals(0)
	
	if Global.boss_health <= 200:
		$MainScreen/BossHealth/BossStrengthText.text = "Andona attacks 400% faster"
	elif Global.boss_health <= 400:
		$MainScreen/BossHealth/BossStrengthText.text = "Andona attacks 125% faster"
	elif Global.boss_health <= 600:
		$MainScreen/BossHealth/BossStrengthText.text = "Andona attacks 67% faster"
	elif Global.boss_health <= 800:
		$MainScreen/BossHealth/BossStrengthText.text = "Andona attacks 25% faster"
	else:
		$MainScreen/BossHealth/BossStrengthText.text = "Andona attacks 0% faster"
	
	$MainScreen/AlternateTime.text = "Lava is rising, escape in " + str($MainScreen/LavaTimer.time_left).pad_decimals(2) + "s"
	
	$MainScreen/Energy/PlayerEnergy.max_value = 50 * (1 + (Global.quest_hunter_progress * 0.1))
	
	
func _physics_process(_delta: float) -> void:
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
	
	if fmod(Global.boss_health, 200.0) == 0 and Global.boss_health != 1000:
		$MainScreen/Dialogue/Dialogue.text = "Beware! Andona has become stronger and even more dangerous!"
		$MainScreen/Dialogue.show()
		$MainScreen/Dialogue/DialogueTimer.start(10.0)

func _on_continue_pressed():
	$PauseMenu.hide()
	get_tree().paused = false


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
	$MainScreen/Health/Base/PlayerHealth.modulate = Color(0, 1, 1)
	$MainScreen/Dialogue.show()
	$MainScreen/Dialogue/Dialogue.text = "Fool! I told you not to touch the tungsten cube! I will not let you respawn as your punishment for making the lava rise!"
	$MainScreen/LavaTimer.start(180.0)
	$MainScreen/Dialogue/DialogueTimer.start(10.0)
	$MainScreen/AlternateTime.show()


func undoomed():
	$MainScreen/Health/Base/PlayerHealth.modulate = Color(1, 1, 1)
	$MainScreen/Dialogue.show()
	$MainScreen/Dialogue/Dialogue.text = "Huh, so you did escape... I underestimated you... your punishment has been lifted"
	$MainScreen/LavaTimer.start(180.0)
	$MainScreen/Dialogue/DialogueTimer.start(10.0)
	$MainScreen/AlternateTime.hide()


func boss_spawned():
	$MainScreen/BossHealth.show()
	$MainScreen/Health/Boss.show()
	$MainScreen/Health/Base.hide()


func _on_lava_timer_timeout() -> void:
	$MainScreen/AlternateTime.hide()


func _on_dialogue_timer_timeout() -> void:
	$MainScreen/Dialogue.hide()


func update_quest():
	if not quests["Talk to an NPC"]["completed"]:
		$PauseMenu/Quests/ScrollContainer/GridContainer/QuestID1/RichTextLabel.text = "[b][color=gray]Quest Uncompleted![/color][/b]\n[color=gold]Talk to an NPC[/color]\n[i](" + str(quests["Talk to an NPC"]["progress"]) + "/" + str(quests["Talk to an NPC"]["goal"]) + ")[/i]"
	else:
		$PauseMenu/Quests/ScrollContainer/GridContainer/QuestID1/RichTextLabel.text = "[b][color=green]Quest Completed![/color][/b]\n[color=gold]Talk to an NPC[/color]\n[i](" + str(quests["Talk to an NPC"]["progress"]) + "/" + str(quests["Talk to an NPC"]["goal"]) + ") Completed[/i]"
	
	if not quests["Collect Coins"]["completed"]:
		$PauseMenu/Quests/ScrollContainer/GridContainer/QuestID2/RichTextLabel.text = "[b][color=gray]Quest Uncompleted![/color][/b]\n[color=gold]Collect Coins[/color]\n[i](" + str(quests["Collect Coins"]["progress"]) + "/" + str(quests["Collect Coins"]["goal"]) + ")[/i]"
	else:
		$PauseMenu/Quests/ScrollContainer/GridContainer/QuestID2/RichTextLabel.text = "[b][color=green]Quest Completed![/color][/b]\n[color=gold]Collect Coins[/color]\n[i](" + str(quests["Collect Coins"]["progress"]) + "/" + str(quests["Collect Coins"]["goal"]) + ") Completed[/i]"
	
	if not quests["Find Hidden Coins"]["completed"]:
		$PauseMenu/Quests/ScrollContainer/GridContainer/QuestID3/RichTextLabel.text = "[b][color=gray]Quest Uncompleted![/color][/b]\n[color=gold]Find Hidden Coins[/color]\n[i](" + str(quests["Find Hidden Coins"]["progress"]) + "/" + str(quests["Find Hidden Coins"]["goal"]) + ")[/i]"
	else:
		$PauseMenu/Quests/ScrollContainer/GridContainer/QuestID3/RichTextLabel.text = "[b][color=green]Quest Completed![/color][/b]\n[color=gold]Find Hidden Coins[/color]\n[i](" + str(quests["Find Hidden Coins"]["progress"]) + "/" + str(quests["Find Hidden Coins"]["goal"]) + ") Completed[/i]"
	
	if not quests["Hit helpful blocks"]["completed"]:
		$PauseMenu/Quests/ScrollContainer/GridContainer/QuestID4/RichTextLabel.text = "[b][color=gray]Quest Uncompleted![/color][/b]\n[color=gold]Hit helpful blocks[/color]\n[i](" + str(quests["Hit helpful blocks"]["progress"]) + "/" + str(quests["Hit helpful blocks"]["goal"]) + ")[/i]"
	else:
		$PauseMenu/Quests/ScrollContainer/GridContainer/QuestID4/RichTextLabel.text = "[b][color=green]Quest Completed![/color][/b]\n[color=gold]Hit helpful blocks[/color]\n[i](" + str(quests["Hit helpful blocks"]["progress"]) + "/" + str(quests["Hit helpful blocks"]["goal"]) + ") Completed[/i]"
	
	if not quests["Slay Enemies"]["completed"]:
		$PauseMenu/Quests/ScrollContainer/GridContainer/QuestID5/RichTextLabel.text = "[b][color=gray]Quest Uncompleted![/color][/b]\n[color=gold]Slay Enemies[/color]\n[i](" + str(quests["Slay Enemies"]["progress"]) + "/" + str(quests["Slay Enemies"]["goal"]) + ")[/i]"
	else:
		$PauseMenu/Quests/ScrollContainer/GridContainer/QuestID5/RichTextLabel.text = "[b][color=green]Quest Completed![/color][/b]\n[color=gold]Slay Enemies[/color]\n[i](" + str(quests["Slay Enemies"]["progress"]) + "/" + str(quests["Slay Enemies"]["goal"]) + ") Completed[/i]"
	
	if not quests["Bounce on mushroom pads"]["completed"]:
		$PauseMenu/Quests/ScrollContainer/GridContainer/QuestID6/RichTextLabel.text = "[b][color=gray]Quest Uncompleted![/color][/b]\n[color=gold]Bounce on mushroom pads[/color]\n[i](" + str(quests["Bounce on mushroom pads"]["progress"]) + "/" + str(quests["Bounce on mushroom pads"]["goal"]) + ")[/i]"
	else:
		$PauseMenu/Quests/ScrollContainer/GridContainer/QuestID6/RichTextLabel.text = "[b][color=green]Quest Completed![/color][/b]\n[color=gold]Bounce on mushroom pads[/color]\n[i](" + str(quests["Bounce on mushroom pads"]["progress"]) + "/" + str(quests["Bounce on mushroom pads"]["goal"]) + ") Completed[/i]"
	
	if not quests["Avoid rolling boulders"]["completed"]:
		$PauseMenu/Quests/ScrollContainer/GridContainer/QuestID7/RichTextLabel.text = "[b][color=gray]Quest Uncompleted![/color][/b]\n[color=gold]Avoid rolling boulders[/color]\n[i](" + str(quests["Avoid rolling boulders"]["progress"]) + "/" + str(quests["Avoid rolling boulders"]["goal"]) + ")[/i]"
	else:
		$PauseMenu/Quests/ScrollContainer/GridContainer/QuestID7/RichTextLabel.text = "[b][color=green]Quest Completed![/color][/b]\n[color=gold]Avoid rolling boulders[/color]\n[i](" + str(quests["Avoid rolling boulders"]["progress"]) + "/" + str(quests["Avoid rolling boulders"]["goal"]) + ") Completed[/i]"
	
	if not quests["Activate Gravity Flip Mode"]["completed"]:
		$PauseMenu/Quests/ScrollContainer/GridContainer/QuestID8/RichTextLabel.text = "[b][color=gray]Quest Uncompleted![/color][/b]\n[color=gold]Activate Gravity Flip Mode[/color]\n[i](" + str(quests["Activate Gravity Flip Mode"]["progress"]) + "/" + str(quests["Activate Gravity Flip Mode"]["goal"]) + ")[/i]"
	else:
		$PauseMenu/Quests/ScrollContainer/GridContainer/QuestID8/RichTextLabel.text = "[b][color=green]Quest Completed![/color][/b]\n[color=gold]Activate Gravity Flip Mode[/color]\n[i](" + str(quests["Activate Gravity Flip Mode"]["progress"]) + "/" + str(quests["Activate Gravity Flip Mode"]["goal"]) + ") Completed[/i]"
	
	if not quests["Escape the maze"]["completed"]:
		$PauseMenu/Quests/ScrollContainer/GridContainer/QuestID9/RichTextLabel.text = "[b][color=gray]Quest Uncompleted![/color][/b]\n[color=gold]Escape the maze[/color]\n[i](" + str(quests["Escape the maze"]["progress"]) + "/" + str(quests["Escape the maze"]["goal"]) + ")[/i]"
	else:
		$PauseMenu/Quests/ScrollContainer/GridContainer/QuestID9/RichTextLabel.text = "[b][color=green]Quest Completed![/color][/b]\n[color=gold]Talk to an NPC[/color]\n[i](" + str(quests["Talk to an NPC"]["progress"]) + "/" + str(quests["Talk to an NPC"]["goal"]) + ") Completed[/i]"
	
	if not quests["Activate Double Jump Mode"]["completed"]:
		$PauseMenu/Quests/ScrollContainer/GridContainer/QuestID10/RichTextLabel.text = "[b][color=gray]Quest Uncompleted![/color][/b]\n[color=gold]Activate Double Jump Mode[/color]\n[i](" + str(quests["Activate Double Jump Mode"]["progress"]) + "/" + str(quests["Activate Double Jump Mode"]["goal"]) + ")[/i]"
	else:
		$PauseMenu/Quests/ScrollContainer/GridContainer/QuestID10/RichTextLabel.text = "[b][color=green]Quest Completed![/color][/b]\n[color=gold]Activate Double Jump Mode[/color]\n[i](" + str(quests["Activate Double Jump Mode"]["progress"]) + "/" + str(quests["Activate Double Jump Mode"]["goal"]) + ") Completed[/i]"
	
	if not quests["Find the hidden key"]["completed"]:
		$PauseMenu/Quests/ScrollContainer/GridContainer/QuestID11/RichTextLabel.text = "[b][color=gray]Quest Uncompleted![/color][/b]\n[color=gold]Find the hidden key[/color]\n[i](" + str(quests["Find the hidden key"]["progress"]) + "/" + str(quests["Find the hidden key"]["goal"]) + ")[/i]"
	else:
		$PauseMenu/Quests/ScrollContainer/GridContainer/QuestID11/RichTextLabel.text = "[b][color=green]Quest Completed![/color][/b]\n[color=gold]Find the hidden key[/color]\n[i](" + str(quests["Find the hidden key"]["progress"]) + "/" + str(quests["Find the hidden key"]["goal"]) + ") Completed[/i]"
	
	if not quests["Drop the tungsten cube in lava"]["completed"]:
		$PauseMenu/Quests/ScrollContainer/GridContainer/QuestID12/RichTextLabel.text = "[b][color=gray]Quest Uncompleted![/color][/b]\n[color=gold]Drop the tungsten cube in lava[/color]\n[i](" + str(quests["Drop the tungsten cube in lava"]["progress"]) + "/" + str(quests["Drop the tungsten cube in lava"]["goal"]) + ")[/i]"
	else:
		$PauseMenu/Quests/ScrollContainer/GridContainer/QuestID12/RichTextLabel.text = "[b][color=green]Quest Completed![/color][/b]\n[color=gold]Drop the tungsten cube in lava[/color]\n[i](" + str(quests["Drop the tungsten cube in lava"]["progress"]) + "/" + str(quests["Drop the tungsten cube in lava"]["goal"]) + ") Completed[/i]"
	
	if not quests["Enter the correct code"]["completed"]:
		$PauseMenu/Quests/ScrollContainer/GridContainer/QuestID13/RichTextLabel.text = "[b][color=gray]Quest Uncompleted![/color][/b]\n[color=gold]Enter the correct code[/color]\n[i](" + str(quests["Enter the correct code"]["progress"]) + "/" + str(quests["Enter the correct code"]["goal"]) + ")[/i]"
	else:
		$PauseMenu/Quests/ScrollContainer/GridContainer/QuestID13/RichTextLabel.text = "[b][color=green]Quest Completed![/color][/b]\n[color=gold]Enter the correct code[/color]\n[i](" + str(quests["Enter the correct code"]["progress"]) + "/" + str(quests["Enter the correct code"]["goal"]) + ") Completed[/i]"
	
	if not quests["Summon Andona using his altar"]["completed"]:
		$PauseMenu/Quests/ScrollContainer/GridContainer/QuestID14/RichTextLabel.text = "[b][color=gray]Quest Uncompleted![/color][/b]\n[color=gold]Summon Andona using his altar[/color]\n[i](" + str(quests["Summon Andona using his altar"]["progress"]) + "/" + str(quests["Summon Andona using his altar"]["goal"]) + ")[/i]"
	else:
		$PauseMenu/Quests/ScrollContainer/GridContainer/QuestID14/RichTextLabel.text = "[b][color=green]Quest Completed![/color][/b]\n[color=gold]Summon Andona using his altar[/color]\n[i](" + str(quests["Summon Andona using his altar"]["progress"]) + "/" + str(quests["Summon Andona using his altar"]["goal"]) + ") Completed[/i]"

func talk_to_npc():
	if not quests["Talk to an NPC"]["completed"]:
		quests["Talk to an NPC"]["progress"] += 1
		check_quest_completion("Talk to an NPC")


func collect_coin():
	if not quests["Collect Coins"]["completed"]:
		quests["Collect Coins"]["progress"] += 1
		check_quest_completion("Collect Coins")


func find_hidden_coin():
	if not quests["Find Hidden Coins"]["completed"]:
		quests["Find Hidden Coins"]["progress"] += 1
		check_quest_completion("Find Hidden Coins")


func hit_helpful_blocks():
	if not quests["Hit helpful blocks"]["completed"]:
		quests["Hit helpful blocks"]["progress"] += 1
		check_quest_completion("Hit helpful blocks")


func slay_enemies():
	if not quests["Slay Enemies"]["completed"]:
		quests["Slay Enemies"]["progress"] += 1
		check_quest_completion("Slay Enemies")


func bounce_on_mushroom_pads():
	if not quests["Bounce on mushroom pads"]["completed"]:
		quests["Bounce on mushroom pads"]["progress"] += 1
		check_quest_completion("Bounce on mushroom pads")


func avoid_rolling_boulders():
	if not quests["Avoid rolling boulders"]["completed"]:
		quests["Avoid rolling boulders"]["progress"] += 1
		check_quest_completion("Avoid rolling boulders")


func activate_gravity_flip_mode():
	if not quests["Activate Gravity Flip Mode"]["completed"]:
		quests["Activate Gravity Flip Mode"]["progress"] += 1
		check_quest_completion("Activate Gravity Flip Mode")


func escape_the_maze():
	if not quests["Escape the maze"]["completed"]:
		quests["Escape the maze"]["progress"] += 1
		check_quest_completion("Escape the maze")


func activate_double_jump_mode():
	if not quests["Activate Double Jump Mode"]["completed"]:
		quests["Activate Double Jump Mode"]["progress"] += 1
		check_quest_completion("Activate Double Jump Mode")


func find_the_hidden_key():
	if not quests["Find the hidden key"]["completed"]:
		quests["Find the hidden key"]["progress"] += 1
		check_quest_completion("Find the hidden key")


func drop_the_tungsten_cube_in_lava():
	if not quests["Drop the tungsten cube in lava"]["completed"]:
		quests["Drop the tungsten cube in lava"]["progress"] += 1
		check_quest_completion("Drop the tungsten cube in lava")


func enter_the_correct_code():
	if not quests["Enter the correct code"]["completed"]:
		quests["Enter the correct code"]["progress"] += 1
		check_quest_completion("Enter the correct code")


func summon_andona_using_his_altar():
	if not quests["Summon Andona using his altar"]["completed"]:
		quests["Summon Andona using his altar"]["progress"] += 1
		check_quest_completion("Summon Andona using his altar")


func check_quest_completion(quest_name):
	update_quest()
	var quest = quests[quest_name]
	if quest["progress"] >= quest["goal"]:
		quest["completed"] = true
		Global.quest_hunter_progress += 1


func _on_update_quest_timer_timeout() -> void:
	update_quest()


func _on_player_health_mouse_entered() -> void:
	$MainScreen/Health/Base/PlayerHealthText.show()


func _on_player_health_mouse_exited() -> void:
	if Global.player_health <= 5:
		$MainScreen/Health/Base/PlayerHealthText.hide()


func _on_player_health_overlay_mouse_entered() -> void:
	$MainScreen/Health/Base/PlayerHealthText.show()


func _on_player_health_overlay_mouse_exited() -> void:
	if Global.player_health <= 5:
		$MainScreen/Health/Base/PlayerHealthText.hide()


func _on_player_energy_mouse_entered() -> void:
	$MainScreen/Energy/PlayerEnergyText.show()


func _on_player_energy_mouse_exited() -> void:
	$MainScreen/Energy/PlayerEnergyText.hide()


func _on_player_health_bar_mouse_entered() -> void:
	$MainScreen/Health/Boss/PlayerHealthText.show()


func _on_player_health_bar_mouse_exited() -> void:
	if not $MainScreen/Health/Boss.visible:
		if Global.player_health <= 5:
			$MainScreen/Health/Boss/PlayerHealthText.hide()
	else:
		$MainScreen/Health/Boss/PlayerHealthText.hide()


func _on_boss_healthbar_mouse_entered() -> void:
	$MainScreen/BossHealth/BossHealthText.show()
	$MainScreen/BossHealth/BossStrengthText.show()


func _on_boss_healthbar_mouse_exited() -> void:
	$MainScreen/BossHealth/BossHealthText.hide()
	$MainScreen/BossHealth/BossStrengthText.hide()
