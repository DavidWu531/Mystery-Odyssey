extends Node2D

# Achievements
var grassland_explored = false  # New Planet, Who Dis?
var desert_explored = false  # MORE POWER!!
var frostland_explored = false  # Don’t slide off!
var enter_cave = false  # Anyone got a torch?
var escape_cave = false  # My brain hurts
var one_heart_escape = false  # Unbreakable
var u_cant_c_me = false  # U Can’t C Me
var eagle_eye = false  # Eagle Eye
var cant_let_go = false  # Can’t let go
var ultra_insticto = false  # Untouchable
var fire_my_laser = false  # MY EYES!!
var no_cheese = false  # This isn’t cheese
var i_c_u = false  # Security first
var not_safe = false  # I thought this was safe...
var weeee = false  # Yaahoohoohoo!

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
var weeee_progress = 0
var not_safe_progress = 0
var no_stopping_now_progress = 0
var killing_machine_progress = 0
var ooh_shiny_mine_progress = 0
var quest_hunter_progress = 0
var social_expert_progress = 0

# Other variables
var score = 0
var player_health = 3
var player_maxhealth = 3
var player_energy = 50
var player_maxenergy = 50
var player_speed = 0
var time_elapsed = 0.0
var time_left = 180.0
var achievement_completed = 0
var torch_level = 2
var boss_health = 1000
var spectator = false


func _ready() -> void:
	score = 0
	player_health = 3
	player_maxhealth = 3
	player_energy = 50
	player_maxenergy = 50
	player_speed = 0
	time_elapsed = 0
	time_left = 180
	achievement_completed = 0
	torch_level = 2
	boss_health = 1000 * Settings.difficulty_amplifier
	spectator = false
	
	grassland_explored_progress = 0
	desert_explored_progress = 0
	frostland_explored_progress = 0
	enter_cave_progress = 0
	escape_cave_progress = 0
	one_heart_escape_progress = 0
	u_cant_c_me_progress = 0
	eagle_eye_progress = 0
	cant_let_go_progress = 0
	ultra_insticto_progress = 0
	fire_my_laser_progress = 0
	no_cheese_progress = 0
	i_c_u_progress = 0
	weeee_progress = 0
	not_safe_progress = 0
	no_stopping_now_progress = 0
	killing_machine_progress = 0
	ooh_shiny_mine_progress = 0
	quest_hunter_progress = 0
	social_expert_progress = 0

	no_stopping_now_i = false
	no_stopping_now_ii = false
	no_stopping_now_iii = false
	killing_machine_i = false
	killing_machine_ii = false
	killing_machine_iii = false
	ooh_shiny_mine_i = false
	ooh_shiny_mine_ii = false
	ooh_shiny_mine_iii = false
	quest_hunter_i = false
	quest_hunter_ii = false
	quest_hunter_iii = false
	social_expert_i = false
	social_expert_ii = false
	social_expert_iii = false
	
	grassland_explored = false
	desert_explored = false
	frostland_explored = false
	enter_cave = false
	escape_cave = false
	one_heart_escape = false
	u_cant_c_me = false
	eagle_eye = false
	cant_let_go = false
	ultra_insticto = false
	fire_my_laser = false
	no_cheese = false
	i_c_u = false
	not_safe = false
	weeee = false
	
	if Settings.gamemode != "Creative":
		player_maxhealth = achievement_completed + 3
	
		if not spectator:
			player_maxenergy = 50 * (1 + (quest_hunter_progress * 0.1))
			torch_level = int(0.5 * achievement_completed + 2)
			player_maxhealth = 3
		else:
			player_maxenergy = INF
			torch_level = 100
	else:
		player_maxhealth = INF
		torch_level = 100
		player_maxenergy = INF

