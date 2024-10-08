extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.grassland_explored.connect(grassland_explored)
	SignalBus.desert_explored.connect(desert_explored)
	SignalBus.frostland_explored.connect(frostland_explored)
	SignalBus.enter_cave.connect(enter_cave)
	SignalBus.escape_cave.connect(escape_cave)
	SignalBus.one_heart_escape.connect(one_heart_escape)
	SignalBus.u_cant_c_me.connect(u_cant_c_me)
	SignalBus.eagle_eye.connect(eagle_eye)
	SignalBus.cant_let_go.connect(cant_let_go)
	SignalBus.ultra_insticto.connect(ultra_insticto)
	SignalBus.fire_my_laser.connect(fire_my_laser)
	SignalBus.no_cheese.connect(no_cheese)
	SignalBus.i_c_u.connect(i_c_u)
	SignalBus.not_safe.connect(not_safe)
	SignalBus.weeee.connect(weeee)

	SignalBus.no_stopping_now_i.connect(no_stopping_now_i)
	SignalBus.no_stopping_now_ii.connect(no_stopping_now_ii)
	SignalBus.no_stopping_now_iii.connect(no_stopping_now_iii)
	SignalBus.killing_machine_i.connect(killing_machine_i)
	SignalBus.killing_machine_ii.connect(killing_machine_ii)
	SignalBus.killing_machine_iii.connect(killing_machine_iii)
	SignalBus.ooh_shiny_mine_i.connect(ooh_shiny_mine_i)
	SignalBus.ooh_shiny_mine_ii.connect(ooh_shiny_mine_ii)
	SignalBus.ooh_shiny_mine_iii.connect(ooh_shiny_mine_iii)
	SignalBus.quest_hunter_i.connect(quest_hunter_i)
	SignalBus.quest_hunter_ii.connect(quest_hunter_ii)
	SignalBus.quest_hunter_iii.connect(quest_hunter_iii)
	SignalBus.social_expert_i.connect(social_expert_i)
	SignalBus.social_expert_ii.connect(social_expert_ii)
	SignalBus.social_expert_iii.connect(social_expert_iii)


func grassland_explored():
	$RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]New Planet, Who Dis?[/color]\n[i]Travel 100 blocks in the grasslands[/i]"
	$AnimatedSprite2D.play("Exploration")
	

func desert_explored():
	$RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]MORE POWER!![/color]\n[i]Travel 100 blocks in the desert[/i]"
	$AnimatedSprite2D.play("Exploration")
	

func frostland_explored():
	$RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Don't slide off![/color]\n[i]Travel 100 blocks in the frostlands[/i]"
	$AnimatedSprite2D.play("Exploration")
	

func enter_cave():
	$RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Anyone got a torch?[/color]\n[i]Enter the cave[/i]"
	$AnimatedSprite2D.play("Exploration")
	

func escape_cave():
	$RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]My brain hurts[/color]\n[i]Escape the cave[/i]"
	$AnimatedSprite2D.play("Exploration")
	

func one_heart_escape():
	$RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Unbreakable[/color]\n[i]Survive at 1 heart until next checkpoint[/i]"
	$AnimatedSprite2D.play("Combat")
	

func u_cant_c_me():
	$RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]U Can't C Me[/color]\n[i]Deplete all of your health in one hit on full health[/i]"
	$AnimatedSprite2D.play("Death")
	

func eagle_eye():
	$RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Eagle Eye[/color]\n[i]You found a secret![/i]"
	$AnimatedSprite2D.play("Surprise")
	

func cant_let_go():
	$RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Can't let go[/color]\n[i]Keep moving for 10 seconds consecutively[/i]"
	$AnimatedSprite2D.play("Exploration")


func ultra_insticto():
	$RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Untouchable[/color]\n[i]Take no damage until next checkpoint[/i]"
	$AnimatedSprite2D.play("Combat")


func fire_my_laser():
	$RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]MY EYES!![/color]\n[i]Turn on flashlight[/i]"
	$AnimatedSprite2D.play("Exploration")
	

func no_cheese():
	$RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]This isn't cheese[/color]\n[i]Die to lava[/i]"
	$AnimatedSprite2D.play("Death")
	

func i_c_u():
	$RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Access Granted[/color]\n[i]Unlock the locked door[/i]"
	$AnimatedSprite2D.play("Surprise")
	

func not_safe():
	$RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]I thought this was safe...[/color]\n[i]Die to water[/i]"
	$AnimatedSprite2D.play("Death")
	
	
func weeee():
	$RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Yaahoohoohoo![/color]\n[i]Slide on ice[/i]"
	$AnimatedSprite2D.play("Exploration")
	
	
func no_stopping_now_i():
	$RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Don't give up hope I[/color]\n[i]Die 1 time[/i]"
	$AnimatedSprite2D.play("Death")
	

func no_stopping_now_ii():
	$RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Don't give up hope II[/color]\n[i]Die 10 times[/i]"
	$AnimatedSprite2D.play("Death")
	

func no_stopping_now_iii():
	$RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Don't give up hope III[/color]\n[i]Die 30 times[/i]"
	$AnimatedSprite2D.play("Death")
	

func killing_machine_i():
	$RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Fragile but fearless I[/color]\n[i]Slay 1 enemy[/i]"
	$AnimatedSprite2D.play("Combat")
	

func killing_machine_ii():
	$RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Fragile but fearless II[/color]\n[i]Slay 10 enemies[/i]"
	$AnimatedSprite2D.play("Combat")
	

func killing_machine_iii():
	$RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Fragile but fearless III[/color]\n[i]Slay 20 enemies[/i]"
	$AnimatedSprite2D.play("Combat")
	

func ooh_shiny_mine_i():
	$RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Ooh, Shiny! Mine! I[/color]\n[i]Pick up 1 collectibles[/i]"
	$AnimatedSprite2D.play("Shiny")
	

func ooh_shiny_mine_ii():
	$RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Ooh, Shiny! Mine! II[/color]\n[i]Pick up 25 collectibles[/i]"
	$AnimatedSprite2D.play("Shiny")
	

func ooh_shiny_mine_iii():
	$RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Ooh, Shiny! Mine! III[/color]\n[i]Pick up 60 collectibles[/i]"
	$AnimatedSprite2D.play("Shiny")
	

func quest_hunter_i():
	$RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Gotta complete those side missions I[/color]\n[i]Complete 2 quests[/i]"
	$AnimatedSprite2D.play("Combat")


func quest_hunter_ii():
	$RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Gotta complete those side missions II[/color]\n[i]Complete 5 quests[/i]"
	$AnimatedSprite2D.play("Combat")


func quest_hunter_iii():
	$RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Gotta complete those side missions III[/color]\n[i]Complete 10 quests[/i]"
	$AnimatedSprite2D.play("Combat")
	

func social_expert_i():
	$RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Heavy Extrovert I[/color]\n[i]Talk to 2 NPCs[/i]"
	$AnimatedSprite2D.play("Communication")
	

func social_expert_ii():
	$RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Heavy Extrovert II[/color]\n[i]Talk to 6 NPCs[/i]"
	$AnimatedSprite2D.play("Communication")
	

func social_expert_iii():
	$RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Heavy Extrovert III[/color]\n[i]Talk to 12 NPCs[/i]"
	$AnimatedSprite2D.play("Death")


func _on_duration_timer_timeout():
	queue_free()
