extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$HBoxContainer/PanelContainer/VBoxContainer/CheckButtonMusic.connect("toggled",AudioManager,"music_toggled")
	$HBoxContainer/PanelContainer/VBoxContainer/CheckButtonSounds.connect("toggled",AudioManager, "sounds_toggled")


