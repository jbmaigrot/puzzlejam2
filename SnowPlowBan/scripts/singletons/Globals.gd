extends Node

const GAME_RULES_FILE = "res://psionic/snowplowban_rules.tres"

const MAIN_MENU_PATH = "res://scenes/ui/MainMenu.tscn"
const LEVEL_SELECT_MENU_PATH = "res://scenes/ui/LevelSelectMenu.tscn"

const LEVEL_PATH = preload("res://scenes/game/level.tscn")

const OPTIONS_HUD_SCENE = preload("res://scenes/ui/OptionsHUD.tscn")
const MAIN_MENU_SCENE = preload("res://scenes/ui/MainMenu.tscn")
const MAIN_SCREEN_SCENE = preload("res://scenes/ui/MainScreen.tscn")

var psengine;

var level_scene;
var main_screen;

var gui_canvas_layer = null

# Called when the node enters the scene tree for the first time.
func _ready():
	psengine = GDPSEngine.new()
	psengine.load_game_from_file_path(GAME_RULES_FILE)
	
	gui_canvas_layer = CanvasLayer.new()
	get_tree().root.call_deferred("add_child", gui_canvas_layer)
	
	#setup main menu
	main_screen = MAIN_SCREEN_SCENE.instance() 
	gui_canvas_layer.add_child(main_screen)
	
	#setup 3D scene
	level_scene = LEVEL_PATH.instance() 
	get_tree().root.call_deferred("add_child", level_scene)
	psengine.load_level(0);
	level_scene.reset_level();
	level_scene.set_game_camera_position(false);
	
	#get_tree().paused = true;

func load_main_menu():
	pass
	
func load_level_select_menu():
	main_screen.display_level_select();

func load_level(level_index):
	psengine.load_level(level_index);
	main_screen.clear_center_children();
	level_scene.reset_level();
	
func resume_game():
	main_screen.clear_center_children();
