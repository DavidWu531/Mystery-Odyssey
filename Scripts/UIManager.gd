extends CanvasLayer

var quests = { 
	"Talk to the NPC": 1,  # Max 1
	"Collect Coins": 10  # Max 10
}

var npci_dialogue_id = 0

var quests_completed = 0
var current_quest = quests.keys()[quests_completed]
var current_quest_max = quests.get(current_quest)
var current_quest_progress = 0

func _ready():
	SignalBus.npc_talked.connect(npc_talked)
	SignalBus.coin_collected.connect(coin_collected)


func _process(delta):
	if quests_completed < 1:
		if current_quest_progress == current_quest_max:
			quests_completed += 1
			current_quest_progress = 0
			current_quest = quests.keys()[quests_completed]
			current_quest_max = quests.get(current_quest)
	
	$MainScreen/Quest/Label.text = "Quest: \n" + str(current_quest) + "\n(" + str(current_quest_progress) + "/" + str(current_quest_max) + ")"
	
	$PauseMenu/Score.text = "Score: " + str(Global.score)
	
	$MainScreen/PlayerHealth.size = Vector2(Global.player_health * 38, 32)
	
	Global.time_elapsed += delta
	$MainScreen/TimeElapsed.text = str(Global.time_elapsed).pad_decimals(2)
	
	Global.player_energy -= 0.01
	
	$MainScreen/PlayerEnergy.max_value = 200
	$MainScreen/PlayerEnergy.value = Global.player_energy

func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().paused = false
		$PauseMenu.hide()


func _on_continue_pressed():
	$PauseMenu.hide()
	get_tree().paused = false


func npc_talked():
	if current_quest == "Talk to the NPC":
		current_quest_progress += 1


func coin_collected():
	if current_quest == "Collect Coins":
		current_quest_progress += 1
