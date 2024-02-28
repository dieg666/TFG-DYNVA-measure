extends Control

signal save_is_done
signal override(choice)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$YesOrNoVBoxContainer.hide()
	pass # Replace with function body.

func modify_edit_text(text):
	$VBoxContainer/LineEdit.text = text
func modify_label_text(text):
	$VBoxContainer/Label2.text = text
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func get_edited_text():
	return $VBoxContainer/LineEdit.text

func _on_HUD_show_override():
	$YesOrNoVBoxContainer/Label.text = "Test '"+ text+ "' already exists. Do you want to override?"
	$VBoxContainer.hide()
	$YesOrNoVBoxContainer.visible = false
	$YesOrNoVBoxContainer.call_deferred("set_visible", true)
	$YesOrNoVBoxContainer.show()
	pass # Replace with function body.



func _on_Button_pressed():
	if $VBoxContainer/LineEdit.text == '':
		$VBoxContainer/Label2.text = 'Name can\'t be empty'
	elif $VBoxContainer/LineEdit.text[0] == ' ':
		$VBoxContainer/Label2.text = 'Name can\'t be start with whitespace'
	else:
		emit_signal("save_is_done")
	pass # Replace with function body.


func _on_YesButton_pressed():
	$YesOrNoVBoxContainer.hide()
	$VBoxContainer.show()
	emit_signal("override", true)
	$VBoxContainer/LineEdit.text = ''
	pass # Replace with function body.

func _on_NoButton_pressed():
	$VBoxContainer.show()
	$YesOrNoVBoxContainer.hide()
	emit_signal("override", false)
	$VBoxContainer/LineEdit.text = ''
	$VBoxContainer/LineEdit.text = ''


func _on_HUD_show_override():
	$YesOrNoVBoxContainer/Label.text = "Test '"+ $VBoxContainer/LineEdit.text + "' already exists. Do you want to override?"
	$VBoxContainer.hide()
	visible = false
	call_deferred("set_visible", true)
	$YesOrNoVBoxContainer.show()
	pass # Replace with function body.
