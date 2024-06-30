extends Node2D

# Achievements
var grassland_explored = false  # New Planet, Who Dis?
var desert_explored = false  # MORE POWER!!
var frostland_explored = false  # Don’t slide off!
var enter_cave = false  # Anyone got a torch?
var escape_cave = false  # My brain hurts
var one_heart_escape = false  # Sticks and stones won’t break glass
var u_cant_c_me = false  # U Can’t C Me
var eagle_eye = false  # Nice vision
var cant_let_go = false  # Can’t let go
var ultra_insticto = false  # Autonomous Movements
var fire_my_laser = false  # Burst stream of destruction
var no_cheese = false  # This isn’t cheese
var i_c_u = false  # Security first

var no_stopping_now_i = false
var no_stopping_now_ii = false
var no_stopping_now_iii = false
var killing_machine_i = false
var killing_machine_ii = false
var killing_machine_iii = false
var ooh_shiny_mine_i = false
var ooh_shiny_mine_ii = false
var ooh_shiny_mine_iii = false
var quest_hunter_i = false
var quest_hunter_ii = false
var quest_hunter_iii = false
var social_expert_i = false
var social_expert_ii = false
var social_expert_iii = false

var grassland_explored_progress = 0
var desert_explored_progress = 0
var frostland_explored_progress = 0
var enter_cave_progress = 0
var escape_cave_progress = 0
var one_heart_escape_progress = 0
var u_cant_c_me_progress = 0
var eagle_eye_progress = 0
var cant_let_go_progress = 0
var ultra_insticto_progress = 0
var fire_my_laser_progress = 0
var no_cheese_progress = 0
var i_c_u_progress = 0
var no_stopping_now_progress = 0
var killing_machine_progress = 0
var ooh_shiny_mine_progress = 0
var quest_hunter_progress = 0
var social_expert_progress = 0

# Other Global
var score = 0
var player_health = 3
var player_energy = 200
var time_elapsed = 0.00

func _process(_delta):
	if grassland_explored_progress == 1:
		grassland_explored = true
	if desert_explored_progress == 1:
		desert_explored = true
	if frostland_explored_progress == 1:
		frostland_explored = true
	if enter_cave_progress == 1:
		enter_cave = true
	if escape_cave_progress == 1:
		escape_cave = true
	if one_heart_escape_progress == 1:
		one_heart_escape = true
	if u_cant_c_me_progress == 1:
		u_cant_c_me = true
	if eagle_eye_progress == 1:
		eagle_eye = true
	if cant_let_go_progress == 1:
		cant_let_go = true
	if ultra_insticto_progress == 1:
		ultra_insticto = true
	if fire_my_laser_progress == 1:
		fire_my_laser = true
	if no_cheese_progress == 1:
		no_cheese = true
	if i_c_u_progress == 1:
		i_c_u = true

	if no_stopping_now_progress == 1 and not no_stopping_now_i:
		no_stopping_now_i = true
	if killing_machine_progress == 1 and not killing_machine_i:
		killing_machine_i = true
	if ooh_shiny_mine_progress == 1 and not ooh_shiny_mine_i:
		ooh_shiny_mine_i = true
	if quest_hunter_progress == 2 and not quest_hunter_i:
		quest_hunter_i = true
	if social_expert_progress == 2 and not social_expert_i:
		social_expert_i = true
	
	if no_stopping_now_progress == 10 and not no_stopping_now_ii:
		no_stopping_now_ii = true
	if killing_machine_progress == 20 and not killing_machine_ii:
		killing_machine_ii = true
	if ooh_shiny_mine_progress == 25 and not ooh_shiny_mine_ii:
		ooh_shiny_mine_ii = true
	if quest_hunter_progress == 5 and not quest_hunter_ii:
		quest_hunter_iii = true
	if social_expert_progress == 6 and not social_expert_ii:
		social_expert_ii = true
	
	if no_stopping_now_progress == 20 and not ooh_shiny_mine_i:
		no_stopping_now_iii = true
	if killing_machine_progress == 50 and not killing_machine_iii:
		killing_machine_iii = true
	if ooh_shiny_mine_progress == 60 and not ooh_shiny_mine_iii:
		ooh_shiny_mine_iii = true
	if quest_hunter_progress == 10 and not quest_hunter_iii:
		quest_hunter_iii = true
	if social_expert_progress == 12 and not social_expert_iii:
		social_expert_iii = true

