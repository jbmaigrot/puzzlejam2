extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS

func _on_NextLevelButton_pressed():
	if !Globals.load_next_level() :
		$Label.text = "This was the last level, congrats !";


func _on_LelelSelectButton_pressed():
	Globals.load_level_select_menu();
