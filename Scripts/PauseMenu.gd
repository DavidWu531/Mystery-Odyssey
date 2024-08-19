extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with iftion body.


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

	if Global.grassland_explored:
		$Achievements/ScrollContainer/GridContainer/AchID1/RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]New Planet, Who Dis?[/color]\n[i]Travel 100 blocks in the grasslands[/i]"
	else:
		$Achievements/ScrollContainer/GridContainer/AchID1/RichTextLabel.text = "[b][color=gray]Achievement Locked![/color][/b]\n[color=gold]New Planet, Who Dis?[/color]\n[i]Travel 100 blocks in the grasslands[/i]"

	if Global.desert_explored:
		$Achievements/ScrollContainer/GridContainer/AchID2/RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]MORE POWER!![/color]\n[i]Travel 100 blocks in the desert[/i]"
	else:
		$Achievements/ScrollContainer/GridContainer/AchID2/RichTextLabel.text = "[b][color=gray]Achievement Locked![/color][/b]\n[color=gold]MORE POWER!![/color]\n[i]Travel 100 blocks in the desert[/i]"

	if Global.frostland_explored:
		$Achievements/ScrollContainer/GridContainer/AchID3/RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Don't slide off![/color]\n[i]Travel 100 blocks in the frostlands[/i]"
	else:
		$Achievements/ScrollContainer/GridContainer/AchID3/RichTextLabel.text = "[b][color=gray]Achievement Locked![/color][/b]\n[color=gold]Don't slide off![/color]\n[i]Travel 100 blocks in the frostlands[/i]"

	if Global.enter_cave:
		$Achievements/ScrollContainer/GridContainer/AchID4/RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Anyone got a torch?[/color]\n[i]Enter the cave[/i]"
	else:
		$Achievements/ScrollContainer/GridContainer/AchID4/RichTextLabel.text = "[b][color=gray]Achievement Locked![/color][/b]\n[color=gold]Anyone got a torch?[/color]\n[i]Enter the cave[/i]"

	if Global.escape_cave:
		$Achievements/ScrollContainer/GridContainer/AchID5/RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]My brain hurts[/color]\n[i]Escape the cave[/i]"
	else:
		$Achievements/ScrollContainer/GridContainer/AchID5/RichTextLabel.text = "[b][color=gray]Achievement Locked![/color][/b]\n[color=gold]My brain hurts[/color]\n[i]Escape the cave[/i]"

	if Global.one_heart_escape:
		$Achievements/ScrollContainer/GridContainer/AchID6/RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Unbreakable[/color]\n[i]Survive at 1 heart until next checkpoint[/i]"
	else:
		$Achievements/ScrollContainer/GridContainer/AchID6/RichTextLabel.text = "[b][color=gray]Achievement Locked![/color][/b]\n[color=gold]Unbreakable[/color]\n[i]Survive at 1 heart until next checkpoint[/i]"

	if Global.u_cant_c_me:
		$Achievements/ScrollContainer/GridContainer/AchID7/RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]U Can't C Me[/color]\n[i]Deplete all of your health in one hit on full health[/i]"
	else:
		$Achievements/ScrollContainer/GridContainer/AchID7/RichTextLabel.text = "[b][color=gray]Achievement Locked![/color][/b]\n[color=gold]U Can't C Me[/color]\n[i]Deplete all of your health in one hit on full health[/i]"

	if Global.eagle_eye:
		$Achievements/ScrollContainer/GridContainer/AchID8/RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Eagle Eye[/color]\n[i]You found a secret![/i]"
	else:
		$Achievements/ScrollContainer/GridContainer/AchID8/RichTextLabel.text = "[b][color=gray]Achievement Locked![/color][/b]\n[color=gold]Eagle Eye[/color]\n[i]You found a secret![/i]"

	if Global.cant_let_go:
		$Achievements/ScrollContainer/GridContainer/AchID9/RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Can't let go[/color]\n[i]Keep moving for 10 seconds consecutively[/i]"
	else:
		$Achievements/ScrollContainer/GridContainer/AchID9/RichTextLabel.text = "[b][color=gray]Achievement Locked![/color][/b]\n[color=gold]Can't let go[/color]\n[i]Keep moving for 10 seconds consecutively[/i]"

	if Global.ultra_insticto:
		$Achievements/ScrollContainer/GridContainer/AchID10/RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Untouchable[/color]\n[i]Take no damage until next checkpoint[/i]"
	else:
		$Achievements/ScrollContainer/GridContainer/AchID10/RichTextLabel.text = "[b][color=gray]Achievement Locked![/color][/b]\n[color=gold]Untouchable[/color]\n[i]Take no damage until next checkpoint[/i]"

	if Global.fire_my_laser:
		$Achievements/ScrollContainer/GridContainer/AchID11/RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]MY EYES!![/color]\n[i]Turn on flashlight[/i]"
	else:
		$Achievements/ScrollContainer/GridContainer/AchID11/RichTextLabel.text = "[b][color=gray]Achievement Locked![/color][/b]\n[color=gold]MY EYES!![/color]\n[i]Turn on flashlight[/i]"

	if Global.no_cheese:
		$Achievements/ScrollContainer/GridContainer/AchID12/RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]This isn't cheese[/color]\n[i]Die to lava[/i]"
	else:
		$Achievements/ScrollContainer/GridContainer/AchID12/RichTextLabel.text = "[b][color=gray]Achievement Locked![/color][/b]\n[color=gold]This isn't cheese[/color]\n[i]Die to lava[/i]"
		
	if Global.i_c_u:
		$Achievements/ScrollContainer/GridContainer/AchID13/RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Access Granted[/color]\n[i]Unlock the locked door[/i]"
	else:
		$Achievements/ScrollContainer/GridContainer/AchID13/RichTextLabel.text = "[b][color=gray]Achievement Locked![/color][/b]\n[color=gold]Access Granted[/color]\n[i]Unlock the locked door[/i]"

	if Global.no_stopping_now_i:
		$Achievements/ScrollContainer/GridContainer/AchID14/RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Don't give up hope I[/color]\n[i]Die 1 time[/i]"
	else:
		$Achievements/ScrollContainer/GridContainer/AchID14/RichTextLabel.text = "[b][color=gray]Achievement Locked![/color][/b]\n[color=gold]Don't give up hope I[/color]\n[i]Die 1 time[/i]"

	if Global.no_stopping_now_ii:
		$Achievements/ScrollContainer/GridContainer/AchID15/RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Don't give up hope II[/color]\n[i]Die 10 times[/i]"
	else:
		$Achievements/ScrollContainer/GridContainer/AchID15/RichTextLabel.text = "[b][color=gray]Achievement Locked![/color][/b]\n[color=gold]Don't give up hope II[/color]\n[i]Die 10 times[/i]"

	if Global.no_stopping_now_iii:
		$Achievements/ScrollContainer/GridContainer/AchID16/RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Don't give up hope III[/color]\n[i]Die 20 times[/i]"
	else:
		$Achievements/ScrollContainer/GridContainer/AchID16/RichTextLabel.text = "[b][color=gray]Achievement Locked![/color][/b]\n[color=gold]Don't give up hope III[/color]\n[i]Die 20 times[/i]"
		
	if Global.killing_machine_i:
		$Achievements/ScrollContainer/GridContainer/AchID17/RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Fragile but fearless I[/color]\n[i]Slay 1 enemy[/i]"
	else:
		$Achievements/ScrollContainer/GridContainer/AchID17/RichTextLabel.text = "[b][color=gray]Achievement Locked![/color][/b]\n[color=gold]Fragile but fearless I[/color]\n[i]Slay 1 enemy[/i]"

	if Global.killing_machine_ii:
		$Achievements/ScrollContainer/GridContainer/AchID18/RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Fragile but fearless II[/color]\n[i]Slay 20 enemies[/i]"
	else:
		$Achievements/ScrollContainer/GridContainer/AchID18/RichTextLabel.text = "[b][color=gray]Achievement Locked![/color][/b]\n[color=gold]Fragile but fearless II[/color]\n[i]Slay 20 enemies[/i]"

	if Global.killing_machine_iii:
		$Achievements/ScrollContainer/GridContainer/AchID19/RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Fragile but fearless III[/color]\n[i]Slay 50 enemies[/i]"
	else:
		$Achievements/ScrollContainer/GridContainer/AchID19/RichTextLabel.text = "[b][color=gray]Achievement Locked![/color][/b]\n[color=gold]Fragile but fearless III[/color]\n[i]Slay 50 enemies[/i]"

	if Global.ooh_shiny_mine_i:
		$Achievements/ScrollContainer/GridContainer/AchID20/RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Ooh, Shiny! Mine! I[/color]\n[i]Pick up 1 collectibles[/i]"
	else:
		$Achievements/ScrollContainer/GridContainer/AchID20/RichTextLabel.text = "[b][color=gray]Achievement Locked![/color][/b]\n[color=gold]Ooh, Shiny! Mine! I[/color]\n[i]Pick up 1 collectibles[/i]"

	if Global.ooh_shiny_mine_ii:
		$Achievements/ScrollContainer/GridContainer/AchID21/RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Ooh, Shiny! Mine! II[/color]\n[i]Pick up 25 collectibles[/i]"
	else:
		$Achievements/ScrollContainer/GridContainer/AchID21/RichTextLabel.text = "[b][color=gray]Achievement Locked![/color][/b]\n[color=gold]Ooh, Shiny! Mine! II[/color]\n[i]Pick up 25 collectibles[/i]"

	if Global.ooh_shiny_mine_iii:
		$Achievements/ScrollContainer/GridContainer/AchID22/RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Ooh, Shiny! Mine! III[/color]\n[i]Pick up 60 collectibles[/i]"
	else:
		$Achievements/ScrollContainer/GridContainer/AchID22/RichTextLabel.text = "[b][color=gray]Achievement Locked![/color][/b]\n[color=gold]Ooh, Shiny! Mine! III[/color]\n[i]Pick up 60 collectibles[/i]"

	if Global.quest_hunter_i:
		$Achievements/ScrollContainer/GridContainer/AchID23/RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Gotta complete those side missions I[/color]\n[i]Complete 2 quests[/i]"
	else:
		$Achievements/ScrollContainer/GridContainer/AchID23/RichTextLabel.text = "[b][color=gray]Achievement Locked![/color][/b]\n[color=gold]Gotta complete those side missions I[/color]\n[i]Complete 2 quests[/i]"

	if Global.quest_hunter_ii:
		$Achievements/ScrollContainer/GridContainer/AchID24/RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Gotta complete those side missions II[/color]\n[i]Complete 5 quests[/i]"
	else:
		$Achievements/ScrollContainer/GridContainer/AchID24/RichTextLabel.text = "[b][color=gray]Achievement Locked![/color][/b]\n[color=gold]Gotta complete those side missions II[/color]\n[i]Complete 5 quests[/i]"

	if Global.quest_hunter_iii:
		$Achievements/ScrollContainer/GridContainer/AchID25/RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Gotta complete those side missions III[/color]\n[i]Complete 10 quests[/i]"
	else:
		$Achievements/ScrollContainer/GridContainer/AchID25/RichTextLabel.text = "[b][color=gray]Achievement Locked![/color][/b]\n[color=gold]Gotta complete those side missions III[/color]\n[i]Complete 10 quests[/i]"

	if Global.social_expert_i:
		$Achievements/ScrollContainer/GridContainer/AchID26/RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Heavy Extrovert I[/color]\n[i]Talk to 2 NPCs[/i]"
	else:
		$Achievements/ScrollContainer/GridContainer/AchID26/RichTextLabel.text = "[b][color=gray]Achievement Locked![/color][/b]\n[color=gold]Heavy Extrovert I[/color]\n[i]Talk to 2 NPCs[/i]"

	if Global.social_expert_ii:
		$Achievements/ScrollContainer/GridContainer/AchID27/RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Heavy Extrovert II[/color]\n[i]Talk to 6 NPCs[/i]"
	else:
		$Achievements/ScrollContainer/GridContainer/AchID27/RichTextLabel.text = "[b][color=gray]Achievement Locked![/color][/b]\n[color=gold]Heavy Extrovert II[/color]\n[i]Talk to 6 NPCs[/i]"

	if Global.social_expert_iii:
		$Achievements/ScrollContainer/GridContainer/AchID28/RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Heavy Extrovert III[/color]\n[i]Talk to 12 NPCs[/i]"
	else:
		$Achievements/ScrollContainer/GridContainer/AchID28/RichTextLabel.text = "[b][color=gray]Achievement Locked![/color][/b]\n[color=gold]Heavy Extrovert III[/color]\n[i]Talk to 12 NPCs[/i]"


func _on_achievement_pressed():
	$Achievements.show()
