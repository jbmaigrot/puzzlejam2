extends Control


const OPTIONS_HUD_SCENE = preload("res://scenes/ui/OptionsHUD.tscn")
const MAIN_MENU_SCENE = preload("res://scenes/ui/MainMenu.tscn")
const LEVEL_MENU_SCENE = preload("res://scenes/ui/LevelSelectMenu.tscn")

var current

# Called when the node enters the scene tree for the first time.
func _ready():
	$CenterContainer.add_child(MAIN_MENU_SCENE.instance());
	$OptionsContainer.add_child(OPTIONS_HUD_SCENE.instance());
	

func display_level_select():
	clear_center_children();
	$CenterContainer.add_child(LEVEL_MENU_SCENE.instance());
	
func clear_center_children():
	for child in $CenterContainer.get_children():
		child.queue_free();
