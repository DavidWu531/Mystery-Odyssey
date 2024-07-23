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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func grassland_explored():
	$RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]New Planet, Who Dis?[/color]\n[i]Explore the grasslands[/i]"


func desert_explored():
	$RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]MORE POWER!![/color]\n[i]Explore the desert[/i]"
	
func frostland_explored():
	$RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Don't slide off![/color]\n[i]Explore the frostlands[/i]"
	
func enter_cave():
	$RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Anyone got a torch?[/color]\n[i]Enter the cave[/i]"
	
func escape_cave():
	$RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]My brain hurts[/color]\n[i]Escape the cave[/i]"
	
func one_heart_escape():
	$RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Unbreakable[/color]\n[i]Survive at 1 heart until next checkpoint[/i]"
	
func u_cant_c_me():
	$RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]U Can't C Me[/color]\n[i]Deplete all of your health via one hit on full health[/i]"
	
func eagle_eye():
	$RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Eagle Eye[/color]\n[i]You found a secret![/i]"
	
func cant_let_go():
	$RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Can't let go[/color]\n[i]Keep moving for 10 seconds consecutively[/i]"
	
func ultra_insticto():
	$RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Untouchable[/color]\n[i]Take no damage until next checkpoint[/i]"
	
func fire_my_laser():
	$RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]MY EYES!![/color]\n[i]Turn on flashlight[/i]"
	
func no_cheese():
	$RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]This isn't cheese[/color]\n[i]Die to lava[/i]"
	
func i_c_u():
	$RichTextLabel.text = "[b][color=green]Achievement Unlocked![/color][/b]\n[color=gold]Access Granted[/color]\n[i]Unlock the locked door[/i]"
	
