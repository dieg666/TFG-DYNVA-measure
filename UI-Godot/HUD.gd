extends Control
signal start_game
signal show_override
signal exit 
var state = 0
var swing = false
var node_selected = ''
var dict = {}
var mode = 0
func _click():
	pass

func do_a_left_click():
	var a = InputEventMouseButton.new()
	a.set_button_index(1)
	a.set_pressed(true)
	Input.parse_input_event(a)
	print($PanelContainer/HBoxContainer/VBoxContainer/VBoxContainer/HBoxContainer3/SpinBox.text)
# Called when the node enters the scene tree for the first time.
func _ready():
	$SaveView.hide()
func getData():
	return dict
func initialize(d):
	Utils.delete_children($PanelContainer/HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer)
	dict = d
	for item in d:
		var buttons_pck = preload("res://UI-Godot/ButtonSave.tscn")
		var buttons = buttons_pck.instance()
		buttons.connect("load_is_done", self, "_load_is_done" )
		buttons.text = item.split("///")[1]
		buttons.mode = item.split("///")[0]
		if buttons.text == node_selected:
			buttons.pressed()
		$PanelContainer/HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer.add_child(buttons)
func _on_Start_pressed():
	emit_signal("start_game")
func _on_DirectionOptionButton_item_selected(index):
	state = index
func _on_SizeSeriesCheckBox_pressed():
	if !$PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/SizeSeriesCheckBox.pressed:
		$PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/SizeSeriesCheckBox.pressed = true
	$PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/SpeedSeriesCheckBox.pressed = false
	mode = false
	pass # Replace with function body.
func _on_SpeedSeriesCheckBox_pressed():
	if !$PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/SpeedSeriesCheckBox.pressed:
		$PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/SpeedSeriesCheckBox.pressed = true
	$PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/SizeSeriesCheckBox.pressed = false
	mode = true
func _on_TestsBoxVBoxContainer_add():
	for button in $PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer.get_children():
		if button.is_Pressed() == 2:
			var buttons_pck = preload("res://UI-Godot/VBoxContainer.tscn")
			var new_button = buttons_pck.instance()
			new_button.connect("delete", self, "_on_TestsBoxVBoxContainer_delete" )
			new_button.connect("add", self, "_on_TestsBoxVBoxContainer_add" )
			$PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer.add_child_below_node(button,new_button)
			button.reset_click()
			return
func _on_TestsBoxVBoxContainer_delete():
	if $PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer.get_children().size() == 1:
		return 
	for button in $PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer.get_children():
		if button.is_Pressed() == 1:
			$PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer.remove_child(button)
			return
func _on_ExitButton_pressed():
	emit_signal("exit")
func _on_NewSingleTestButton_pressed():
	for item in $PanelContainer/HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer.get_children():
		item.pressed = false
	var buttons_pck = preload("res://UI-Godot/VBoxContainer.tscn")
	var buttons = buttons_pck.instance()
	buttons.connect("delete", self, "_on_TestsBoxVBoxContainer_delete" )
	buttons.connect("add", self, "_on_TestsBoxVBoxContainer_add" )
	Utils.delete_children($PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer)
	$PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer.add_child(buttons)	
func _on_SwingButton_toggled(button_pressed):
	swing = button_pressed # Replace with function body.	
func _save_test_pressed():
	if $PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer.get_child_count() != 0:
		for item in $PanelContainer/HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer.get_children():
			if item.is_pressed():
				$SaveView.modify_edit_text(item.text)
		$PanelContainer.hide()
		$CheckBox.hide()
		$SaveView.show()
func filename_exists(file_name):
	for item in $PanelContainer/HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer.get_children():
		if item.text == file_name:
			return true
	return false
func get_values(list):
	var l = []
	for item in list:
		l.append(item.value())
	return l
func _get_key_from_dict(value):
	for i in dict.keys():
		if value == i.split("///")[1]:
			return i
	return ""
func _load_is_done(id):
	for item in $PanelContainer/HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer.get_children():
		if item.get_instance_id() != id:
			item.remove_press()
	for item in $PanelContainer/HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer.get_children():
		if item.is_pressed():
			Utils.delete_children($PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer)
			for k in dict[item.text]:
				var buttons_pck = preload("res://UI-Godot/VBoxContainer.tscn")
				var buttons = buttons_pck.instance()
				buttons.connect("delete", self, "_on_TestsBoxVBoxContainer_delete" )
				buttons.connect("add", self, "_on_TestsBoxVBoxContainer_add" )
				buttons.set_value(k)
				change_to_mode(_get_key_from_dict(item.text))
				i += 1
				$PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer.add_child(buttons)
func _OnSaveView__done():
	var value =  $SaveView.get_edited_text()
	if filename_exists(value):
		$SaveView.modify_edit_text(value)
		emit_signal("show_override")
	else:
		save(value)
func _on_DeleteSingleTestButton_pressed():
	for item in $PanelContainer/HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer.get_children():
		if item.is_pressed():
			dict.erase(_get_key_from_dict(item.text))
			$PanelContainer/HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer.remove_child(item)
			Utils.delete_children($PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer)
			return 
func save(encoded_mode, value):
	$PanelContainer.show()
	$CheckBox.show()
	$SaveView.hide()
	var buttons_pck = preload("res://UI-Godot/ButtonSave.tscn")
	dict[value] = get_values($PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer.get_children())
	$SaveView.modify_edit_text("")
	initialize(dict)

func _on_SaveView_override(choice):
	if choice:	
		var value = $SaveView.get_edited_text()
		save(value)
	else:
		_save_test_pressed()
func _get_mode():
	var encoded_mode = ''
	encoded_mode += str(int($PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/Button.pressed))
	encoded_mode += str(int(!$PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/CheckBox.pressed))
	encoded_mode += str(state)
	encoded_mode += str(int($PanelContainer/HBoxContainer/VBoxContainer/VBoxContainer/HBoxContainer3/CheckButton.pressed))
	encoded_mode += str($PanelContainer/HBoxContainer/VBoxContainer/VBoxContainer/HBoxContainer3/SpinBox.text)
	encoded_mode += "///"
	return encoded_mode
func _on_CheckButton_pressed():
	if $PanelContainer/HBoxContainer/VBoxContainer/VBoxContainer/HBoxContainer3/CheckButton.pressed:
		$PanelContainer/HBoxContainer/VBoxContainer/VBoxContainer/HBoxContainer3/Label.text = "%"
	elif $PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/CheckBox.pressed:
		$PanelContainer/HBoxContainer/VBoxContainer/VBoxContainer/HBoxContainer3/Label.text = "logMAR"
	elif $PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/CheckBox2.pressed:
		$PanelContainer/HBoxContainer/VBoxContainer/VBoxContainer/HBoxContainer3/Label.text = "º/s"

	pass # Replace with function body.


func _on_LinkButton_pressed():
	OS.execute("rundll32",["url.dll","FileProtocolHandler","https://github.com/dieg666/TFG-DYNVA-measure/blob/main/TFG-2.pdf"])
	pass # Replace with function body.



func _on_SpinBox_value_changed(value):
	pass
