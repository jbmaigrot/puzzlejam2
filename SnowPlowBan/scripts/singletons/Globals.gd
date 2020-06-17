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

var current_level = 0;

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
	psengine.load_level(current_level);
	level_scene.reset_level();
	level_scene.set_game_camera_position(false);
	
	get_tree().paused = true;

func load_next_level():
	return load_level(current_level +1)
	
func load_pause_menu():
	get_tree().paused = true;
	main_screen.display_pause_menu();
	level_scene.set_game_camera_position(false);

func load_completion_menu():
	get_tree().paused = true;
	main_screen.display_completion_menu();
	level_scene.set_game_camera_position(false);
	
func load_main_menu():
	get_tree().paused = true;
	main_screen.display_main_menu();
	level_scene.set_game_camera_position(false);
	
func load_level_select_menu():
	get_tree().paused = true;
	main_screen.display_level_select();
	level_scene.set_game_camera_position(false);

func load_level(level_index):
	if level_index >= psengine.get_level_count():
		return false
	current_level = level_index;
	get_tree().paused = false;
	psengine.load_level(level_index);
	main_screen.clear_center_children();
	level_scene.reset_level();
	level_scene.set_game_camera_position(true);
	return true;
	
func resume_game():
	get_tree().paused = false;
	main_screen.clear_center_children();
	level_scene.set_game_camera_position(true);
