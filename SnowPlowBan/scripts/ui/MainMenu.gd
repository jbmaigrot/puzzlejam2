extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	pass # Replace with function body.


func _on_Button_Start_pressed():
	Globals.resume_game();


func _on_Button_Levels_pressed():
	Globals.load_level_select_menu();


func _on_Button_Quit_pressed():
	print("not yet done")
	pass # Replace with function body.
