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
var player_maxhealth = 3
var achievement_completed = 0

func _process(_delta):
	if grassland_explored_progress == 1 and not grassland_explored:
		grassland_explored = true
		achievement_completed += 1
	if desert_explored_progress == 1 and not desert_explored:
		desert_explored = true
		achievement_completed += 1
	if frostland_explored_progress == 1 and not frostland_explored:
		frostland_explored = true
		achievement_completed += 1
	if enter_cave_progress == 1 and not enter_cave:
		enter_cave = true
		achievement_completed += 1
	if escape_cave_progress == 1 and not escape_cave:
		escape_cave = true
		achievement_completed += 1
	if one_heart_escape_progress == 1 and not one_heart_escape:
		one_heart_escape = true
		achievement_completed += 1
	if u_cant_c_me_progress == 1 and not u_cant_c_me:
		u_cant_c_me = true
		achievement_completed += 1
	if eagle_eye_progress == 1 and not eagle_eye:
		eagle_eye = true
		achievement_completed += 1
	if cant_let_go_progress == 1 and not cant_let_go:
		cant_let_go = true
		achievement_completed += 1
	if ultra_insticto_progress == 1 and not ultra_insticto:
		ultra_insticto = true
		achievement_completed += 1
	if fire_my_laser_progress == 1 and not fire_my_laser:
		fire_my_laser = true
		achievement_completed += 1
	if no_cheese_progress == 1 and not no_cheese:
		no_cheese = true
		achievement_completed += 1
	if i_c_u_progress == 1 and not i_c_u:
		i_c_u = true
		achievement_completed += 1

	if no_stopping_now_progress == 1 and not no_stopping_now_i:
		no_stopping_now_i = true
		achievement_completed += 1
	if killing_machine_progress == 1 and not killing_machine_i:
		killing_machine_i = true
		achievement_completed += 1
	if ooh_shiny_mine_progress == 1 and not ooh_shiny_mine_i:
		ooh_shiny_mine_i = true
		achievement_completed += 1
	if quest_hunter_progress == 2 and not quest_hunter_i:
		quest_hunter_i = true
		achievement_completed += 1
	if social_expert_progress == 2 and not social_expert_i:
		social_expert_i = true
		achievement_completed += 1
	
	if no_stopping_now_progress == 10 and not no_stopping_now_ii:
		no_stopping_now_ii = true
		achievement_completed += 1
	if killing_machine_progress == 20 and not killing_machine_ii:
		killing_machine_ii = true
		achievement_completed += 1
	if ooh_shiny_mine_progress == 25 and not ooh_shiny_mine_ii:
		ooh_shiny_mine_ii = true
		achievement_completed += 1
	if quest_hunter_progress == 5 and not quest_hunter_ii:
		quest_hunter_iii = true
		achievement_completed += 1
	if social_expert_progress == 6 and not social_expert_ii:
		social_expert_ii = true
		achievement_completed += 1
	
	if no_stopping_now_progress == 20 and not ooh_shiny_mine_i:
		no_stopping_now_iii = true
		achievement_completed += 1
	if killing_machine_progress == 50 and not killing_machine_iii:
		killing_machine_iii = true
		achievement_completed += 1
	if ooh_shiny_mine_progress == 60 and not ooh_shiny_mine_iii:
		ooh_shiny_mine_iii = true
		achievement_completed += 1
	if quest_hunter_progress == 10 and not quest_hunter_iii:
		quest_hunter_iii = true
		achievement_completed += 1
	if social_expert_progress == 12 and not social_expert_iii:
		social_expert_iii = true
		achievement_completed += 1


func _physics_process(_delta):
	player_maxhealth = achievement_completed + 3
