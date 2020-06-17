extends Control


const OPTIONS_HUD_SCENE = preload("res://scenes/ui/OptionsHUD.tscn")
const MAIN_MENU_SCENE = preload("res://scenes/ui/MainMenu.tscn")
const LEVEL_MENU_SCENE = preload("res://scenes/ui/LevelSelectMenu.tscn")
const COMPLETION_MENU_SCENE = preload("res://scenes/ui/CompletionMenu.tscn")
const PAUSE_MENU_SCENE = preload("res://scenes/ui/PauseMenu.tscn")

var current

# Called when the node enters the scene tree for the first time.
func _ready():
	display_main_menu();
	$OptionsContainer.add_child(OPTIONS_HUD_SCENE.instance());
	
func display_pause_menu():
	clear_center_children();
	$CenterContainer.add_child(PAUSE_MENU_SCENE.instance());

func display_completion_menu():
	clear_center_children();
	$CenterContainer.add_child(COMPLETION_MENU_SCENE.instance());

func display_main_menu():
	clear_center_children();
	$CenterContainer.add_child(MAIN_MENU_SCENE.instance());

func display_level_select():
	clear_center_children();
	$CenterContainer.add_child(LEVEL_MENU_SCENE.instance());
	
func clear_center_children():
	for child in $CenterContainer.get_children():
		child.queue_free();
