extends Control


func _ready():
	var level_count = Globals.psengine.get_level_count();
	var grid_width = ceil(sqrt(level_count));
	
	$VBoxContainer/GridContainer.columns = grid_width;
	
	for i in range(0,level_count-1):
		var button = Button.new();
		button.text = str(i+1)
		button.connect("pressed",self, "level_button_pressed", [i])
		$VBoxContainer/GridContainer.add_child(button)

func level_button_pressed(level_idx):
	print("loading level "+str(level_idx))
	Globals.load_level(level_idx)


func _on_Button_Back_pressed():
	Globals.load_main_menu();
