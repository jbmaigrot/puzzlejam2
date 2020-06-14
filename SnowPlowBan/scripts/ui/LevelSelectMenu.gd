extends Control


func _ready():
	Globals.psengine.get_level_state();
	

	
func back_button_pressed():
	Globals.load_main_menu()
	

func level_button_pressed(world_idx, level_idx):
	print(str(world_idx)+"."+str(level_idx))
	Globals.load_level(world_idx,level_idx)


func _on_Button_Back_pressed():
	Globals.load_main_menu();
