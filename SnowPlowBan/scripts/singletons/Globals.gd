extends Node

const GAME_RULES_FILE = "res://psionic/snowplowban_rules.tres"

const MAIN_MENU_PATH = "res://scenes/ui/MainMenu.tscn"
const LEVEL_SELECT_MENU_PATH = "res://scenes/ui/LevelSelectMenu.tscn"

const LEVEL_PATH = "res://scenes/game/level.tscn"

const OPTIONS_HUD_SCENE = preload("res://scenes/ui/OptionsHUD.tscn")

var psengine;

var gui_canvas_layer = null

# Called when the node enters the scene tree for the first time.
func _ready():
	psengine = GDPSEngine.new()
	psengine.load_game_from_file_path(GAME_RULES_FILE)
	
	gui_canvas_layer = CanvasLayer.new()
	
	var options_hud = OPTIONS_HUD_SCENE.instance() 
	gui_canvas_layer.add_child(options_hud)
	get_tree().root.call_deferred("add_child", gui_canvas_layer)

func load_new_scene(new_scene_path):
	get_tree().change_scene(new_scene_path)

func load_main_menu():
	load_new_scene(MAIN_MENU_PATH)
	
func load_level_select_menu():
	load_new_scene(LEVEL_SELECT_MENU_PATH)

func load_level(level_index):
	psengine.load_level(level_index);
	load_new_scene(LEVEL_PATH);
