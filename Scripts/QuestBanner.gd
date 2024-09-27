extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.quest_coin_collected.connect(coin_collected)
	SignalBus.quest_hidden_coin_collected.connect(hidden_coin_collected)
	SignalBus.quest_npc_talked_to.connect(npc_talked_to)
	SignalBus.quest_helpful_block_hit.connect(helpful_block_hit)
	SignalBus.quest_enemy_slayed.connect(enemy_slayed)
	SignalBus.quest_mushroom_bounced.connect(mushroom_bounced)
	SignalBus.quest_avoided_rolling_boulder.connect(avoided_rolling_boulder)
	SignalBus.quest_gravity_flip_activated.connect(gravity_flip_activated)
	SignalBus.quest_maze_escaped.connect(maze_escaped)
	SignalBus.quest_double_jump_activated.connect(double_jump_activated)
	SignalBus.quest_hidden_key_found.connect(hidden_key_found)
	SignalBus.quest_tungsten_cube_dropped.connect(tungsten_cube_dropped)
	SignalBus.quest_correct_code_entered.connect(correct_code_entered)
	SignalBus.quest_andona_summoned.connect(andona_summoned)


func coin_collected():
	$RichTextLabel.text = "[b][color=green]Quest Completed![/color][/b]\n[color=gold]Collect Coins[/color]\n[i](5/5) Completed[/i]"
	$AnimatedSprite2D.play("Shiny")
	
	
func hidden_coin_collected():
	$RichTextLabel.text = "[b][color=green]Quest Completed![/color][/b]\n[color=gold]Find Hidden Coins[/color]\n[i](3/3) Completed[/i]"
	$AnimatedSprite2D.play("Shiny")
	
	
func npc_talked_to():
	$RichTextLabel.text = "[b][color=green]Quest Completed![/color][/b]\n[color=gold]Talk to an NPC[/color]\n[i](1/1) Completed[/i]"
	$AnimatedSprite2D.play("Communication")
	
	
func helpful_block_hit():
	$RichTextLabel.text = "[b][color=green]Quest Completed![/color][/b]\n[color=gold]Hit helpful blocks[/color]\n[i](2/2) Completed[/i]"
	$AnimatedSprite2D.play("Surprise")
	
	
func enemy_slayed():
	$RichTextLabel.text = "[b][color=green]Quest Completed![/color][/b]\n[color=gold]Slay Enemies[/color]\n[i](3/3) Completed[/i]"
	$AnimatedSprite2D.play("Combat")
	
	
func mushroom_bounced():
	$RichTextLabel.text = "[b][color=green]Quest Completed![/color][/b]\n[color=gold]Bounce on mushroom pads[/color]\n[i](10/10) Completed[/i]"
	$AnimatedSprite2D.play("Exploration")
	
	
func avoided_rolling_boulder():
	$RichTextLabel.text = "[b][color=green]Quest Completed![/color][/b]\n[color=gold]Avoid rolling boulders[/color]\n[i](15/15) Completed[/i]"
	$AnimatedSprite2D.play("Exploration")
	
	
func gravity_flip_activated():
	$RichTextLabel.text = "[b][color=green]Quest Completed![/color][/b]\n[color=gold]Activate Gravity Flip Mode[/color]\n[i](1/1) Completed[/i]"
	$AnimatedSprite2D.play("Exploration")
	
	
func maze_escaped():
	$RichTextLabel.text = "[b][color=green]Quest Completed![/color][/b]\n[color=gold]Escape the maze\n[i](1/1) Completed[/i]"
	$AnimatedSprite2D.play("Exploration")
	
	
func double_jump_activated():
	$RichTextLabel.text = "[b][color=green]Quest Completed![/color][/b]\n[color=gold]Activate Double Jump Mode[/color]\n[i](1/1) Completed[/i]"
	$AnimatedSprite2D.play("Exploration")
	
	
func hidden_key_found():
	$RichTextLabel.text = "[b][color=green]Quest Completed![/color][/b]\n[color=gold]Find the hidden key[/color]\n[i](1/1) Completed[/i]"
	$AnimatedSprite2D.play("Surprise")
	
	
func tungsten_cube_dropped():
	$RichTextLabel.text = "[b][color=green]Quest Completed![/color][/b]\n[color=gold]Drop the tungsten cube in lava[/color]\n[i](1/1) Completed[/i]"
	$AnimatedSprite2D.play("Surprise")
	
	
func correct_code_entered():
	$RichTextLabel.text = "[b][color=green]Quest Completed![/color][/b]\n[color=gold]Enter the correct code[/color]\n[i](1/1) Completed[/i]"
	$AnimatedSprite2D.play("Surprise")
	
	
func andona_summoned():
	$RichTextLabel.text = "[b][color=green]Quest Completed![/color][/b]\n[color=gold]Summon Andona using his altar[/color]\n[i](1/1) Completed[/i]"
	$AnimatedSprite2D.play("Combat")
	
	
func _on_duration_timer_timeout():
	queue_free()
