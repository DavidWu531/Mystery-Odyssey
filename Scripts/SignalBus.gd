extends Node

signal checkpoint_i_hit
signal checkpoint_ii_hit

signal player_died
signal sign_movement_touch
signal npc_talked
signal coin_collected
signal npci_dialogue

var checkpoint_i_available = true
var checkpoint_i_emitted = false
var checkpoint_ii_available = false
var checkpoint_ii_emitted = false

func _ready():
	pass

func _process(_delta):
	pass
