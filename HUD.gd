extends CanvasLayer
signal start_game
var state = 0
var swing = false
var mode = true
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Start_pressed():
	emit_signal("start_game")
	
	pass
func _on_DirectionOptionButton_item_selected(index):
	state = index


func _on_Button_toggled(button_pressed):
	swing = button_pressed # Replace with function body.

func _on_CheckBox2_pressed():
	if !$PanelContainer/HBoxContainer/VBoxContainer/CheckBox2.pressed:
		$PanelContainer/HBoxContainer/VBoxContainer/CheckBox2.pressed = true
	$PanelContainer/HBoxContainer/VBoxContainer/CheckBox.pressed = false
	mode = false
	pass # Replace with function body.


func _on_CheckBox_pressed():
	if !$PanelContainer/HBoxContainer/VBoxContainer/CheckBox.pressed:
		$PanelContainer/HBoxContainer/VBoxContainer/CheckBox.pressed = true
	$PanelContainer/HBoxContainer/VBoxContainer/CheckBox2.pressed = false
	mode = true