func _process(_delta):
	if grassland_explored_progress == 200 and not grassland_explored:
		grassland_explored = true
		SignalBus.achievement_completed.emit()
		SignalBus.grassland_explored.emit()
		achievement_completed += 1
	if desert_explored_progress == 200 and not desert_explored:
		desert_explored = true
		SignalBus.achievement_completed.emit()
		SignalBus.desert_explored.emit()
		achievement_completed += 1
	if frostland_explored_progress == 200 and not frostland_explored:
		frostland_explored = true
		SignalBus.achievement_completed.emit()
		SignalBus.frostland_explored.emit()
		achievement_completed += 1
	if enter_cave_progress == 1 and not enter_cave:
		enter_cave = true
		SignalBus.achievement_completed.emit()
		SignalBus.enter_cave.emit()
		achievement_completed += 1
	if escape_cave_progress == 1 and not escape_cave:
		escape_cave = true
		SignalBus.achievement_completed.emit()
		SignalBus.escape_cave.emit()
		achievement_completed += 1
	if one_heart_escape_progress == 1 and not one_heart_escape:
		one_heart_escape = true
		SignalBus.achievement_completed.emit()
		SignalBus.one_heart_escape.emit()
		achievement_completed += 1
	if u_cant_c_me_progress == 1 and not u_cant_c_me:
		u_cant_c_me = true
		SignalBus.achievement_completed.emit()
		SignalBus.u_cant_c_me.emit()
		achievement_completed += 1
	if eagle_eye_progress == 1 and not eagle_eye:
		eagle_eye = true
		SignalBus.achievement_completed.emit()
		SignalBus.eagle_eye.emit()
		achievement_completed += 1
	if cant_let_go_progress == 1 and not cant_let_go:
		cant_let_go = true
		SignalBus.achievement_completed.emit()
		SignalBus.cant_let_go.emit()
		achievement_completed += 1
	if ultra_insticto_progress == 1 and not ultra_insticto:
		ultra_insticto = true
		SignalBus.achievement_completed.emit()
		SignalBus.ultra_insticto.emit()
		achievement_completed += 1
	if fire_my_laser_progress == 1 and not fire_my_laser:
		fire_my_laser = true
		SignalBus.achievement_completed.emit()
		SignalBus.fire_my_laser.emit()
		achievement_completed += 1
	if no_cheese_progress == 1 and not no_cheese:
		no_cheese = true
		SignalBus.achievement_completed.emit()
		SignalBus.no_cheese.emit()
		achievement_completed += 1
	if i_c_u_progress == 1 and not i_c_u:
		i_c_u = true
		SignalBus.achievement_completed.emit()
		SignalBus.i_c_u.emit()
		achievement_completed += 1
	if not_safe_progress == 1 and not not_safe:
		not_safe = true
		SignalBus.achievement_completed.emit()
		SignalBus.not_safe.emit()
		achievement_completed += 1
	if weeee_progress == 1 and not weeee:
		weeee = true
		SignalBus.achievement_completed.emit()
		SignalBus.weeee.emit()
		achievement_completed += 1

	if no_stopping_now_progress == 1 and not no_stopping_now_i:
		no_stopping_now_i = true
		SignalBus.achievement_completed.emit()
		SignalBus.no_stopping_now_i.emit()
		achievement_completed += 1
	if killing_machine_progress == 1 and not killing_machine_i:
		killing_machine_i = true
		SignalBus.achievement_completed.emit()
		SignalBus.killing_machine_i.emit()
		achievement_completed += 1
	if ooh_shiny_mine_progress == 1 and not ooh_shiny_mine_i:
		ooh_shiny_mine_i = true
		SignalBus.achievement_completed.emit()
		SignalBus.ooh_shiny_mine_i.emit()
		achievement_completed += 1
	if quest_hunter_progress == 2 and not quest_hunter_i:
		quest_hunter_i = true
		SignalBus.achievement_completed.emit()
		SignalBus.quest_hunter_i.emit()
		achievement_completed += 1
	if social_expert_progress == 2 and not social_expert_i:
		social_expert_i = true
		SignalBus.achievement_completed.emit()
		SignalBus.social_expert_i.emit()
		achievement_completed += 1
	
	if no_stopping_now_progress == 10 and not no_stopping_now_ii:
		no_stopping_now_ii = true
		SignalBus.achievement_completed.emit()
		SignalBus.no_stopping_now_ii.emit()
		achievement_completed += 1
	if killing_machine_progress == 10 and not killing_machine_ii:
		killing_machine_ii = true
		SignalBus.achievement_completed.emit()
		SignalBus.killing_machine_ii.emit()
		achievement_completed += 1
	if ooh_shiny_mine_progress == 25 and not ooh_shiny_mine_ii:
		ooh_shiny_mine_ii = true
		SignalBus.achievement_completed.emit()
		SignalBus.ooh_shiny_mine_ii.emit()
		achievement_completed += 1
	if quest_hunter_progress == 5 and not quest_hunter_ii:
		quest_hunter_ii = true
		SignalBus.achievement_completed.emit()
		SignalBus.quest_hunter_ii.emit()
		achievement_completed += 1
	if social_expert_progress == 6 and not social_expert_ii:
		social_expert_ii = true
		SignalBus.achievement_completed.emit()
		SignalBus.social_expert_ii.emit()
		achievement_completed += 1
	
	if no_stopping_now_progress == 30 and not no_stopping_now_iii:
		no_stopping_now_iii = true
		SignalBus.achievement_completed.emit()
		SignalBus.no_stopping_now_iii.emit()
		achievement_completed += 1
	if killing_machine_progress == 20 and not killing_machine_iii:
		killing_machine_iii = true
		SignalBus.achievement_completed.emit()
		SignalBus.killing_machine_iii.emit()
		achievement_completed += 1
	if ooh_shiny_mine_progress == 60 and not ooh_shiny_mine_iii:
		ooh_shiny_mine_iii = true
		SignalBus.achievement_completed.emit()
		SignalBus.ooh_shiny_mine_iii.emit()
		achievement_completed += 1
	if quest_hunter_progress == 10 and not quest_hunter_iii:
		quest_hunter_iii = true
		SignalBus.achievement_completed.emit()
		SignalBus.quest_hunter_iii.emit()
		achievement_completed += 1
	if social_expert_progress == 12 and not social_expert_iii:
		social_expert_iii = true
		SignalBus.achievement_completed.emit()
		SignalBus.social_expert_iii.emit()
		achievement_completed += 1


func _physics_process(_delta):
	if Settings.gamemode != "Creative":
		player_maxhealth = achievement_completed + 3
	
		if not spectator:
			player_maxenergy = 50 * (1 + (quest_hunter_progress * 0.1))
			torch_level = int(0.5 * achievement_completed + 2)
		else:
			player_maxenergy = INF
			torch_level = 100
	else:
		player_maxhealth = INF
		player_health = player_maxhealth
		torch_level = 100
		player_maxenergy = INF
		player_energy = player_maxenergy
