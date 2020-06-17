extends VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS



func _on_Button_pressed():
	Globals.resume_game();


func _on_Button2_pressed():
	Globals.load_level_select_menu();
