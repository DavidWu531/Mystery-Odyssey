extends Node


signal checkpoint_i_hit
signal checkpoint_ii_hit
signal checkpoint_iii_hit
signal checkpoint_iv_hit
signal checkpoint_v_hit
signal checkpoint_vi_hit

signal player_died
signal sign_movement_touch
signal npc_talked
signal coin_collected
signal npci_dialogue
signal achievement_completed

signal default_silhouette
signal double_jump_silhouette
signal gravity_flip_silhouette
signal linear_motion_silhouette

var checkpoint_i_available = true
var checkpoint_i_emitted = false
var checkpoint_ii_available = false
var checkpoint_ii_emitted = false
var checkpoint_iii_available = false
var checkpoint_iii_emitted = false
var checkpoint_iv_available = false
var checkpoint_iv_emitted = false
var checkpoint_v_available = false
var checkpoint_v_emitted = false
var checkpoint_vi_available = false
var checkpoint_vi_emitted = false

signal grassland_explored
signal desert_explored
signal frostland_explored
signal enter_cave
signal escape_cave
signal one_heart_escape
signal u_cant_c_me
signal eagle_eye
signal cant_let_go
signal ultra_insticto
signal fire_my_laser
signal no_cheese
signal i_c_u
signal not_safe
signal weeee

signal no_stopping_now_i
signal no_stopping_now_ii
signal no_stopping_now_iii
signal killing_machine_i
signal killing_machine_ii
signal killing_machine_iii
signal ooh_shiny_mine_i
signal ooh_shiny_mine_ii
signal ooh_shiny_mine_iii
signal quest_hunter_i
signal quest_hunter_ii
signal quest_hunter_iii
signal social_expert_i
signal social_expert_ii
signal social_expert_iii

signal doomed
signal undoomed

func _ready():
	checkpoint_i_hit.connect(e)
	checkpoint_ii_hit.connect(e)
	checkpoint_iii_hit.connect(e)
	checkpoint_iv_hit.connect(e)
	checkpoint_v_hit.connect(e)
	checkpoint_vi_hit.connect(e)
	
	player_died.connect(e)
	sign_movement_touch.connect(e)
	npc_talked.connect(e)
	coin_collected.connect(e)
	npci_dialogue.connect(e)
	achievement_completed.connect(e)
	
	default_silhouette.connect(e)
	double_jump_silhouette.connect(e)
	gravity_flip_silhouette.connect(e)
	linear_motion_silhouette.connect(e)

	grassland_explored.connect(e)
	desert_explored.connect(e)
	frostland_explored.connect(e)
	enter_cave.connect(e)
	escape_cave.connect(e)
	one_heart_escape.connect(e)
	u_cant_c_me.connect(e)
	eagle_eye.connect(e)
	cant_let_go.connect(e)
	ultra_insticto.connect(e)
	fire_my_laser.connect(e)
	no_cheese.connect(e)
	i_c_u.connect(e)
	not_safe.connect(e)
	weeee.connect(e)

	no_stopping_now_i.connect(e)
	no_stopping_now_ii.connect(e)
	no_stopping_now_iii.connect(e)
	killing_machine_i.connect(e)
	killing_machine_ii.connect(e)
	killing_machine_iii.connect(e)
	ooh_shiny_mine_i.connect(e)
	ooh_shiny_mine_ii.connect(e)
	ooh_shiny_mine_iii.connect(e)
	quest_hunter_i.connect(e)
	quest_hunter_ii.connect(e)
	quest_hunter_iii.connect(e)
	social_expert_i.connect(e)
	social_expert_ii.connect(e)
	social_expert_iii.connect(e)
	
	doomed.connect(e)
	undoomed.connect(e)
	

func _process(_delta):
	pass
	

func e():
	pass
